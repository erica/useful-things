/*
 
 Erica Sadun, http://ericasadun.com
 HANDY PACK
 
 Useful items for testing and development

 */

#import "HandyPack.h"

#pragma mark - Debug Output

// Thanks Landon F.
void Log(NSString *formatString,...)
{
	va_list arglist;
	if (formatString)
	{
		va_start(arglist, formatString);
		NSString *outstring = [[NSString alloc] initWithFormat:formatString arguments:arglist];
		fprintf(stderr, "%s\n", [outstring UTF8String]);
		va_end(arglist);
	}
}

NSString *String(NSString *formatString, ...)
{
    NSString *outstring = nil;
    va_list arglist;
	if (formatString)
	{
		va_start(arglist, formatString);
		outstring = [[NSString alloc] initWithFormat:formatString arguments:arglist];
		va_end(arglist);
	}
    return outstring;
}

#pragma mark - Paths

NSString *LibPath(NSString *fileName)
{
    NSString *basePath = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).firstObject;
    if (!fileName) return basePath;
    return [basePath stringByAppendingPathComponent:fileName];
}

NSString *DocsPath(NSString *fileName)
{
    NSString *basePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    if (!fileName) return basePath;
    return [basePath stringByAppendingPathComponent:fileName];
}

NSString *TmpPath(NSString *fileName)
{
    NSString *basePath = NSTemporaryDirectory();
    if (!fileName) return basePath;
    return [basePath stringByAppendingPathComponent:fileName];
}

NSString *BundlePath(NSString *filename)
{
    if (!filename)
        return [[NSBundle mainBundle] bundlePath];
    
    NSString *resource = [filename stringByDeletingPathExtension];
    NSString *ext = filename.pathExtension;
    
    NSString *path = [[NSBundle mainBundle] pathForResource:resource ofType:ext];
    if (!path)
    {
        NSLog(@"Error retrieving %@ path from bundle", filename);
        return nil;
    }
    return path;
}

#pragma mark - Defaults

// Defaults
NSObject *GetDefault(NSString *key)
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

void SetDefault(NSString *key, NSObject *value)
{
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - Random

NSUInteger RandomInteger(NSUInteger max)
{
    return arc4random_uniform((unsigned int) max);
}

CGFloat Random01()
{
    return ((CGFloat) arc4random() / (CGFloat) UINT_MAX);
}

BOOL RandomBool()
{
    return (BOOL)arc4random_uniform(2);
}

CGPoint RandomPointInRect(CGRect rect)
{
    CGFloat x = rect.origin.x + Random01() * rect.size.width;
    CGFloat y = rect.origin.y + Random01() * rect.size.height;
    return CGPointMake(x, y);
}

id RandomItemInArray(NSArray *array)
{
    NSUInteger index = RandomInteger(array.count);
    return array[index];
}

#pragma mark - Color

#if TARGET_OS_IPHONE
#define COLOR_PREFIX colorWithRed
#elif TARGET_OS_MAC
#define COLOR_PREFIX colorWithDeviceRed
#endif

// Underscore prevents issues when combined with color pack
Color *Random_Color()
{
    return [Color COLOR_PREFIX:Random01()
                         green:Random01()
                          blue:Random01()
                         alpha:1.0f];
}

#undef COLOR_PREFIX

#pragma mark - Reading

NSString *StringFromPath(NSString *path)
{
    NSError *error;
    NSString *string = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
    if (!string)
    {
        NSLog(@"Error reading string from path %@: %@", path.lastPathComponent, error.localizedDescription);
        return nil;
    }
    return string;
}

NSData *DataFromPath(NSString *path)
{
    NSError *error;
    NSData *data = [NSData dataWithContentsOfFile:path options:0 error:&error];
    if (!data)
    {
        NSLog(@"Error reading data from path %@: %@", path.lastPathComponent, error.localizedDescription);
        return nil;
    }
    return data;
}

#pragma mark - String data

@implementation NSString (GeneralUtility)
- (NSData *) dataRepresentation
{
    return [self dataUsingEncoding:NSUTF8StringEncoding];
}

+ (instancetype) stringWithData: (NSData *) data
{
    return [[self alloc] initWithData:data encoding:NSUTF8StringEncoding];
}
@end

#pragma mark - String comparisons

BOOL StringEqual(NSString *s1, NSString *s2)
{
    return [s1 caseInsensitiveCompare:s2] == NSOrderedSame;
}

BOOL HasPrefix(NSString *s1, NSString *prefix)
{
    return [s1.uppercaseString hasPrefix:prefix.uppercaseString];
}

BOOL HasSuffix(NSString *s1, NSString *suffix)
{
    return [s1.uppercaseString hasSuffix:suffix.uppercaseString];
}

#pragma mark - View

#if TARGET_OS_IPHONE
@implementation UIView (ExtendedLayouts)
- (NSArray *) realSubviews
{
    NSMutableArray *results = [NSMutableArray array];
    for (UIView *view in self.subviews)
        if (![view conformsToProtocol:@protocol(UILayoutSupport)])
            [results addObject:view];
    return [results copy];
}
@end
#endif

#pragma mark - Safe Perform

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
void SafePerform(id target, SEL selector, NSObject *object)
{
    if ([target respondsToSelector:selector])
        [target performSelector:selector withObject:object];
}
#pragma clang diagnostic pop

void PerformBlockAfterDelay(BasicBlockType block, NSTimeInterval delay, BOOL useMainThread)
{
    if (!block) return;
    dispatch_time_t targetTime = dispatch_time(DISPATCH_TIME_NOW, delay * NSEC_PER_SEC);
    dispatch_after(targetTime, useMainThread ? dispatch_get_main_queue() : dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        block();
    });
}

#pragma mark - Paths

NSString *Desktop()
{
    return @"/Users/ericasadun/Desktop";
}

NSURL *DesktopURL()
{
    return [NSURL fileURLWithPath:Desktop()];
}

#pragma mark - Data

void SaveDebugData(NSData *data, NSString *name)
{
    NSString *desktopPath = @"/Users/ericasadun/Desktop";
    NSString *targetPath = [desktopPath stringByAppendingPathComponent:name];
    [data writeToFile:targetPath atomically:YES];
}
     
#pragma mark - Images

#if TARGET_OS_IPHONE
void SaveDebugImage(UIImage *image, NSString *name)
{
    SaveDebugData(UIImagePNGRepresentation(image), [[name lastPathComponent] stringByAppendingPathExtension:@"png"]);
}

void WriteImage(UIImage *image, NSString *path)
{
    [UIImagePNGRepresentation(image) writeToFile:path atomically:YES];
}
#endif

#pragma mark - Stylizing

void RoundAndEdgeView(View *view)
{
#if TARGET_OS_IPHONE
    UIColor *color = [[[[UIApplication sharedApplication] delegate] window] tintColor];
    if (!color) color = [[UINavigationBar alloc] init].tintColor;
    if (!color) color = [UIColor blackColor];
    view.layer.borderColor = color.CGColor;
#elif TARGET_OS_MAC
    view.wantsLayer = YES;
    view.layer.borderColor = [Color blackColor].CGColor;
#endif
    view.layer.borderWidth = 0.5f;
    view.layer.cornerRadius = 8;
}

#pragma mark - Ipsum

NSArray *LoremPixelCategories()
{
    return [@"abstract animals business cats city food nightlife fashion people nature sports technics transport" componentsSeparatedByString:@" "];
}

Image *LoremPixel(CGSize size, NSString *category)
{
    /*
     e.g. http://lorempixel.com/400/200/sports/1/Dummy-Text
     abstract animals business cats city food nightlife fashion people nature sports technics transport
     */
    NSMutableString *string = [NSMutableString stringWithFormat:@"http://lorempixel.com/%0.0f/%0.0f", floorf(size.width), floorf(size.height)];
    if (category)
        [string appendFormat:@"/%@", category];
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:string]];
#if TARGET_OS_IPHONE
    return [UIImage imageWithData:data];
#else
    NSImage *image = [[NSImage alloc] initWithData:data];
    return image;
#endif
}

NSString *TrimWords(NSString *string, NSUInteger numberOfWords)
{
    NSArray *array = [string componentsSeparatedByString:@" "];
    NSArray *subArray = [array subarrayWithRange:NSMakeRange(0, MIN(array.count, numberOfWords))];
    return [subArray componentsJoinedByString:@" "];
}

NSString *TrimParas(NSString *string, NSUInteger numberOfWords)
{
    NSMutableArray *trimmed = [NSMutableArray array];
    NSArray *paras = [string componentsSeparatedByString:@"\n\n"];
    for (NSString *p in paras)
        [trimmed addObject:TrimWords(p, numberOfWords)];
    return [trimmed componentsJoinedByString:@"\n\n"];
}

NSString *Lorem(NSUInteger numberOfParagraphs)
{
    NSString *urlString = [NSString stringWithFormat:@"http://loripsum.net/api/%0ld/short/prude/plaintext", (long) numberOfParagraphs];
    
    NSError *error;
    NSString *string = [NSString stringWithContentsOfURL:[NSURL URLWithString:urlString] encoding:NSUTF8StringEncoding error:&error];
    if (!string)
    {
        NSLog(@"Error: %@", error.localizedDescription);
        return nil;
    }
    return TrimParas(string, 20);
}

NSString *Ipsum(NSUInteger numberOfParagraphs)
{
    return Lorem(numberOfParagraphs);
}

NSString *AnyIpsum(NSUInteger numberOfParagraphs, NSString *topic)
{
    NSString *urlString = [NSString stringWithFormat:@"http://www.anyipsum.com/api/term/%@/paragraphs/%d", [topic stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], (int) numberOfParagraphs];
    
    NSError *error;
    
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
    if (!data)
    {
        NSLog(@"Error: %@", error.localizedDescription);
        return nil;
    }

    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (!dict)
    {
        NSLog(@"Error creating JSON dictionary: %@", error);
        return nil;
    }
    
    NSString *string = dict[@"anyIpsum"];
    return TrimParas(string, 15);
}

#pragma mark - Test Views
#if TARGET_OS_IPHONE
UIView *BuildView(UIViewController *controller, CGFloat h, CGFloat v, NSString *color, CGFloat alpha, BOOL stylize)
{
    UIView *view = [[UIView alloc] init];
    [controller.view addSubview:view];
    view.translatesAutoresizingMaskIntoConstraints = NO;
    
    // Sizing
    NSDictionary *metrics = @{@"width":@(h), @"height":@(v)};
    NSDictionary *bindings = NSDictionaryOfVariableBindings(view);
    for (NSString *string in @[@"H:[view(width)]", @"V:[view(height)]"])
    {
        NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:string options:0 metrics:metrics views:bindings];
        [view addConstraints:constraints];
    }
    [view layoutIfNeeded]; // pre-pump
    
    // Color -- pass x/skip/etc to skip
    if (!color || (color && [color.lowercaseString hasPrefix:@"random"]))
    {
        view.backgroundColor = Random_Color();
    }
    else if (color)
    {
        NSString *colorRequest = [color stringByAppendingString:@"Color"];
        SEL sel = NSSelectorFromString(colorRequest);
        if ([[UIColor class] respondsToSelector:sel])
        {
            UIColor *c = [[UIColor performSelector:sel] colorWithAlphaComponent:alpha];
            view.backgroundColor = c;
        }
    }
    
    // Stylize
    if (stylize)
    {
        view.layer.borderWidth = 1;
        view.layer.borderColor = [UIColor blackColor].CGColor;
        view.layer.cornerRadius = 12;
    }

    return view;
}

// Place view: tl, tc, tr
//             cl  cc  cr
//             bl  bc  br
// use xx for stretch
void PlaceView(UIViewController *controller, UIView *view, NSString *position, CGFloat inseth, CGFloat insetv, CGFloat priority)
{
    if (!position) return;
    if (position.length != 2) return;
    
    // Place and participate in Auto Layout
    if (!view.superview)
        [controller.view addSubview:view];
    view.translatesAutoresizingMaskIntoConstraints = NO;
    
    // Establish guides, bindings, and metrics
    id topLayoutGuide = controller.topLayoutGuide;
    id bottomLayoutGuide = controller.bottomLayoutGuide;
    NSDictionary *bindings = NSDictionaryOfVariableBindings(view, topLayoutGuide, bottomLayoutGuide);
    NSDictionary *metrics = @{@"inseth":@(inseth), @"insetv":@(insetv), @"priority":@(priority)};

    // StretchV
    if ([position hasPrefix:@"x"])
    {
        NSArray *formats = @[@"V:[topLayoutGuide]-insetv-[view]-insetv-[bottomLayoutGuide]"];
        for (NSString *format in formats)
        {
            NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:format options:0 metrics:metrics views:bindings];
            for (NSLayoutConstraint *c in constraints)
                c.priority = priority;
            [controller.view addConstraints:constraints];
        }
    }
    
    // StretchH
    if ([position hasSuffix:@"x"])
    {
        NSArray *formats = @[@"H:|-inseth-[view]-inseth-|"];
        for (NSString *format in formats)
        {
            NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:format options:0 metrics:metrics views:bindings];
            for (NSLayoutConstraint *c in constraints)
                c.priority = priority;
            [controller.view addConstraints:constraints];
        }
    }
    
    // CenterY
    if ([position hasPrefix:@"c"])
    {
        [controller.view addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:controller.view attribute:NSLayoutAttributeCenterY multiplier:1 constant:insetv]];
    }

    // CenterX
    if ([position hasSuffix:@"c"])
    {
        [controller.view addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:controller.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:inseth]];
    }

    // Updated to take out priorities since they're now added in the final step over all formats
    NSArray *formats = @[@"V:[topLayoutGuide]-insetv-[view]", @"V:[view]-insetv-[bottomLayoutGuide]", @"H:|-inseth-[view]", @"H:[view]-inseth-|"];
    NSMutableArray *appliedFormats = [@[] mutableCopy];
    if ([position hasPrefix:@"t"]) [appliedFormats addObject:formats[0]];
    if ([position hasPrefix:@"b"]) [appliedFormats addObject:formats[1]];
    if ([position hasSuffix:@"l"]) [appliedFormats addObject:formats[2]];
    if ([position hasSuffix:@"r"]) [appliedFormats addObject:formats[3]];
    
    for (NSString *format in appliedFormats)
    {
        NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:format options:0 metrics:metrics views:bindings];
        for (NSLayoutConstraint *c in constraints)
            c.priority = priority;
        [controller.view addConstraints:constraints];
    }
}
#endif