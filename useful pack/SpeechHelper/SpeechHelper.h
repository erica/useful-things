/*
 
 Erica Sadun, http://ericasadun.com
 
 */

#import <Foundation/Foundation.h>

@interface SpeechHelper : NSObject
@property (nonatomic) CGFloat rate;
- (void) speakString: (NSString *) string;
- (void) speakModalString: (NSString *) string;

+ (void) speakString: (NSString *) string;
+ (void) speakModalString: (NSString *) string;
@end
