//
//  AppDelegate.m
//  MyCocoaApp
//
//  Created by Erica Sadun on 2/18/15.
//  Copyright (c) 2015 Erica Sadun. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate
{
    NSString *lorem;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    lorem = _textView.string;
    NSAttributedString *outputString = [[NSAttributedString alloc] initWithString:lorem attributes:@{NSFontAttributeName : [NSFont fontWithName:@"Georgia" size:18.0]}];
    [_textView.textStorage setAttributedString:outputString];
}

- (void) controlTextDidChange: (NSNotification *) notification
{
    if (notification.object != _textField) return;
    
    NSMutableAttributedString *outputString =   [[NSMutableAttributedString alloc] initWithString:lorem attributes:@{NSFontAttributeName : [NSFont fontWithName:@"Georgia" size:18.0]}];
    [_textView.textStorage setAttributedString:outputString];
    
    NSString *sourceString = _textField.stringValue;
    sourceString = [sourceString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:sourceString options:0 error:&error];
    if (!regex) return;
    
    [regex enumerateMatchesInString:lorem options:0 range:NSMakeRange(0, lorem.length) usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop)
     {
         NSRange range = match.range;
         BOOL abut = (range.location + range.length) >= lorem.length;
         if (!abut)
         {
             [outputString addAttribute:NSForegroundColorAttributeName value:[NSColor greenColor] range:range];
             [outputString addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleThick) range:range];
         }
     }];
    
    [_textView.textStorage setAttributedString:outputString];
}
@end
