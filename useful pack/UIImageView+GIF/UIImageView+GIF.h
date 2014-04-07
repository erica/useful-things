/*
 
 Erica Sadun, http://ericasadun.com
 
 */

#import <UIKit/UIKit.h>

@interface UIImageView (GIFSupport)
- (void) loadGIFFromPath: (NSString *) gifPath;
- (instancetype) initWithGIFImagePath: (NSString *) gifPath;
@end
