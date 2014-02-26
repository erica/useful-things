/*
 
 Erica Sadun, http://ericasadun.com
 
 NOT APP STORE SAFE BUT HANDY

 */


#import "DictationHelper.h"
#define MAKELIVE(_CLASSNAME_)	Class _CLASSNAME_ = NSClassFromString((NSString *)CFSTR(#_CLASSNAME_));

NSString *const DictationStringResults = @"Dictation String Results";

static DictationHelper *sharedInstance = nil;

@class UIDictationController;

@interface UIDictationController
+ (UIDictationController *) activeInstance;
+ (UIDictationController *) sharedInstance;
- (void) startDictation;
- (void) stopDictation;
- (void) preheatIfNecessary;
@end;

@interface DictationHelper () <UITextFieldDelegate>
@end

@implementation DictationHelper
{
    UITextField *secretView;
    id dictationController;
    DictationBlock completion;
}

- (void) preheat
{
    if (!secretView)
    {
        secretView = [[UITextField alloc] init];
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        [window addSubview:secretView];
        secretView.inputView = [[UIView alloc] init];
        secretView.delegate = self;
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
    
    return YES;
}

- (void) dictateWithDuration: (CGFloat) numberOfSeconds
{
    secretView.text = @"";
    [secretView becomeFirstResponder];
    
    [[UIDevice currentDevice] playInputClick];
    [dictationController startDictation];
    [self performSelector:@selector(stopDictation) withObject:nil afterDelay:numberOfSeconds];
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