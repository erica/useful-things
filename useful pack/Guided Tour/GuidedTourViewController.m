/*
 
 Erica Sadun, http://ericasadun.com
 
 */

#define BARBUTTON(TITLE, SELECTOR) [[UIBarButtonItem alloc] initWithTitle:TITLE style:UIBarButtonItemStylePlain target:self action:SELECTOR]
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)


#import "GuidedTourViewController.h"
#import "GuidedTour.h"
#import "ConstraintPack.h"
#import "UIImageView+GIF.h"

@interface BlandTextView : UITextView
@end

@implementation BlandTextView
- (BOOL)canBecomeFirstResponder
{
    return NO;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    return NO;
}
@end

@implementation GuidedTourViewController
{
    BlandTextView *textView;
    NSAttributedString *string;
}
- (id) init
{
    if (!(self = [super init])) return nil;
    
    string = [[NSAttributedString alloc] init];
    self.modalInPopover = YES;
    
    return self;
}

- (void) finished
{
    if (IS_IPAD)
        [_popover dismissPopoverAnimated:YES];

    [_guidedTour nextStage];
}

- (void) viewWillAppear: (BOOL) animated
{
    self.navigationItem.rightBarButtonItem = BARBUTTON(_nextButtonText, @selector(finished));
}

- (NSAttributedString *) contentString
{
    NSString *htmlString = [NSString stringWithFormat:@"<h2>%@</h2>%@", _header, _body];
    NSData *data = [htmlString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dictionary = @{NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType};
    NSAttributedString *contentString = [[NSAttributedString alloc] initWithData: data options:dictionary documentAttributes:nil error:nil];
    return contentString;
}

- (void) loadView
{
    self.view = [[UIView alloc] init];
    self.view.backgroundColor = [UIColor lightGrayColor];
    self.preferredContentSize = _requestedContentSize ? _requestedContentSize.CGSizeValue :  CGSizeMake(320.0f, 300.0f);
    self.extendLayoutUnderBars = NO;

    // Add text view
    textView = [[BlandTextView alloc] init];
    textView.editable = NO;
    [self.view addSubview:textView];
    textView.autoLayoutEnabled = YES;
    StretchViewHorizontallyToSuperview(textView, 0, 1000);
    StretchViewToTopLayoutGuide(self, textView, 20, 1000);
    StretchViewToBottomLayoutGuide(self, textView, 0, 1000);
    textView.attributedText = [self contentString];

    // Page control
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    pageControl.autoLayoutEnabled = YES;
    pageControl.userInteractionEnabled = NO;
    pageControl.numberOfPages = _numberOfTourStages;
    pageControl.currentPage = _currentStage;
    [self.view addSubview:pageControl];
    StretchViewToTopLayoutGuide(self, pageControl, 0, 1000);
    SizeView(pageControl, CGSizeMake(SkipConstraint, 20), 1000);
    StretchViewHorizontallyToSuperview(pageControl, 8, 1000);
    
    BOOL finalStage = !(_currentStage < (_numberOfTourStages - 1));

    // Next button
    if (IS_IPAD)
    {
        NSString *nextText = finalStage ? @"Done" : @"Next";
        nextText = _nextButtonText ? : nextText;
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        [button setTitle:nextText forState:UIControlStateNormal];
        [self.view addSubview:button];
        button.autoLayoutEnabled = YES;
        AlignViewInSuperview(button, NSLayoutAttributeBottom, 8, 500);
        AlignViewInSuperview(button, NSLayoutAttributeRight, 8, 500);
        [button addTarget:self action:@selector(finished) forControlEvents:UIControlEventTouchUpInside];
    }
    
    // Image view
    UIImageView *imageView = [[UIImageView alloc] initWithImage:_image];
    if (_gifPath) [imageView loadGIFFromPath:_gifPath];
    [self.view addSubview:imageView];
    imageView.autoLayoutEnabled = YES;
    AlignViewInSuperview(imageView, NSLayoutAttributeBottom, 8, 500);
    if (IS_IPAD)
        AlignViewInSuperview(imageView, NSLayoutAttributeLeft, 8, 500);
    else
        CenterViewInSuperview(imageView, YES, NO, 1000);
    
    // Next Stage swipe
    if (!finalStage)
    {
        UISwipeGestureRecognizer *left = [[UISwipeGestureRecognizer alloc] initWithTarget:_guidedTour action:@selector(nextStage)];
        left.direction = UISwipeGestureRecognizerDirectionLeft;
        [self.view addGestureRecognizer:left];
    }
    
    // Previous Stage swipe
    UISwipeGestureRecognizer *right = [[UISwipeGestureRecognizer alloc] initWithTarget:_guidedTour action:@selector(previousStage)];
    right.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:right];
}
@end
