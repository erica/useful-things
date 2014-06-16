/*
 
 Erica Sadun, http://ericasadun.com
 
 */

@import SpriteKit;

@interface ShadowLabelNode : SKLabelNode
@property (nonatomic) CGPoint offset;
@property (nonatomic) UIColor *shadowColor;
@property (nonatomic) CGFloat blurRadius;
@end