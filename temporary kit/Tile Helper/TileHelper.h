/*
 
 Erica Sadun, http://ericasadun.com
 
 */

@import Foundation;
@import SpriteKit;

@interface TileHelper : NSObject
@property (nonatomic, assign) CGPoint tweak;

// Helper
+ (instancetype) helperWithImage: (UIImage *) image columns:(NSInteger) across rows:(NSInteger) rows __attribute__ ((nonnull (1)));

// Create tile index arrays
- (NSArray *) indexesFromLine: (NSInteger) y1 column: (NSInteger) x1 toLine: (NSInteger) y2 column: (NSInteger) x2;
- (NSArray *) lineIndexes: (int) line;

// Access individual images
- (UIImage *) imageAtLine: (NSInteger) y column: (NSInteger) x;
- (SKTexture *) textureAtLine: (NSInteger) y column: (NSInteger) x;

// Retrieve Array and Sprite
- (NSArray *) imagesWithFrames: (NSArray *) pointArray;
- (SKAction *) actionWithFrames: (NSArray *) pointArray fps: (NSInteger) fps repeat: (BOOL) repeated;
- (SKSpriteNode *) spriteWithFrames: (NSArray *) pointArray fps: (NSInteger) fps actionName: (NSString *) name;
@end

/*
 
 For example:
 
 - (SKAction *) ninja : (BOOL) forward
 {
 TileHelper *helper = [TileHelper helperWithImage:[UIImage imageNamed:@"Ninja"] columns:6 rows:3];
 NSArray *line = [helper indexesFromLine:forward ? 0 : 1 column:0 toLine:forward ? 0 : 1 column:5];
 SKAction *action = [helper actionWithFrames:line fps:5 repeat:YES];
 return action;
 }
 
 - (SKTexture *) ninjaDefaultTexture
 {
 TileHelper *helper = [TileHelper helperWithImage:[UIImage imageNamed:@"Ninja"] columns:6 rows:3];
 SKTexture *texture = [helper textureAtLine:0 column:0];
 return texture;
 }


*/