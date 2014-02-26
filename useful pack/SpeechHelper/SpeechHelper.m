//
//  SpeechHelper.m
//  Hello World
//
//  Created by Erica Sadun on 2/26/14.
//  Copyright (c) 2014 Erica Sadun. All rights reserved.
//

#import "SpeechHelper.h"

@import AVFoundation;

@interface SpeechHelper () <AVSpeechSynthesizerDelegate>
@end

@implementation SpeechHelper
{
    CFRunLoopRef runLoop;
}

- (instancetype) init
{
    if (!(self = [super init])) return self;
    _rate = 0.2f;
    return self;
}

- (void) setRate:(CGFloat)rate
{
    // Clamp between 0 and 1
    CGFloat r = fminf(fmaxf(rate, 0.0f), 1.0f);
    _rate = r;
}

- (void) speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didFinishSpeechUtterance:(AVSpeechUtterance *)utterance
{
    CFRunLoopStop(runLoop);
    runLoop = nil;
}

- (void) speakString: (NSString *) string withDelegate: (id <AVSpeechSynthesizerDelegate>) delegate
{
    // Establish a new utterance
    AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:string];
    
    // Slow down the rate
    CGFloat rateRange = AVSpeechUtteranceMaximumSpeechRate - AVSpeechUtteranceMinimumSpeechRate;
    utterance.rate = AVSpeechUtteranceMinimumSpeechRate + rateRange * _rate;
    
    // Set the language
    NSString *languageCode = [[NSLocale currentLocale] objectForKey:NSLocaleLanguageCode] ? : @"en-us";
    utterance.voice = [AVSpeechSynthesisVoice voiceWithLanguage:languageCode];
    
    // Speak
    AVSpeechSynthesizer *synthesizer = [[AVSpeechSynthesizer alloc] init];
    synthesizer.delegate = delegate;
    [synthesizer speakUtterance:utterance];
    
    if (delegate)
    {
        runLoop = CFRunLoopGetCurrent();
        CFRunLoopRun();
    }
}

- (void) speakModalString: (NSString *) string
{
    [self speakString:string withDelegate:self];
}

- (void) speakString:(NSString *) string
{
    [self speakString:string withDelegate:nil];
}

+ (void) speakModalString:(NSString *)string
{
    // Uses class default rate of 0.2f
    SpeechHelper *ms = [[self alloc] init];
    [ms speakModalString:string];
}

+ (void) speakString:(NSString *)string
{
    // Uses class default rate of 0.2f
    SpeechHelper *ms = [[self alloc] init];
    [ms speakString:string];
}
@end
