// https://github.com/ipadkid358/DateTap

#import <UIKit/UIKit.h>
// #import<SpringBoard/SpringBoard.h>
#import <AVFoundation/AVFoundation.h>
#import <notify.h>

// #define PUMA_PATH @"/var/mobile/Library/Puma/esplodo.aiff"

AVAudioPlayer *audioPlayer;

@interface UIStatusBarWindow : UIWindow
-(void)tapping; 
@end

%hook UIStatusBarWindow

- (instancetype)initWithFrame:(CGRect)frame {
    self = %orig;
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapping)]; //(tapping) will be used as a void down in the %new
    tapRecognizer.numberOfTapsRequired = 2; // 2 taps 
    tapRecognizer.cancelsTouchesInView = NO; //a safe way of adding a gesture, so that it doesn't break other gestures in the view. 
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
			
            NSMutableDictionary *plist = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/me.vikings.puma.plist"];
            static BOOL mossa = NO;
            mossa = [[plist objectForKey:@"mossa"]boolValue];
            
            NSArray *moodArray = @[@"Vado giù perpendicolare", @"Baffo se voglio", @"Dipre paura Dipre paura", @"Son matto", @"Matto se voglio", @"Ma come faccio a non trombare co sto fisico?!" ];
            NSString *randomMessage = [moodArray objectAtIndex:arc4random()%[moodArray count]];

            if(mossa){
                static NSString* PUMA_PATH = @"/var/mobile/Library/Puma/passi.aiff";

                //display alert
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"🐯Mossa se voglio🐯" 
                    message: randomMessage
                    delegate:nil 
                    cancelButtonTitle:@"💥💥💥" 
                    otherButtonTitles:nil];
                [alert show];
                [alert release];

                //play audio
                NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@", PUMA_PATH]];
                audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
                audioPlayer.numberOfLoops = 0;
                audioPlayer.volume = 1.0;
                [audioPlayer play];
                
            } else {

                static NSString* PUMA_PATH = @"/var/mobile/Library/Puma/esplodo.aiff";

                //display alert
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"🐯ESPLODOOO🐯" 
                    message: randomMessage
                    delegate:nil 
                    cancelButtonTitle:@"💥💥💥" 
                    otherButtonTitles:nil];
                [alert show];
                [alert release];

                //play audio
                NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@", PUMA_PATH]];
                audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
                audioPlayer.numberOfLoops = 0;
                audioPlayer.volume = 1.0;
                [audioPlayer play];
            }

		});
	}
}
 