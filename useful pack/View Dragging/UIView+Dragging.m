/*
 
 Erica Sadun, http://ericasadun.com
 Auto Layout Demystified
 Use at your own risk. Do no harm.
 
 All sizing must be internal to draggable views
 
 */

#import "UIView+Dragging.h"
#import "ConstraintPack.h"

NSString *const DraggableViewDidMove = @"DraggableViewDidMove";

@interface DraggingRecognizer : UIPanGestureRecognizer
@property (nonatomic) NSValue *origin;
@property (nonatomic) BOOL constrained;
@property (nonatomic) BOOL notify;
@property (nonatomic) CGFloat constrainedInset;
@property (nonatomic) CGPoint mostRecentCenterPoint;
@end

@implementation DraggingRecognizer
- (void) setup
{
    _constrained = YES;
    _notify = NO;
    _constrainedInset = 8.0f;
    self.minimumNumberOfTouches = 1;
    self.maximumNumberOfTouches = 1;
}

- (instancetype) init
{
    if (!(self = [super init])) return self;
    [self setup];
    return self;
}

- (instancetype) initWithTarget:(id)target action:(SEL)action
{
    if (!(self = [super initWithTarget:target action:action])) return self;
    [self setup];
    return self;
}
@end

@implementation UIView (DraggingUtility)

#pragma mark - Recognizer

- (DraggingRecognizer *) draggingRecognizer
{
    for (UIGestureRecognizer *recognizer in self.gestureRecognizers)
        if ([recognizer isKindOfClass:[DraggingRecognizer class]])
            return (DraggingRecognizer *) recognizer;
    return nil;
}

#pragma mark - Constrain

- (BOOL) constrainDragsToSuperview
{
    DraggingRecognizer *dragger = self.draggingRecognizer;
    if (!dragger) return NO;
    return dragger.constrained;
}

- (void) setConstrainDragsToSuperview:(BOOL)constrainDragsToSuperview
{
    DraggingRecognizer *dragger = self.draggingRecognizer;
    if (!dragger) return;
    dragger.constrained = constrainDragsToSuperview;
}

#pragma mark - Notify

- (BOOL) sendDragNotifications
{
    DraggingRecognizer *dragger = self.draggingRecognizer;
    if (!dragger) return NO;
    return dragger.notify;
}

- (void) setSendDragNotifications:(BOOL)sendDragNotifications
{
    DraggingRecognizer *dragger = self.draggingRecognizer;
    if (!dragger) return;
    dragger.notify = sendDragNotifications;
}

#pragma mark - Enable drags

- (void) setDraggingEnabled:(BOOL)yorn
{
    DraggingRecognizer *dragger = self.draggingRecognizer;
    
    if (!yorn)
    {
        if (dragger) [self removeGestureRecognizer:dragger];
        return;
    }
    
    if (dragger) return;
    dragger = [[DraggingRecognizer alloc] initWithTarget:self action:@selector(handleDrag:)];
    dragger.mostRecentCenterPoint = self.center;
    [self addGestureRecognizer:dragger];
}

- (BOOL) draggingEnabled
{
    UIGestureRecognizer *dragger = self.draggingRecognizer;
    return (dragger != nil);
}

#pragma mark - Inset

- (CGFloat) constrainedInset
{
    return self.draggingRecognizer.constrainedInset;
}

- (void) setConstrainedInset:(CGFloat)constrainedInset
{
    self.draggingRecognizer.constrainedInset = constrainedInset;
}

#pragma mark - Most recent center

- (CGPoint) preferredCenter
{
    DraggingRecognizer *dragger = self.draggingRecognizer;
    if (!dragger) return self.center;
    return dragger.mostRecentCenterPoint;
}

#pragma mark - Drag

- (void) moveToPoint: (CGPoint) point
{
    DraggingRecognizer *dragger = self.draggingRecognizer;

    RemoveConstraints(self.externalConstraintReferences);
    PositionView(self, point, 500);
    if (dragger.constrained)
        ConstrainViewToSuperview(self, dragger.constrainedInset, 1000);
    [self.superview layoutIfNeeded];
    RemoveConstraints(self.externalConstraintReferences);
    
    dragger.mostRecentCenterPoint = self.center;
}

- (void) handleDrag: (DraggingRecognizer *) recognizer
{
    if (!self.superview) return;
    
    switch (recognizer.state)
    {
        case UIGestureRecognizerStateBegan:
        {
            recognizer.origin = [NSValue valueWithCGPoint:self.frame.origin];
            [self.superview bringSubviewToFront:self];
            break;
        }
        case UIGestureRecognizerStateChanged:
        {
            CGPoint offset = [recognizer translationInView:self.superview];
            CGPoint origin = [recognizer.origin CGPointValue];
            CGPoint destination = CGPointMake(origin.x + offset.x, origin.y + offset.y);
            [self moveToPoint:destination];
            if (recognizer.notify)
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:DraggableViewDidMove object:self userInfo:@{@"State":@(UIGestureRecognizerStateChanged)}];
            }
            break;
        }
        case UIGestureRecognizerStateEnded:
        {
            CGPoint offset = [recognizer translationInView:self.superview];
            CGPoint origin = [recognizer.origin CGPointValue];
            CGPoint destination = CGPointMake(origin.x + offset.x, origin.y + offset.y);
            [self moveToPoint:destination];
            if (recognizer.notify)
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:DraggableViewDidMove object:self userInfo:@{@"State":@(UIGestureRecognizerStateEnded)}];
            }
            recognizer.origin = nil;
            break;
        }
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed:
        case UIGestureRecognizerStatePossible:
        default:
            break;
    }
}
@end

