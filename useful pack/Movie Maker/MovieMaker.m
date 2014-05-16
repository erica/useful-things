/*
 
 Erica Sadun, http://ericasadun.com
 
 */

@import AVFoundation;
#import "MovieMaker.h"

@interface MovieMaker ()
@end

@implementation MovieMaker
{
    NSInteger height;
    NSInteger width;
    NSUInteger framesPerSecond;
    
    AVAssetWriter *writer;
    AVAssetWriterInput *input;
    AVAssetWriterInputPixelBufferAdaptor *adaptor;
    CVPixelBufferRef bufferRef;
    
    NSInteger frameCount;
}

+ (BOOL) preparePath: (NSString *) moviePath
{
    NSError *error;
    BOOL exists = [[NSFileManager defaultManager] fileExistsAtPath:moviePath];
    
    if (exists)
    {
        BOOL success = [[NSFileManager defaultManager] removeItemAtPath:moviePath error:&error];
        if (!success)
        {
            NSLog(@"Error removing existing movie at path %@: %@", moviePath, error.localizedFailureReason);
            return NO;
        }
    }
    
    return YES;
}

- (BOOL) createMovieAtPath: (NSString *) path
{
    NSError *error;
    
    // Create Movie URL
    NSURL *movieURL = [NSURL fileURLWithPath:path];
    if (!movieURL)
    {
        NSLog(@"Error creating URL from path (%@)", path);
        return NO;
    }

    // Create Asset Writer
    writer = [[AVAssetWriter alloc] initWithURL:movieURL fileType:AVFileTypeQuickTimeMovie error:&error];
    if (!writer)
    {
        NSLog(@"Error creating asset writer: %@", error.localizedDescription);
        return NO;
    }
    
    // Create Input
    NSDictionary *videoSettings =
    @{
      AVVideoCodecKey : AVVideoCodecH264,
      AVVideoWidthKey : @(width),
      AVVideoHeightKey : @(height),
      };
    
    input = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeVideo outputSettings:videoSettings];
    if (!input)
    {
        writer = nil;
        NSLog(@"Error creating asset writer input");
        return NO;
    }
    
    [writer addInput:input];
    // input.expectsMediaDataInRealTime = YES;
    
    // Build adapter
    adaptor = [[AVAssetWriterInputPixelBufferAdaptor alloc] initWithAssetWriterInput:input sourcePixelBufferAttributes:nil];
    if (!adaptor)
    {
        writer = nil;
        input = nil;
        NSLog(@"Error creating pixel adaptor");
        return NO;
    }
    
    [writer startWriting];
    [writer startSessionAtSourceTime:kCMTimeZero];
    
    return YES;
}

- (instancetype) initWithPath: (NSString *) path frameSize: (CGSize) size fps: (NSUInteger)  fps
{
    if (!(self = [super init])) return self;
    
    // Path must be nil
    if ([[NSFileManager defaultManager] fileExistsAtPath:path])
    {
        NSLog(@"Error: Attempting to overwrite existing file. Please prepare path first.");
        return nil;
    }
    
    if (!path)
    {
        NSLog(@"Error: Path must be non-nil");
        return nil;
    }

    // Sizes must be divisible by 16
    height = lrint(size.height);
    width = lrint(size.width);
    if (((height % 16) != 0) || ((width % 16) != 0))
    {
        NSLog(@"Error: Height and Width must be divisible by 16");
        return nil;
    }
    
    // Store fps
    framesPerSecond = fps;
    if (fps == 0)
    {
        NSLog(@"Error: Frames per second must be positive integer");
    }
    
    frameCount = 0;
    
    BOOL success = [self createMovieAtPath:path];
    if (!success) return nil;
    
    return self;
}

+ (instancetype) createMovieAtPath: (NSString *) moviePath frameSize: (CGSize) size fps: (NSUInteger) framesPerSecond __attribute__ ((nonnull (1)))
{
    return [[self alloc] initWithPath:moviePath frameSize:size fps:framesPerSecond];
}

- (BOOL) createPixelBuffer
{
    if (bufferRef) CVPixelBufferRelease(bufferRef);
    
    // Create Pixel Buffer
    NSDictionary *pixelBufferOptions =
    @{
      (id) kCVPixelBufferCGImageCompatibilityKey : @YES,
      (id) kCVPixelBufferCGBitmapContextCompatibilityKey : @YES,
      };
    
    CVReturn status = CVPixelBufferCreate(
                                          kCFAllocatorDefault,
                                          width,
                                          height,
                                          kCVPixelFormatType_32ARGB,
                                          (__bridge CFDictionaryRef) pixelBufferOptions,
                                          &bufferRef);
    if (status != kCVReturnSuccess)
    {
        NSLog(@"Error creating pixel buffer");
        return NO;
    }
    
    return YES;
}

- (BOOL) drawToPixelBufferWithBlock: (ContextDrawingBlock) block __attribute__ ((nonnull))
{
    // I now create each time because there are massive data errors when re-using pixel buffers
    // if (![self createPixelBuffer]) return NO;
    if (!bufferRef)
    {
        BOOL status = [self createPixelBuffer];
        if (!status) return NO;
    }
    
    if (!block)
    {
        NSLog(@"Error: Missing block. Cannot draw to pixel buffer");
        return NO;
    }
    
    CVPixelBufferLockBaseAddress(bufferRef, 0);
    void *pixelData = CVPixelBufferGetBaseAddress(bufferRef);
    if (pixelData == NULL)
    {
        NSLog(@"Error retrieving pixel buffer base address");
        CVPixelBufferUnlockBaseAddress(bufferRef, 0);
        return NO;
    }
    
    CGColorSpaceRef RGBColorSpace = CGColorSpaceCreateDeviceRGB();
    if (RGBColorSpace == NULL)
    {
        NSLog(@"Error creating RGB colorspace");
        return NO;
    }
    
    CGContextRef context = CGBitmapContextCreate(pixelData,
                                                 width,
                                                 height,
                                                 8,
                                                 4 * width,
                                                 RGBColorSpace,
                                                 (CGBitmapInfo) kCGImageAlphaNoneSkipFirst);
    if (!context)
    {
        CGColorSpaceRelease(RGBColorSpace);
        CVPixelBufferUnlockBaseAddress(bufferRef, 0);
        NSLog(@"Error creating bitmap context");
        return NO;
    }
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    transform = CGAffineTransformScale(transform, 1.0f, -1.0f);
    transform = CGAffineTransformTranslate(transform, 0.0f, -height);
    CGContextConcatCTM(context, transform);
    
    // Perform drawing
    UIGraphicsPushContext(context);
    block(context);
    UIGraphicsPopContext();
    
    CGColorSpaceRelease(RGBColorSpace);
    CGContextRelease(context);
    CVPixelBufferUnlockBaseAddress(bufferRef, 0);
    
    return YES;
}

- (BOOL) appendPixelBuffer
{
    // Append pixel buffer
    while (!input.isReadyForMoreMediaData);
    frameCount++;
    BOOL success = [adaptor appendPixelBuffer:bufferRef withPresentationTime:CMTimeMake(frameCount, (int32_t) framesPerSecond)];
    if (!success)
    {
        NSLog(@"Error writing frame %zd", frameCount);
        return NO;
    }
    // NSLog(@"Wrote frame %d", frameCount);
    return YES;

}

- (BOOL) addImageToMovie: (UIImage *) image __attribute__ ((nonnull))
{
    if (!image) return NO;
    
    // Draw image to pixel buffer
    ContextDrawingBlock imageBlock = ^(CGContextRef context)
    {
        CGRect rect = CGRectMake(0, 0, width, height);
        [[UIColor blackColor] set];
        UIRectFill(rect);
        [image drawInRect:rect];
    };

    BOOL success = [self drawToPixelBufferWithBlock:imageBlock];
    if (!success) return NO;
    
    return [self appendPixelBuffer];
}

- (BOOL) addDrawingToMovie: (ContextDrawingBlock) drawingBlock __attribute__ ((nonnull))
{
    if (!drawingBlock) return NO;
    BOOL success = [self drawToPixelBufferWithBlock:drawingBlock];
    if (!success) return NO;
    return [self appendPixelBuffer];
}

- (void) finalizeMovie
{
    frameCount++;
    [input markAsFinished];
    [writer endSessionAtSourceTime:CMTimeMake(frameCount, (int32_t) framesPerSecond)];
    [writer finishWritingWithCompletionHandler:^{
        NSLog(@"Finished writing movie: %@", writer.outputURL.path);
        writer = nil;
        input = nil;
        adaptor = nil;
        CVPixelBufferRelease(bufferRef);
    }];
}
@end
