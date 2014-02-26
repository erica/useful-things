#useful-things
_[Not to be confused with "needful things" (see King, Stephen)]_

###Speech and Dictation:###

<pre>
[SpeechHelper speakModalString:@"Please say something"];
[[DictationHelper sharedInstance] dictateWithDuration:5.0f 
    completion:^(NSString *dictationString) {
        if (dictationString)
            NSLog(@"You said:'%@'", dictationString);
        else
            NSLog(@"No response");}];
</pre>