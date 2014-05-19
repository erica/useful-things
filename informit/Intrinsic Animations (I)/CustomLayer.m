//
//  CustomLayer.m
//  Hello World
//
//  Created by Erica Sadun on 5/19/14.
//  Copyright (c) 2014 Erica Sadun. All rights reserved.
//

#import "CustomLayer.h"

@implementation CustomLayer

// Execute (optional) completion block
- (void) animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    NSString *key = [anim valueForKey:@"Animation Type"];
    // NSLog(@"Key: %@, Finished: %@", key, flag ? @"Yes" : @"No");
    if (_completionBlock)
    {
        _completionBlock(key, flag);
    }
}

// Add dynamic response
- (CABasicAnimation *) customAnimationForKey: (NSString *) key
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:key];
	animation.fromValue = [self.presentationLayer valueForKey:key];
    animation.duration = (_animationDuration == 0.0f) ? 0.3f : _animationDuration;
    animation.delegate = self;
    [animation setValue:key forKey:@"Animation Type"];
    return animation;
}

-(id<CAAction>)actionForKey:(NSString *)key
{
//    if ([key isEqualToString:@"cornerRadius"])
//        return [self customAnimationForKey:key];
//    return [super actionForKey:key];
    return [self customAnimationForKey:key];
}
@end