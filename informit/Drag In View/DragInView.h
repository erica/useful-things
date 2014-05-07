/*
 
 Erica Sadun, http://ericasadun.com
 
 */

#import <UIKit/UIKit.h>

// Full size of the drawer
#define kDrawerExtent  320

// How much is seen when closed (minimum 32 please)
#define kClosedDrawExtent 32

// How much drawer is seen when open
#define kOpenDrawExtent 200

// How far the user has to drag to trigger the drawer to stay open
#define kTriggerPoint   260

// Handle dimensions
#define kHandleExtent   20
#define kHandleLength   50
#define kHandleInset    4

@interface DragInView : UIView
+ (instancetype) viewWithParent: (UIViewController *) parent side: (NSLayoutAttribute) side;
@property (nonatomic, readonly) UIImageView *handleView;
@end
