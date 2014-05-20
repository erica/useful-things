/*
 
 Erica Sadun, http://ericasadun.com
 
 */

#import "TileHelper.h"

@implementation TileHelper
{
    UIImage *source;
    NSInteger numAcross;
    NSInteger numDown;
}

#pragma mark - Init

- (instancetype) initWithSource: (UIImage *) image columns: (NSInteger) x rows: (NSInteger) y
{
    if (!(self = [super init])) return self;
    source = image;
    numAcross = x;
    numDown = y;
    _tweak = CGPointMake(1, 1); // this isn't written in stone
    return self;
}

+ (instancetype) helperWithImage: (UIImage *) image columns:(NSInteger) across rows:(NSInteger) down __attribute__ ((nonnull (1)))
{
    return [[self alloc] initWithSource:image columns:across rows:down];
}

#pragma mark - Indices

- (NSArray *) indexesFromLine: (NSInteger) y1 column: (NSInteger) x1 toLine: (NSInteger) y2 column: (NSInteger) x2
{
    NSMutableArray *array = @[].mutableCopy;
    NSInteger index1 = y1 * numAcross + x1;
    NSInteger index2 = y2 * numAcross + x2;
    for (int i = index1; i <= index2; i++)
    {
        NSInteger x = i % numAcross;
        NSInteger line = i / numAcross;
        CGPoint p = CGPointMake(line, x);
        NSValue *value = [NSValue valueWithCGPoint:p];
        [array addObject:value];
    }
    return array.copy;
}

- (NSArray *) lineIndexes: (int) line
{
    NSMutableArray *array = @[].mutableCopy;
    for (int i = 0; i < numAcross; i++)
    {
        CGPoint p = CGPointMake(line, i);
        NSValue *value = [NSValue valueWithCGPoint:p];
        [array addObject:value];
    }
    return array.copy;
}

#pragma mark - Image/Texture

- (UIImage *) imageAtLine: (NSInteger) y column: (NSInteger) x
{
    if (numAcross == 0) return nil;
    if (numDown == 0) return nil;

    NSInteger height = source.size.height;
    NSInteger width = source.size.width;

    NSInteger tileSizeH = width / numAcross;
    NSInteger tileSizeV = height / numDown;

    // You may need to tweak these depending on your art
    NSInteger px = x * tileSizeH + _tweak.x;
    NSInteger py = y * tileSizeV + _tweak.y;
    
    CGSize size = CGSizeMake(tileSizeH, tileSizeV);
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    [source drawAtPoint:CGPointMake(-px, -py)];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (SKTexture *) textureAtLine: (NSInteger) y column: (NSInteger) x
{
    UIImage *image = [self imageAtLine:y column:x];
    SKTexture *texture = [SKTexture textureWithImage:image];
    return texture;
}

#pragma mark - Image Line

- (NSArray *) imagesWithFrames: (NSArray *) pointArray
{
    NSMutableArray *images = @[].mutableCopy;
    for (NSValue *value in pointArray)
    {
        if (![value isKindOfClass:[NSValue class]]) continue;
        CGPoint p = [value CGPointValue];
        UIImage *image = [self imageAtLine:lrint(p.x) column:lrint(p.y)];
        [images addObject:image];
    }
    return images.copy;
}

- (SKAction *) actionWithFrames: (NSArray *) pointArray fps: (NSInteger) fps repeat: (BOOL) repeated
{
    NSArray *images = [self imagesWithFrames:pointArray];
    NSMutableArray *array = @[].mutableCopy;
    
    for (UIImage *each in images)
    {
        SKTexture *texture = [SKTexture textureWithImage:each];
        [array addObject:texture];
    }
    if (!array.count) return nil;
    
    SKAction *action = [SKAction animateWithTextures:array timePerFrame:(1.0f / (CGFloat) fps)];
    if (repeated)
        return [SKAction repeatActionForever:action];
    return action;
}

- (SKSpriteNode *) spriteWithFrames: (NSArray *) pointArray fps: (NSInteger) fps actionName: (NSString *) name
{
    NSArray *images = [self imagesWithFrames:pointArray];
    NSMutableArray *array = @[].mutableCopy;
    
    for (UIImage *each in images)
    {
        SKTexture *texture = [SKTexture textureWithImage:each];
        [array addObject:texture];
    }
    if (!array.count) return nil;
    
    SKAction *action = [SKAction animateWithTextures:array timePerFrame:(1.0f / (CGFloat) fps)];
    SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithTexture:array[0]];
    [sprite runAction:[SKAction repeatActionForever:action] withKey:name];
    return sprite;
}
@end
