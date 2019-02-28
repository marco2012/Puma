// https://github.com/ipadkid358/DateTap

#import <UIKit/UIKit.h>
// #import<SpringBoard/SpringBoard.h>
#import <AVFoundation/AVFoundation.h>
#import <notify.h>

#define ESPLODO @"/var/mobile/Library/Puma/esplodo.aiff"
#define PASSI @"/var/mobile/Library/Puma/passi.aiff"
#define PAURA @"/var/mobile/Library/Puma/paura.aiff"
#define TROMBARE @"/var/mobile/Library/Puma/trombare.aiff"

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

            static BOOL trombare = NO;
            trombare = [[plist objectForKey:@"trombare"]boolValue];

            static BOOL paura = NO;
            paura = [[plist objectForKey:@"paura"]boolValue];
            
            NSArray *moodArray = @[@"Vado giù perpendicolare", @"Baffo se voglio", @"Dipre paura Dipre paura", @"Son matto", @"Matto se voglio", @"Ma come faccio a non trombare co sto fisico?!",@"Nossa nossa il puma fa la mossa" ];
            NSString *randomMessage = [moodArray objectAtIndex:arc4random()%[moodArray count]];

            if(mossa){
                // static NSString* PUMA_PATH = @"/var/mobile/Library/Puma/passi.aiff";

            UIAlertView *successAlert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];

    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(220, 10, 40, 40)];

    NSString *path = [[NSString alloc] initWithString:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"smile.png"]];
    UIImage *bkgImg = [[UIImage alloc] initWithContentsOfFile:path];
    [imageView setImage:bkgImg];

    [successAlert addSubview:imageView];

    [successAlert show];


                //display alert
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"🐯Mossa se voglio🐯" 
                    message: randomMessage
                    delegate:nil 
                    cancelButtonTitle:@"💥💥💥" 
                    otherButtonTitles:nil];
                [alert show];
                [alert release];

                //play audio
                NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat: PASSI]];
                audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
                audioPlayer.numberOfLoops = 0;
                audioPlayer.volume = 1.0;
                [audioPlayer play];
                
            } else if (trombare) {
                //display alert
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"🐯MA COME FACCIO A NON TROMBARE CO STO FISICO🐯" 
                    message: randomMessage
                    delegate:nil 
                    cancelButtonTitle:@"💥💥💥" 
                    otherButtonTitles:nil];
                [alert show];
                [alert release];

                //play audio
                NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat: TROMBARE]];
                audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
                audioPlayer.numberOfLoops = 0;
                audioPlayer.volume = 1.0;
                [audioPlayer play];
            } else if (paura) {
                //display alert
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"🐯DIPRE PAURA🐯" 
                    message: randomMessage
                    delegate:nil 
                    cancelButtonTitle:@"💥💥💥" 
                    otherButtonTitles:nil];
                [alert show];
                [alert release];

                //play audio
                NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat: PAURA]];
                audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
                audioPlayer.numberOfLoops = 0;
                audioPlayer.volume = 1.0;
                [audioPlayer play];
            } else {

                // static NSString* PUMA_PATH = @"/var/mobile/Library/Puma/esplodo.aiff";

                //display alert
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"🐯ESPLODOOO🐯" 
                    message: randomMessage
                    delegate:nil 
                    cancelButtonTitle:@"💥💥💥" 
                    otherButtonTitles:nil];
                [alert show];
                [alert release];

                //play audio
                NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:ESPLODO]];
                audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
                audioPlayer.numberOfLoops = 0;
                audioPlayer.volume = 1.0;
                [audioPlayer play];
            }

		});
	}
}
 