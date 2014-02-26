//
//  SpeechHelper.h
//  Hello World
//
//  Created by Erica Sadun on 2/26/14.
//  Copyright (c) 2014 Erica Sadun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SpeechHelper : NSObject
@property (nonatomic) CGFloat rate;
- (void) speakString: (NSString *) string;
- (void) speakModalString: (NSString *) string;

+ (void) speakString: (NSString *) string;
+ (void) speakModalString: (NSString *) string;
@end
