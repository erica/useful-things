/*
 
 Erica Sadun, http://ericasadun.com
 
 */

#import <UIKit/UIKit.h>

#if !__has_include("UIImageView+GIF.h")
#error ERROR! Required UIImageView+GIF.h not found!
#endif
#import "UIImageView+GIF.h"


@interface GuidedTourViewController : UIViewController
// Provided by stage
@property (nonatomic) NSString *header;
@property (nonatomic) NSString *body;
@property (nonatomic) UIImage *image;
@property (nonatomic) NSString *gifPath;
@property (nonatomic) NSString *nextButtonText;

// Provided by tour
@property (nonatomic) NSValue *requestedContentSize;
@property (nonatomic) NSInteger numberOfTourStages;
@property (nonatomic) NSInteger currentStage;
@property (nonatomic, weak) UIPopoverController *popover;

// 2-way reference to tour
@property (nonatomic, weak) id guidedTour;
@end
