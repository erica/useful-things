/*
 
 Erica Sadun, http://ericasadun.com
 
 NOT APP STORE SAFE BUT HANDY
 Siri-ready devices only. Will not work in simulator.

 */


#import "DictationHelper.h"
#define MAKELIVE(_CLASSNAME_)	Class _CLASSNAME_ = NSClassFromString((NSString *)CFSTR(#_CLASSNAME_));

NSString *const DictationStringResults = @"Dictation String Results";

static DictationHelper *sharedInstance = nil;

@class UIDictationController;

@interface UIDictationController
+ (UIDictationController *) sharedInstance;
- (void) startDictation;
- (void) stopDictation;
- (void) preheatIfNecessary;
@end;

@interface DictationHelper () <UITextFieldDelegate>
@end

@implementation DictationHelper
{
    UITextField *secretTextField;
    id dictationController;
    DictationBlock completion;
    BOOL handled;
}

- (void) preheat
{
    if (!secretTextField)
    {
        secretTextField = [[UITextField alloc] initWithFrame:CGRectZero];
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        [window addSubview:secretTextField];
        secretTextField.inputView = [[UIView alloc] init];
        secretTextField.delegate = self;
    }
    
    if (!dictationController)
    {
        MAKELIVE(UIDictationController);
        dictationController = [UIDictationController sharedInstance];
        [dictationController preheatIfNecessary];
    }
}

+ (instancetype) sharedInstance
{
    if (!sharedInstance)
    {
        sharedInstance = [[self alloc] init];
        [sharedInstance preheat];
    }
    return sharedInstance;
}


- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *tftext = textField.text;
    tftext = [tftext stringByReplacingCharactersInRange:range withString:string];
    [[NSNotificationCenter defaultCenter] postNotificationName:DictationStringResults object:tftext];
    
    if (completion) completion(tftext);
    
    // Treat this dictation as handled
    handled = YES;
    _inUse = NO;
    completion = nil;

    // Resign first responder
    [textField resignFirstResponder];
    
    return YES;
}

- (void) fallback
{
    // 1. Test completion
    if (!completion) return;

    // 2. Check for handled
    if (handled)
    {
        _inUse = NO;
        handled = NO;
        return;
    }
    
    // 3. Assume the dictation didn't work
    completion(nil);
    
    // 4. Reset everything
    handled = NO;
    _inUse = NO;
    completion = nil;
    
    // 5. Resign first responder
    [secretTextField resignFirstResponder];
}

- (void) dictateWithDuration: (CGFloat) numberOfSeconds
{
    if (_inUse)
    {
        NSLog(@"Error: Dictation Helper already in use");
        return;
    }
    
    _inUse = YES;
    handled = NO;
        
    secretTextField.text = @"";
    [secretTextField becomeFirstResponder];
    
    [[UIDevice currentDevice] playInputClick];
    [dictationController startDictation];
    [self performSelector:@selector(stopDictation) withObject:nil afterDelay:numberOfSeconds];
    [self performSelector:@selector(fallback) withObject:nil afterDelay:numberOfSeconds + 1.0f];
}

- (void) dictateWithDuration: (CGFloat) duration completion:(DictationBlock) completionBlock
{
    if (completionBlock) completion = completionBlock;
    [self dictateWithDuration:duration];
}

- (void) stopDictation
{
    [dictationController stopDictation];
}
@end

#undef MAKELIVE