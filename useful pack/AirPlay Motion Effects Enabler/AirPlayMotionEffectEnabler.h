/*
 
 Erica Sadun, http://ericasadun.com
 
 NOT APP STORE SAFE
 USE FOR DEVELOPMENT, DEMONSTRATION, AND TESTING ONLY
 
 */

#import <Foundation/Foundation.h>

@class _UIMotionEffectEngine;
@interface UIView (MotionEffects)
+ (_UIMotionEffectEngine *) _motionEffectEngine;
@end

@interface _UIMotionEffectEngine : NSObject
- (void) _stopGeneratingUpdates;
- (BOOL) _shouldGenerateUpdates;
- (id) suspensionReasons;
- (void) _startGeneratingUpdates;
- (void) _startOrStopGeneratingUpdates;
- (void) beginSuspendingForReason:(id)argument;
- (void) endSuspendingForReason:(id)argument;
- (void) _toggleSlowUpdates;
@end

@interface AirPlayMotionEffectEnabler : NSObject
+ (void) reenableMotionEffects;
@end
