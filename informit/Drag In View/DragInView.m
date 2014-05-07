/*
 
 Erica Sadun, http://ericasadun.com
 
 */

#import "DragInView.h"
#import "ConstraintPack.h"

@interface DragInView()
@property (nonatomic) NSLayoutAttribute side;
@property (nonatomic) NSLayoutConstraint *c;
@end

@implementation DragInView
{
    UIImageView *handleView;
}

- (void) handleCloseTapGesture: (UITapGestureRecognizer *) tapGestureRecognizer
{
    [handleView removeGestureRecognizer:tapGestureRecognizer];
    [UIView animateWithDuration:0.5f
                          delay:0
         usingSpringWithDamping:0.6f
          initialSpringVelocity:0.5
                        options:0
                     animations:^{
                         _c.constant = kClosedDrawExtent;
                         [self.superview layoutIfNeeded];
                     }
                     completion:^(BOOL finished)
    {
        // Add drag-to-open
        UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleOpenPanGesture:)];
        [handleView addGestureRecognizer:panGestureRecognizer];
        
        // Add tap-to-open
        UITapGestureRecognizer *openTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleOpenTapGesture:)];
        [handleView addGestureRecognizer:openTapRecognizer];
    }];
}

- (void) slideToOpen
{
    // Clean up existing recognizers
    for (UIGestureRecognizer *recognizer in handleView.gestureRecognizers.copy)
    {
        recognizer.enabled = NO;
        [handleView removeGestureRecognizer:recognizer];
    }
    
    // trigger
    [UIView animateWithDuration:0.5f
                          delay:0
         usingSpringWithDamping:0.4f
          initialSpringVelocity:0.5
                        options:0
                     animations:^{
                         _c.constant = kOpenDrawExtent;
                         [self.superview layoutIfNeeded];
                     }
                     completion:^(BOOL finished)
    {
        // Add tap-to-close
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleCloseTapGesture:)];
        [handleView addGestureRecognizer:tapGestureRecognizer];
    }];
    return;
}

- (void) handleOpenTapGesture: (UITapGestureRecognizer *) tapGestureRecognizer
{
    tapGestureRecognizer.enabled = NO;
    [self slideToOpen];
}

- (void) handleOpenPanGesture: (UIPanGestureRecognizer *) panGestureRecognizer
{
    BOOL horizontal = [@[@(NSLayoutAttributeLeft), @(NSLayoutAttributeLeading), @(NSLayoutAttributeRight), @(NSLayoutAttributeTrailing)] containsObject:@(_side)];
    
    CGPoint offset = [panGestureRecognizer translationInView:self.superview];
    CGFloat amount =  horizontal ? ABS(offset.x) : ABS(offset.y);
    
    if ((amount + kClosedDrawExtent + kHandleInset + kHandleExtent / 2) > kTriggerPoint)
    {
        panGestureRecognizer.enabled = NO;
        [self slideToOpen];
        return;
    }

    switch (panGestureRecognizer.state)
    {
        case UIGestureRecognizerStateBegan:
            break;
        case UIGestureRecognizerStateChanged:
        {
            // Follow finger drag
            _c.constant = (amount + kClosedDrawExtent + kHandleInset + kHandleExtent / 2);
            break;
        }
        case UIGestureRecognizerStateEnded:
        {
            // Snap shut
            [UIView animateWithDuration:0.5f
                                  delay:0
                 usingSpringWithDamping:0.25f
                  initialSpringVelocity:0.5
                                options:0
                             animations:^{
                                 _c.constant = kClosedDrawExtent;
                                 [self.superview layoutIfNeeded];
                             }
                             completion:^(BOOL finished) {
            }];
            break;
        }
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed:
        case UIGestureRecognizerStatePossible:
        default:
            break;
    }
}

- (UIImageView *) handleView
{
    return handleView;
}

- (instancetype) initWithFrame:(CGRect)frame parent: (UIViewController *) parent side: (NSLayoutAttribute) side
{
    if (!(self = [super initWithFrame:frame])) return self;
    if (![@[@(NSLayoutAttributeLeft), @(NSLayoutAttributeLeading), @(NSLayoutAttributeRight), @(NSLayoutAttributeTrailing), @(NSLayoutAttributeTop), @(NSLayoutAttributeBottom)] containsObject:@(side)]) return self;
    
    // Establish general look and auto layout
    self.autoLayoutEnabled = YES;
    self.layer.borderWidth = 1;
    self.layer.borderColor = [UIColor blackColor].CGColor;
    
    // Create child nav bar for translucency
    UINavigationBar *nb = [[UINavigationBar alloc] init];
    nb.autoLayoutEnabled = YES;
    [self addSubview:nb];
    StretchViewToSuperview(nb, CGSizeZero, 1000);

    // Build handle
    handleView = [[UIImageView alloc] init];
    handleView.userInteractionEnabled = YES;
    handleView.contentMode = UIViewContentModeCenter;
    handleView.autoLayoutEnabled = YES;
    handleView.layer.cornerRadius = 10;
    handleView.backgroundColor = [UIColor blackColor];
    [self addSubview:handleView];
    
    // Add to parent
    [parent.view addSubview:self];
    _side = side;

    BOOL horizontal = [@[@(NSLayoutAttributeLeft), @(NSLayoutAttributeLeading), @(NSLayoutAttributeRight), @(NSLayoutAttributeTrailing)] containsObject:@(_side)];
    if (horizontal)
    {
        CenterViewInSuperview(handleView, NO, YES, 1000);
        SizeView(handleView, CGSizeMake(kHandleExtent, kHandleLength), 1000);

        SizeView(self, CGSizeMake(kDrawerExtent, SkipConstraint), 1000);
        StretchViewToTopLayoutGuide(parent, self, 0, 1000);
        StretchViewToBottomLayoutGuide(parent, self, 0, 1000);
    }
    else
    {
        CenterViewInSuperview(handleView, YES, NO, 1000);
        SizeView(handleView, CGSizeMake(kHandleLength, kHandleExtent), 1000);
        
        SizeView(self, CGSizeMake(SkipConstraint, kDrawerExtent), 1000);
        StretchViewHorizontallyToSuperview(self, 0, 1000);
    }
    
    switch (side)
    {
        case NSLayoutAttributeLeft:
        case NSLayoutAttributeLeading:
            _c = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:parent.view attribute:NSLayoutAttributeLeading multiplier:1 constant:kClosedDrawExtent];
            AlignViewInSuperview(handleView, NSLayoutAttributeTrailing, kHandleInset, 1000);
            break;
        case NSLayoutAttributeRight:
        case NSLayoutAttributeTrailing:
            _c = [NSLayoutConstraint constraintWithItem:parent.view attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1 constant:kClosedDrawExtent];
            AlignViewInSuperview(handleView, NSLayoutAttributeLeading, kHandleInset, 1000);
            break;
        case NSLayoutAttributeTop:
            _c = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:parent.view attribute:NSLayoutAttributeTop multiplier:1 constant:kClosedDrawExtent];
            AlignViewInSuperview(handleView, NSLayoutAttributeBottom, kHandleInset, 1000);
            break;
        case NSLayoutAttributeBottom:
            _c = [NSLayoutConstraint constraintWithItem:parent.view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:kClosedDrawExtent];
            AlignViewInSuperview(handleView, NSLayoutAttributeTop, kHandleInset, 1000);
            break;
        default:
            break;
    }
    
    // This is the all-purpose position constraint regardless
    // of the side the view is presented on
    [_c installWithPriority:750];

    // Add slide to open
    UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleOpenPanGesture:)];
    [handleView addGestureRecognizer:recognizer];
    
    // Add tap to open
    UITapGestureRecognizer *openTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleOpenTapGesture:)];
    [handleView addGestureRecognizer:openTapRecognizer];
    
    return self;
}

+ (instancetype) viewWithParent: (UIViewController *) parent side: (NSLayoutAttribute) side
{
    return [[self alloc] initWithFrame:CGRectZero parent:parent side:side];
}
@end
