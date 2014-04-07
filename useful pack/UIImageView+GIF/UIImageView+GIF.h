/*
 
 Erica Sadun, http://ericasadun.com
 
 */

#import <UIKit/UIKit.h>

@interface UIImageView (GIFSupport)
- (void) loadGIFWithData: (NSData *) gifData;
- (void) loadGIFFromURL: (NSURL *) url;
- (void) loadGIFFromPath: (NSString *) gifPath;

- (instancetype) initWithGIFImagePath: (NSString *) gifPath;
@end
