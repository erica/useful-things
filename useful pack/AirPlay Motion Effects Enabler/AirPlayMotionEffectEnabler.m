/*
 
 Erica Sadun, http://ericasadun.com
 
 NOT APP STORE SAFE
 USE FOR DEVELOPMENT, DEMONSTRATION, AND TESTING ONLY

 */

#import "AirPlayMotionEffectEnabler.h"

@implementation AirPlayMotionEffectEnabler
+ (void) reenableMotionEffects
{
    id engine = [UIView _motionEffectEngine]; // retrieve engine
    BOOL engineIsActive = [engine _shouldGenerateUpdates];
    if (engineIsActive) return;
    
    NSArray *suspensionReasons = [engine suspensionReasons];
    for (NSString *reason in suspensionReasons)
        [engine endSuspendingForReason:reason];
}
@end
