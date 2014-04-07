/*
 
 Erica Sadun, http://ericasadun.com
 
 */

NSString *const kHasBeenTrainedKey = @"kHasBeenTrainedKey";

#import "GuidedTour.h"
#import "GuidedTourViewController.h"

#define BARBUTTON(TITLE, SELECTOR) [[UIBarButtonItem alloc] initWithTitle:TITLE style:UIBarButtonItemStylePlain target:self action:SELECTOR]
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

@implementation GuidedTour
{
    NSUInteger stageIndex;
    UIPopoverController *popover;
    NSMutableArray *stages;
}

- (instancetype) init
{
    if (!(self = [super init])) return self;
    stages = [NSMutableArray array];
    stageIndex = 0;
    return self;
}

- (NSInteger) numberOfStages
{
    return stages.count;
}

- (NSInteger) currentStage
{
    return stageIndex;
}

- (void) addStage: (GuidedTourStage *) aStage
{
    if (aStage) [stages addObject:aStage];
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)aPopoverController
{
    popover = nil;
}

#pragma mark - Training

+ (BOOL) userWasTrained
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:kHasBeenTrainedKey];
}

+ (void) setUserWasTrained: (BOOL) yorn
{
    [[NSUserDefaults standardUserDefaults] setBool:yorn forKey:kHasBeenTrainedKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - Ending

- (void) reallyStopNow
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [GuidedTour setUserWasTrained:YES];
    if (IS_IPAD)
        [_delegate setInterfaceEnabled:YES];
    else
        [_delegate.navigationController popToRootViewControllerAnimated:YES];
    
    return;
}

- (void) skipit
{
    [_delegate.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Stages

- (void) runStage: (NSInteger) theStageIndex
{
    if (IS_IPAD)
        stageIndex = theStageIndex;
    else
        stageIndex = _delegate.navigationController.viewControllers.count - 1;

    // Are we done?
    if (stageIndex >= self.numberOfStages)
    {
        [self reallyStopNow];
        return;
    }
    
    // Create a new stage controller
    GuidedTourViewController *stageController = [[GuidedTourViewController alloc] init];
    stageController.GuidedTour = self;
    stageController.numberOfTourStages = self.numberOfStages;
    stageController.currentStage = stageIndex;
    
    // Use the current stage state to set up the controller
    GuidedTourStage *theStage = stages[stageIndex];
    stageController.header = theStage.header;
    stageController.body = theStage.body;
    stageController.image = theStage.image;
    stageController.gifPath = theStage.gifPath;
    stageController.nextButtonText = theStage.nextButtonText ? : @"Next";
    if (_requestedContentSize)
        stageController.requestedContentSize = _requestedContentSize;
    
    // Allow GuidedTour skip on iPhone
    if (IS_IPHONE)
        _delegate.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Skip Tour" style:UIBarButtonItemStylePlain target:self action:@selector(skipit)];

    // Ready to present
    if (IS_IPAD)
    {
        popover = [[UIPopoverController alloc] initWithContentViewController:stageController];
        stageController.popover = popover;
        popover.delegate = self;

        if (theStage.desiredBarButtonItem)
        {
            stageIndex++;
            [popover presentPopoverFromBarButtonItem:theStage.desiredBarButtonItem permittedArrowDirections: UIPopoverArrowDirectionUp animated:YES];
        }
        else
        {
            CGRect frame = _delegate.navigationController.navigationBar.frame;
            UIPopoverArrowDirection direction = UIPopoverArrowDirectionUp;
            
            if (theStage.desiredView)
            {
                frame = theStage.desiredView.frame;
                direction = UIPopoverArrowDirectionAny;
            }
            [popover presentPopoverFromRect:frame inView:_delegate.view permittedArrowDirections:direction animated:YES];
            stageIndex++;
            return;
        }
    }
    else
    {
        [_delegate.navigationController pushViewController:stageController animated:YES];
    }
}

- (void) nextStage
{
    if (popover) {[popover dismissPopoverAnimated:YES]; popover = nil;}
    [self runStage:stageIndex];
}

- (void) repeatStage
{
    if (popover) {[popover dismissPopoverAnimated:YES]; popover = nil;}
    int s = (int) stageIndex;
    s = MAX(0, s - 1);
    [self runStage:s];
}

- (void) previousStage
{
    if (popover) {[popover dismissPopoverAnimated:YES]; popover = nil;}
    int s = (int) stageIndex;
    s = MAX(0, s - 2);
    [self runStage:s];
}

- (void) launch
{
    if (!_delegate)
    {
        NSLog(@"Error: Must assign tour delegate");
        return;
    }
    
    // Disable interface on iPad, listen for device updates
    if (IS_IPAD)
    {
        [_delegate setInterfaceEnabled:NO];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(repeatStage) name:UIDeviceOrientationDidChangeNotification object:nil];
    }

    stageIndex = 0;
    [self runStage:stageIndex];
}
@end
