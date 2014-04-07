/*
 
 Erica Sadun, http://ericasadun.com
 
 */

#import <UIKit/UIKit.h>
#import "GuidedTourViewController.h"
#import "GuidedTourStage.h"

extern NSString *const kHasBeenTrainedKey;

@protocol TourDelegate <NSObject>
- (void) setInterfaceEnabled: (BOOL) yorn;
@end

@interface GuidedTour : NSObject <UIPopoverControllerDelegate>
+ (BOOL) userWasTrained;
+ (void) setUserWasTrained: (BOOL) yorn;

@property (nonatomic, weak) UIViewController <TourDelegate> *delegate;
@property (nonatomic) NSArray *items;
@property (nonatomic) NSValue *requestedContentSize;
@property (nonatomic, readonly) NSInteger numberOfStages;
@property (nonatomic, readonly) NSInteger currentStage;

- (void) nextStage;
- (void) launch;
- (void) addStage: (GuidedTourStage *) stage;
- (void) repeatStage;
- (void) previousStage;
@end
