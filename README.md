#useful-things#
_[Not to be confused with "needful things" (see King, Stephen)]_

###Speech and Dictation:###
Utilities for speaking and listening. The speaking stuff is App Store safe. The dictation classes are not.

<pre>[SpeechHelper speakModalString:@"Please say something"];
[[DictationHelper sharedInstance] dictateWithDuration:5.0f 
    completion:^(NSString *dictationString) {
        if (dictationString)
            NSLog(@"You said:'%@'", dictationString);
        else
            NSLog(@"No response");}];
</pre>

###Constraint MiniPack###
Although you'll be best served grabbing the latest version from [my Auto Layout repo](https://github.com/erica/Auto-Layout-Demystified), I've put a copy here for easy reference.

###Triggered Taps###
Deliberate touches.  Write-up forthcoming on InformIT. I'll link when it goes live.

###Guided Tour###
What it says on the wrapper. Create a tour, add stages, and let 'er rip. Write-up forthcoming on InformIT. I'll link when it goes live.
<pre>- (void) setupTour
{
    tour = [[GuidedTour alloc] init];
    tour.delegate = self;
    tour.requestedContentSize = [NSValue valueWithCGSize:CGSizeMake(400, 400)];

    GuidedTourStage *stage;    
    stage = [[GuidedTourStage alloc] init];
    stage.header = @"Welcome";
    stage.body = @"Intro Text";
    stage.image = [UIImage imageNamed:@"flowers"];
    [tour addStage:stage];
    
    stage = [[GuidedTourStage alloc] init];
    stage.header = @"Stage 1";
    stage.body = @"Text that talks about <i>Stage 1</i> in an interesting fashion";
    stage.desiredView = button;
    [tour addStage:stage];
    
    stage = [[GuidedTourStage alloc] init];
    stage.header = @"Thank you!";
    stage.body = @"Please enjoy the app.";
    stage.gifPath = [[NSBundle mainBundle] pathForResource:@"clpURch" ofType:@"gif"];
    stage.nextButtonText = @"Done";
    [tour addStage:stage];
}</pre>

###GIF Image View###
This is a fairly simple implementation that assumes each GIF frame is linearly spaced out. Use <tt>initWithGIFImagePath:</tt> or <tt>loadGIFFromPath:</tt>.

###Round Image View###
Another "what it says on the label" class. Circular image views with optional borders.

###Touch Kit###
Add touch points to your apps for creating demos. See [my write up over on InformIT](http://www.informit.com/articles/article.aspx?p=1881388) for details.

###Airplay Motion Effects Enabler###
Enable motion effects over AirPlay. Not App Store safe. Use for creating demos (or in my case, book examples.)