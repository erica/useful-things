/*
 
 Erica Sadun, http://ericasadun.com
 
 */

#import "ShadowLabelNode.h"

NSString *const ShadowEffectNodeKey = @"ShadowEffectNodeKey";

@implementation ShadowLabelNode
{
    BOOL hasObservers;
}

#pragma mark - Updates

- (void) updateShadow
{
    SKEffectNode *effectNode = (SKEffectNode *)[self childNodeWithName:ShadowEffectNodeKey];
    if (!effectNode)
    {
        effectNode = [SKEffectNode node];
        effectNode.name = ShadowEffectNodeKey;
        effectNode.shouldEnableEffects = YES;
        effectNode.zPosition = self.zPosition - 1;
    }
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setDefaults];
    [filter setValue:@(_blurRadius) forKey:@"inputRadius"];
    effectNode.filter = filter;
    [effectNode removeAllChildren];
    
    SKLabelNode *labelNode = [SKLabelNode labelNodeWithFontNamed:self.fontName];
    labelNode.text = self.text;
    labelNode.fontSize = self.fontSize;
    labelNode.verticalAlignmentMode = self.verticalAlignmentMode;
    labelNode.horizontalAlignmentMode = self.horizontalAlignmentMode;
    labelNode.fontColor = _shadowColor;
    labelNode.position = _offset;
    [effectNode addChild:labelNode];
    
    [self insertChild:effectNode atIndex:0];
}

- (void) observeValueForKeyPath:(NSString *)keyPath
                       ofObject:(id)object
                         change:(NSDictionary *)change
                        context:(void *)context
{
    [self updateShadow];
}

#pragma mark - Properties

- (void) setOffset:(CGPoint)offset
{
    _offset = offset;
    [self updateShadow];
}

- (void) setShadowColor:(UIColor *)shadowColor
{
    _shadowColor = shadowColor;
    [self updateShadow];
}

- (void) setBlurRadius:(CGFloat)blurRadius
{
    _blurRadius = blurRadius;
    [self updateShadow];
}

#pragma mark - Initialization

- (instancetype) initWithFontNamed:(NSString *)fontName
{
    if (!(self = [super initWithFontNamed:fontName])) return self;
    
    // Set defaults
    self.fontColor = [UIColor blackColor];
    _offset = CGPointMake(1, -1);
    _blurRadius = 3;
    _shadowColor = [[UIColor darkGrayColor] colorWithAlphaComponent:0.8];
    
    // Set observers
    for (NSString *keyPath in @[@"text", @"fontName", @"fontSize", @"verticalAlignmentMode", @"horizontalAlignmentMode", @"fontColor"])
        [self addObserver:self forKeyPath:keyPath options:NSKeyValueObservingOptionNew context:NULL];
    hasObservers = YES;
    
    // Initialize shadow
    [self updateShadow];
    
    return self;
}

- (void) dealloc
{
    if (hasObservers)
    {
        for (NSString *keyPath in @[@"text", @"fontName", @"fontSize", @"verticalAlignmentMode", @"horizontalAlignmentMode", @"fontColor"])
            [self removeObserver:self forKeyPath:keyPath];
    }
}
@end