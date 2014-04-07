/*
 
 Erica Sadun, http://ericasadun.com
 
 */

/*
 
 After triggering with a first tap-and-hold, this class recognizes one or more second-finger taps. For ilteris_
 
 */

#import <UIKit/UIKit.h>

@interface TriggeredTapGestureRecognizer : UIGestureRecognizer
@property (nonatomic, readonly) int count;
@property (nonatomic) NSTimeInterval minimumDelay;
@end
