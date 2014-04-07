/*
 
 Erica Sadun, http://ericasadun.com
 
 */

#import "RoundedImageView.h"

@implementation RoundedImageView
{
    UIView *borderView;
    CAShapeLayer *borderLayer;
}

#pragma mark - presentation

- (void) updateLayer
{
    if (CGSizeEqualToSize(self.bounds.size, CGSizeZero))
        return;
    
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:self.bounds];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = path.CGPath;
    self.layer.mask = maskLayer;

    CGRect inset = CGRectInset(self.bounds, _borderWidth / 2, _borderWidth / 2);
    UIBezierPath *insetPath = [UIBezierPath bezierPathWithOvalInRect:inset];
    borderLayer.fillColor = [UIColor clearColor].CGColor;
    borderLayer.strokeColor = _borderColor.CGColor;
    borderLayer.lineWidth = _borderWidth;
    borderLayer.path = insetPath.CGPath;
}

#pragma mark - public interface

- (void) setBorderColor:(UIColor *)borderColor
{
    _borderColor = borderColor;
    [self updateLayer];
}

- (void) setBorderWidth:(CGFloat)borderWidth
{
    _borderWidth = borderWidth;
    [self updateLayer];
}


#pragma mark - init and dealloc
- (void) observeValueForKeyPath:(NSString *)keyPath
                       ofObject:(id)object
                         change:(NSDictionary *)change
                        context:(void *)context
{
    if ([keyPath isEqualToString:@"bounds"])
        [self updateLayer];
}

- (void) setup
{
    // Add child view
    borderView = [[UIView alloc] init];
    [self addSubview:borderView];
    borderView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    borderLayer = [[CAShapeLayer alloc] init];
    [borderView.layer addSublayer:borderLayer];
    
    _borderColor = [UIColor blackColor];
    _borderWidth = 2;
    
    // Participate in Auto Layout
    self.translatesAutoresizingMaskIntoConstraints = YES;
    
    // Constrain aspect
    NSLayoutConstraint *c = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:1 constant:0];
    [self addConstraint:c];
    
    // Listen for bounds changes
    [self addObserver:self forKeyPath:@"bounds" options:NSKeyValueObservingOptionNew context:NULL];
}

- (instancetype) initWithImage:(UIImage *)image highlightedImage:(UIImage *)highlightedImage
{
    if (!(self = [super initWithImage:image highlightedImage:highlightedImage])) return self;
    [self setup];
    return self;
}

- (instancetype) initWithImage:(UIImage *)image
{
    if (!(self = [super initWithImage:image])) return self;
    [self setup];
    return self;
}

- (instancetype) initWithFrame:(CGRect)frame
{
    return [self initWithImage:nil];
}

- (void) dealloc
{
    [self removeObserver:self forKeyPath:@"bounds"];
}
@end
