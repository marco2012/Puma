// https://github.com/ipadkid358/DateTap

#import <UIKit/UIKit.h>
// #import<SpringBoard/SpringBoard.h>
#import <AVFoundation/AVFoundation.h>
#import <notify.h>

#define PUMA_PATH @"/var/mobile/Library/Puma/esplodo.aiff"

AVAudioPlayer *audioPlayer;

@interface UIStatusBarWindow : UIWindow
-(void)tapping; //from %new
@end

%hook UIStatusBarWindow

- (instancetype)initWithFrame:(CGRect)frame {
    self = %orig;
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapping)]; //(tapping) will be used as a void down in the %new
    tapRecognizer.numberOfTapsRequired = 2; // 2 taps 
    tapRecognizer.cancelsTouchesInView = NO; //a safe way of adding a gesture, so that it doesn't break other gestures in the view. (thanks squiddy love u)
    [self addGestureRecognizer:tapRecognizer];  //add that tap gesture
    return self;
}

%new // hey lets make a new void 
-(void)tapping {
  notify_post("me.vikings.puma"); 
}
%end

%ctor
{
	if ([NSBundle.mainBundle.bundleIdentifier isEqual:@"com.apple.springboard"]) { //check if its springboard
    	int regToken; // The registration token
		notify_register_dispatch("me.vikings.puma", &regToken, dispatch_get_main_queue(), ^(int token) {  //Request notification delivery to a dispatch queue
			// [((SpringBoard *)[%c(SpringBoard) sharedApplication]) _simulateLockButtonPress]; //locks device :)
			
			//display alert
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"🐯ESPLODOOO🐯" 
				message:@"Ma come faccio a non trombare co sto fisico?!" 
				delegate:nil 
				cancelButtonTitle:@"💥" 
				otherButtonTitles:nil];
			[alert show];
			[alert release];

			//play audio
			NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:PUMA_PATH]];
			audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
			audioPlayer.numberOfLoops = 0;
			audioPlayer.volume = 1.0;
			[audioPlayer play];

		});
	}
}
 