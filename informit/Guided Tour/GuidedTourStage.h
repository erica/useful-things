/*
 
 Erica Sadun, http://ericasadun.com
 
 */

#import <Foundation/Foundation.h>

@interface GuidedTourStage : NSObject
@property (nonatomic) NSString *header;
@property (nonatomic) NSString *body;
@property (nonatomic) UIImage *image;
@property (nonatomic) NSString *gifPath;
@property (nonatomic, weak) UIView *desiredView;
@property (nonatomic, weak) UIBarButtonItem *desiredBarButtonItem;
@property (nonatomic) NSString *nextButtonText;
@end
