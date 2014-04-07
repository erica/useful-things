/*
 
 Erica Sadun, http://ericasadun.com
 
 */

#import "UIImageView+GIF.h"
@import QuartzCore;
@import ImageIO;

@implementation UIImageView (GIFSupport)

- (void) loadGIFWithData: (NSData *) gifData
{
    if (!gifData) return;
    
    NSMutableArray *frames = [NSMutableArray array];
    CFTimeInterval totalDuration = 0.0f;
    
    CGImageSourceRef sourceRef = CGImageSourceCreateWithData((__bridge CFDataRef) gifData, NULL);
    if (!sourceRef) return;
    size_t frameCount = CGImageSourceGetCount(sourceRef);
    
    for (NSUInteger index = 0; index < frameCount; index++)
    {
        // Fetch frame
        CGImageRef imageRef = CGImageSourceCreateImageAtIndex(sourceRef, index, NULL);
        UIImage *image = [[UIImage alloc] initWithCGImage:imageRef];
        [frames addObject:image];
        CGImageRelease(imageRef);
        
        // Fetch frame duration
        CFDictionaryRef properties = CGImageSourceCopyPropertiesAtIndex(sourceRef, index, NULL);
        CFDictionaryRef gifProperties = (CFDictionaryRef)CFDictionaryGetValue(properties, kCGImagePropertyGIFDictionary);
        NSNumber *frameDuration = (__bridge NSNumber *)CFDictionaryGetValue(gifProperties, kCGImagePropertyGIFDelayTime);
        totalDuration += frameDuration.floatValue;
        CFRelease(properties);
    }
    CFRelease(sourceRef);
    
    self.animationImages = frames;
    self.animationDuration = totalDuration;
    [self startAnimating];

}

- (void) loadGIFFromURL: (NSURL *) url
{
    if (!url) return;
    NSData *gifData = [NSData dataWithContentsOfURL:url];
    if (!gifData) return;
    [self loadGIFWithData:gifData];
}

// This is a really minimal implementation that assumes equally-spaced frames
- (void) loadGIFFromPath: (NSString *) gifPath
{
    if (!gifPath) return;
    NSData *gifData = [NSData dataWithContentsOfFile:gifPath];
    if (!gifData) return;
    [self loadGIFWithData:gifData];
}

- (instancetype) initWithGIFImagePath: (NSString *) gifPath
{
    if (!(self = [super initWithFrame:CGRectZero])) return self;
    if (gifPath) [self loadGIFFromPath:gifPath];
    return self;
}
@end
