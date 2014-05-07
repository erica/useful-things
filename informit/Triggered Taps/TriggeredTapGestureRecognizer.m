/*
 
 Erica Sadun, http://ericasadun.com
 
 */

#import "TriggeredTapGestureRecognizer.h"
#import <UIKit/UIGestureRecognizerSubclass.h>

@implementation TriggeredTapGestureRecognizer
{
    UITouch *t1;
    NSMutableSet *activeTouches;
    NSDate *triggerTime;
}

- (instancetype) initWithTarget:(id)target action:(SEL)action
{
    if (!(self = [super initWithTarget:target action:action])) return self;
    activeTouches = [NSMutableSet set];
    _minimumDelay = 0.5f;
    return self;
        
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	[super touchesBegan:touches withEvent:event];
    [activeTouches unionSet:touches];

    // Clean up trigger point
    if (t1 && (t1.phase == UITouchPhaseEnded))
    {
        t1 = nil;
        self.state = UIGestureRecognizerStateEnded;
    }

    // Clean up expired touches
    for (UITouch *touch in activeTouches.copy)
    {
        if (touch.phase == UITouchPhaseEnded)
            [activeTouches removeObject:touch];
    }
    
    // To start: must have no trigger, single touch
    if (!t1 && (activeTouches.count == 1))
    {
        // first touch
        t1 = touches.anyObject;
        _count = 0;
        triggerTime = [NSDate date];
        return;
    }

    // Recognize on two touches, a trigger point after mininum delay
    if (t1 && (activeTouches.count == 2) && ([[NSDate date] timeIntervalSinceDate:triggerTime] > _minimumDelay))
    {
        [activeTouches minusSet:touches];
        self.state = UIGestureRecognizerStateRecognized;
        triggerTime = [NSDate date];
        _count++;
        return;
    }
}

// Touches ended may not be called after recognition
- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	[super touchesEnded:touches withEvent:event];
    [activeTouches minusSet:touches];

    // Clean up trigger point
    if ([touches containsObject:t1])
    {
        t1 = nil;
        self.state = UIGestureRecognizerStateEnded;
    }
}
@end
