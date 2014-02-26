/*
 
 Erica Sadun, http://ericasadun.com
 
 NOT APP STORE SAFE BUT HANDY
 Siri-ready devices only. Will not work in simulator.
 
 Example:
 
 [SpeechHelper speakModalString:@"Please say something"];
 [[DictationHelper sharedInstance] dictateWithDuration:5.0f completion:^(NSString *dictationString) {
     if (dictationString)
         NSLog(@"You said:'%@'", dictationString);
     else
         NSLog(@"No response");}];

 */


#import <Foundation/Foundation.h>

extern NSString *const DictationStringResults;

typedef void (^DictationBlock)(NSString *dictationString);

@interface DictationHelper : NSObject
+ (instancetype) sharedInstance;
- (void) dictateWithDuration: (CGFloat) duration;
- (void) dictateWithDuration: (CGFloat) duration completion:(DictationBlock) completionBlock;
@property (nonatomic, readonly) BOOL inUse;
@end
