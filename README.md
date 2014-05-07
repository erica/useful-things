#useful-things#
_[Not to be confused with "needful things" (see King, Stephen)]_

* __useful pack__: app store safe and general purpose
* __less useful pack__: fun stuff
* __handy pack__: building demos, assist with dev/testing
* __app store unsafe pack__: for in-house work only
* __constraint minipack__: 85% of what you need in one short .h/.m pair
* __informit__: items from write-ups

***Airplay Motion Effects Enabler***
Enable motion effects over AirPlay. Not App Store safe. Use for creating demos (or in my case, book examples.)

***Blocking Animations***
Stacking solution that avoids nested completion blocks.

***Constraint MiniPack***
Although you'll be best served grabbing the latest version from [my Auto Layout repo](https://github.com/erica/Auto-Layout-Demystified), I've put a copy here for easy reference.

***Dictation Helper***
_See Speech and Dictation_

***Drag In View***
Using damped harmonics to create a draggable drawer. Will add InformIT link when the post goes live.

***GIF Image View***
This is a fairly simple implementation that assumes each GIF frame is linearly spaced out. Use <tt>initWithGIFImagePath:</tt> or <tt>loadGIFFromPath:</tt>.

***Guided Tour***
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

***Handy Pack***
Useful items for testing and development

***Insultomatic***
Returns a random Shakespearian string. Adapted from [Chris Seidel's web page](http://www.pangloss.com/seidel/shake_rule.html)

***Round Image View***
Another "what it says on the label" class. Circular image views with optional borders.

***Speech and Dictation:***
Utilities for speaking and listening. The speaking stuff is App Store safe. The dictation classes are not.

<pre>[SpeechHelper speakModalString:@"Please say something"];
[[DictationHelper sharedInstance] dictateWithDuration:5.0f 
    completion:^(NSString *dictationString) {
        if (dictationString)
            NSLog(@"You said:'%@'", dictationString);
        else
            NSLog(@"No response");}];
</pre>

***Touch Kit***
Add touch points to your apps for creating demos. See [my write up over on InformIT](http://www.informit.com/articles/article.aspx?p=1881388) for details.

***Triggered Taps***
Deliberate touches.  See [my write up on InformIT](http://www.informit.com/articles/article.aspx?p=2211158) for details.

***View Dragging***
From my Auto Layout book, adds constraint-based view dragging. This version is tweaked to remove constraints after moves because I needed to use it to demonstrate view dynamics. For use with the Drag In View. InformIT write-up forthcoming.

##Books##
* [Latest Cookbook](https://github.com/erica/iOS-7-Cookbook)
* [Auto Layout](https://github.com/erica/Auto-Layout-Demystified)
* [Drawing/Quartz](https://github.com/erica/iOS-Drawing)

##Various##
* [NSArray Utilities](https://github.com/erica/NSArray-Utilities)
* [NSDate Utilities](https://github.com/erica/NSDate-Extensions)
* [NSObject Utilities](https://github.com/erica/NSObject-Utility-Categories)
* [Color Utilities](https://github.com/erica/uicolor-utilities)
* [Data Tube](https://github.com/erica/DataTube)
* [ABContact](https://github.com/erica/ABContactHelper)
* [Camera](https://github.com/erica/Camera-Image-Helper)
* [UIDevice](https://github.com/erica/uidevice-extension)
* [Signing Apps](https://github.com/erica/App-Signer)

