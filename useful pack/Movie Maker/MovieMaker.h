/*
 
 Erica Sadun, http://ericasadun.com
 
 */

#import <Foundation/Foundation.h>

typedef void (^ContextDrawingBlock)(CGContextRef context);

@interface MovieMaker : NSObject
+ (BOOL) preparePath: (NSString *) moviePath;
+ (instancetype) createMovieAtPath: (NSString *) moviePath frameSize: (CGSize) size fps: (NSUInteger) framesPerSecond __attribute__ ((nonnull (1)));

- (BOOL) drawToPixelBufferWithBlock: (ContextDrawingBlock) block __attribute__ ((nonnull));
- (BOOL) appendPixelBuffer;
- (BOOL) addImageToMovie: (UIImage *) image __attribute__ ((nonnull));
- (BOOL) addDrawingToMovie: (ContextDrawingBlock) drawingBlock __attribute__ ((nonnull));
- (void) finalizeMovie;
@end
