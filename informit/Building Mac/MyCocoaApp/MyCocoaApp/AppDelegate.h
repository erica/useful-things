//
//  AppDelegate.h
//  MyCocoaApp
//
//  Created by Erica Sadun on 2/18/15.
//  Copyright (c) 2015 Erica Sadun. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>
@property (unsafe_unretained) IBOutlet NSTextView *textView;
@property (weak) IBOutlet NSTextField *textField;
@end

