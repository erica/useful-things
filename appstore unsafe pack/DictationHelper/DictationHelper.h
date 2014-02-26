/*
 
 Erica Sadun, http://ericasadun.com
 
 NOT APP STORE SAFE BUT HANDY
 Siri-ready devices only. Will not work in simulator.
 
 */


#import <Foundation/Foundation.h>

extern NSString *const DictationStringResults;

typedef void (^DictationBlock)(NSString *dictationString);

@interface DictationHelper : NSObject
+ (instancetype) sharedInstance;
- (void) dictateWithDuration: (CGFloat) duration;
- (void) dictateWithDuration: (CGFloat) duration completion:(DictationBlock) completionBlock;
@end
