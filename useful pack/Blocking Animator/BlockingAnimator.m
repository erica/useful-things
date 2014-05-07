/*
 
 Erica Sadun, http://ericasadun.com
 
 */

#import "BlockingAnimator.h"

NSRunLoop *runLoop;
void (^completion)(BOOL);

@interface BlockingAnimationDelegate : NSObject
@end

@implementation BlockingAnimationDelegate
- (void) animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (completion) completion(flag);
    CFRunLoopStop(CFRunLoopGetCurrent());
}
@end

static BlockingAnimationDelegate *delegate;

@implementation UIView (BlockingAnimation)
+ (void) animateBlockingWithDuration:(NSTimeInterval)duration animations:(void (^)(void))animations completion:(void (^)(BOOL))theCompletion
{
    delegate = [[BlockingAnimationDelegate alloc] init];
    
    completion = theCompletion;
    
    [UIView beginAnimations:@"BlockingAnimations" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:duration];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:)];
    [UIView setAnimationDelegate:delegate];
    if (animations) animations();
    [UIView commitAnimations];
    
    CFRunLoopRun();
}
@end