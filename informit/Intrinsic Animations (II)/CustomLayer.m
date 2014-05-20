//
//  CustomLayer.m
//  Hello World
//
//  Created by Erica Sadun on 5/19/14.
//  Copyright (c) 2014 Erica Sadun. All rights reserved.
//

#import "CustomLayer.h"
#import "BezierPack.h"
#import "PathMaker.h"

@implementation CustomLayer
@dynamic logoLevel;
@dynamic imageLevel;

// Initialize custom values
- (instancetype) init
{
    if (!(self = [super init])) return self;
    self.logoLevel = @(0.0f);
    self.imageLevel = @(0.0f);
    // _animationDuration = 2.0f; // slow everything down
    [self setNeedsDisplay];
    return self;
}

// Path
- (UIBezierPath *) path
{
    static UIBezierPath *bezierPath = nil;
    if (!bezierPath)
        bezierPath = [PathMaker carrot];
    FitPathToRect(bezierPath, CGRectInset(self.bounds, 40, 40));
    return bezierPath;
}

// Add dynamic response
- (CABasicAnimation *) customAnimationForKey: (NSString *) key
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:key];
	animation.fromValue = [self.presentationLayer valueForKey:key];
    animation.duration = (_animationDuration == 0.0f) ? 0.3f : _animationDuration;
    return animation;
}

// Animate
-(id<CAAction>)actionForKey:(NSString *)key
{
    return [self customAnimationForKey:key];
}

- (void) drawInContext:(CGContextRef) context
{
    static UIImage *image = nil;
    if (!image) image = [UIImage imageNamed:@"e"];
    
    UIGraphicsPushContext(context);
    UIBezierPath *path = [self path];
    CGFloat alpha = self.logoLevel.floatValue / 2.0f;
    [path fill:[[UIColor whiteColor] colorWithAlphaComponent:alpha]];
    
    [image drawInRect:CGRectMake(20, 20, 64, 64) blendMode:kCGBlendModeCopy alpha:self.imageLevel.floatValue];
    UIGraphicsPopContext();
}

+ (BOOL) needsDisplayForKey:(NSString *) key
{
    if ([key isEqualToString:@"logoLevel"]) return YES;
    if ([key isEqualToString:@"imageLevel"]) return YES;
    return [super needsDisplayForKey:key];
}
@end