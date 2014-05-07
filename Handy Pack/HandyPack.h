/*
 
 Erica Sadun, http://ericasadun.com
 HANDY PACK
 
 Useful items for testing and development
 
 */

// Imports
#if TARGET_OS_IPHONE
@import UIKit;
@import Foundation;
#elif TARGET_OS_MAC
#import <Foundation/Foundation.h>
#endif

// Compatibility aliases
#ifndef  COMPATIBILITY_ALIASES_DEFINED
#if TARGET_OS_IPHONE
@compatibility_alias View UIView;
@compatibility_alias Color UIColor;
@compatibility_alias Image UIImage;
@compatibility_alias Font UIFont;
#elif TARGET_OS_MAC
@compatibility_alias View NSView;
@compatibility_alias Color NSColor;
@compatibility_alias Image NSImage;
@compatibility_alias Font NSFont;
#endif
#endif
#define COMPATIBILITY_ALIASES_DEFINED

/*
 
 BLOCKS
 
 */

#define ESTABLISH_WEAK_SELF __weak typeof(self) weakSelf = self
#define ESTABLISH_STRONG_SELF __strong typeof(self) strongSelf = weakSelf

/*
 
 ASSOCIATIONS
 
 */

#ifndef AssociatedObjectPack
#define SynthesizeGetter(_name_) - (id) _name_ {return objc_getAssociatedObject(self, @selector(_name_));}
#define SynthesizeSetter(_name_, _setter_, _type_) - (void) _setter_ (_type_) _name_ {objc_setAssociatedObject(self, @selector(_name_), _name_, OBJC_ASSOCIATION_RETAIN_NONATOMIC);}
#define SynthesizeAssociatedObjecct(_name_, _setterName_, _type_) SynthesizeGetter(_name_); SynthesizeSetter(_name_, _setterName_, _type_);
#define AssociatedObjectPack
#endif

/*
 
 VALUE
 
 */

#define VALUE(struct) ({ __typeof__(struct) __struct = struct; [NSValue valueWithBytes:&__struct objCType:@encode(__typeof__(__struct))]; })


// Checks
#define CHECK_FLAG(_source_, _flag_) ((_source_ & _flag_) != 0)
#define BOOL_CHECK(TITLE, CHECK_ITEM) printf("%s: %s\n", TITLE, (CHECK_ITEM) ? "Yes" : "No")

// Log without date
void Log(NSString *formatString,...);
NSString *String(NSString *formatString, ...);

// Paths
NSString *LibPath(NSString *fileName);
NSString *DocsPath(NSString *fileName);
NSString *TmpPath(NSString *fileName);
NSString *BundlePath(NSString *fileName);

// User Defaults
NSObject *GetDefault(NSString *key);
void SetDefault(NSString *key, NSObject *value);

// Perform
typedef void(^BasicBlockType)();
void SafePerform(id target, SEL selector, NSObject *object);
void PerformBlockAfterDelay(BasicBlockType block, NSTimeInterval delay, BOOL useMainThread);

// Random
void SeedRandom();
NSUInteger RandomInteger(NSUInteger max);
CGFloat Random01();
BOOL RandomBool();
CGPoint RandomPointInRect(CGRect rect);
id RandomItemInArray(NSArray *array);
Color *Random_Color();

// Reading
NSString *StringFromPath(NSString *path);
NSData *DataFromPath(NSString *path);

// String
BOOL StringEqual(NSString *s1, NSString *s2);
BOOL HasPrefix(NSString *s1, NSString *prefix);
BOOL HasSuffix(NSString *s1, NSString *suffix);
@interface NSString (GeneralUtility)
@property (nonatomic, readonly) NSData *dataRepresentation;
+ (instancetype) stringWithData: (NSData *) data;
@end

// View
#if TARGET_OS_IPHONE
@interface UIView (GeneralUtility)
@property (nonatomic, readonly) NSArray *realSubviews;
@end
#endif

#if TARGET_OS_IPHONE

/*
 
 BAR BUTTONS
 
 */

#define BARBUTTON(TITLE, SELECTOR) [[UIBarButtonItem alloc] initWithTitle:TITLE style:UIBarButtonItemStylePlain target:self action:SELECTOR]
#define SYSBARBUTTON(ITEM, SELECTOR) [[UIBarButtonItem alloc] initWithBarButtonSystemItem:ITEM target:self action:SELECTOR]
#define IMGBARBUTTON(IMAGE, SELECTOR) [[UIBarButtonItem alloc] initWithImage:IMAGE style:UIBarButtonItemStylePlain target:self action:SELECTOR]
#define CUSTOMBARBUTTON(VIEW) [[UIBarButtonItem alloc] initWithCustomView:VIEW]

#define SYSBARBUTTON_TARGET(ITEM, TARGET, SELECTOR) [[UIBarButtonItem alloc] initWithBarButtonSystemItem:ITEM target:TARGET action:SELECTOR]
#define BARBUTTON_TARGET(TITLE, TARGET, SELECTOR) [[UIBarButtonItem alloc] initWithTitle:TITLE style:UIBarButtonItemStylePlain target:TARGET action:SELECTOR]

/*
 
 TINT COLOR
 
 */

#define APP_TINT_COLOR  (^UIColor *(){UIColor *c = [[[[UIApplication sharedApplication] delegate] window] tintColor]; if (c) return c; c = [[UINavigationBar alloc] init].tintColor; if (c) return c; return [UIColor colorWithRed:0.0 green:0.478431 blue:1.0 alpha:1.0];}())

/*
 
 PLATFORM CHECK
 
 */

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

/*
 
 ORIENTATION
 
 */

#define IS_PORTRAIT UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation) || UIDeviceOrientationIsPortrait(self.interfaceOrientation)

#endif

// Paths
NSString *Desktop();
NSURL    *DesktopURL();

// Data
void SaveDebugData(NSData *data, NSString *name);

// Images -- iOS Only. Mac please use Mac Image Pack
#if TARGET_OS_IPHONE
void SaveDebugImage(UIImage *image, NSString *name);
void WriteImage(UIImage *image, NSString *path);
#endif

// Stylize View
void RoundAndEdgeView(View *view);

// Lorem image
Image *LoremPixel(CGSize size, NSString *category);
NSArray *LoremPixelCategories();

// Lorem words
NSString *Lorem(NSUInteger numberOfParagraphs);
NSString *Ipsum(NSUInteger numberOfParagraphs);
NSString *AnyIpsum(NSUInteger numberOfParagraphs, NSString *topic);

// Test views
#if TARGET_OS_IPHONE
UIView *BuildView(UIViewController *controller, CGFloat h, CGFloat v, NSString *color, CGFloat alpha, BOOL stylize);
void PlaceView(UIViewController *controller, UIView *view, NSString *position, CGFloat inseth, CGFloat insetv, CGFloat priority);
#endif