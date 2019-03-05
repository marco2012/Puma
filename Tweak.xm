// https://github.com/ipadkid358/DateTap
// http://jontelang.com/guide/chapter3/

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <notify.h>

#define PASSOIMG @"/var/mobile/Library/Puma/passo.png"
// static NSString* PUMA_PATH = @"/var/mobile/Library/Puma/passi.aiff";

AVAudioPlayer *audioPlayer;
static BOOL enabled = YES; // Default value

// http://jontelang.com/guide/chapter3/accessing-settings.html
static void loadPrefs() {
    NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/me.vikings.pumaprefs.plist"];
        enabled = ( [prefs objectForKey:@"pumaon"] ? [[prefs objectForKey:@"pumaon"] boolValue] : enabled );
        // enabled = [[prefs objectForKey:@"pumaon"] boolValue];
    [prefs release];
}

// The %ctor thing here is a method which will run when the tweak is loaded, it will only run once (per respring) and is the place we use to register the tweak for listening to our PostNotification
%ctor 
{
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)loadPrefs, CFSTR("me.vikings.pumaprefs/settingschanged"), NULL, CFNotificationSuspensionBehaviorCoalesce);
    loadPrefs();
}


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
    loadPrefs();
    if (enabled) {
        notify_post("me.vikings.puma"); 
    }
}


%end

static void startPuma(NSString* title, NSString* audio) {

    //random message
    NSArray *moodArray = @[
        @"Vado giù perpendicolare", 
        @"Baffo se voglio", 
        @"Matto se voglio", 
        @"Dipre paura Dipre paura", 
        @"Son matto", 
        @"Ma come faccio a non trombare co sto fisico?!",
        @"Nossa nossa il puma fa la mossa" ,
        @"Ai se ti piego ai ai se ti piego" , 
        @"Catafratti" 
    ];
    NSString *randomMessage = [moodArray objectAtIndex:arc4random()%[moodArray count]];
    
    //play audio
    NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat: @"/var/mobile/Library/Puma/%@.aiff", audio]];
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    audioPlayer.numberOfLoops = 0;
    audioPlayer.volume = 1.0;
    [audioPlayer play];

    //display alert
    UIAlertController* alert = [UIAlertController
                                    alertControllerWithTitle: title
                                    message:randomMessage
                                    preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* cancel = [UIAlertAction
                                actionWithTitle:@"💥💥💥"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action) {
                                    [audioPlayer stop];                         
                                }];
    [alert addAction:cancel]; 

    // //https://stackoverflow.com/questions/2323557/is-it-possible-to-show-an-image-in-uialertview
    // UIImage *image = [UIImage imageWithContentsOfFile: PASSOIMG ];
    // CGSize size = image.size;
    // UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake (100, 200, 100, 100)];
    // imageView.image = image;
    // [alert.view addSubview:imageView];

    //https://www.reddit.com/r/jailbreakdevelopers/comments/5xv9yo/replacing_deprecated_uiactionsheet_with/
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil]; 

}

%ctor
{
	if ([NSBundle.mainBundle.bundleIdentifier isEqual:@"com.apple.springboard"]) { //check if its springboard
    	int regToken; // The registration token
		notify_register_dispatch("me.vikings.puma", &regToken, dispatch_get_main_queue(), ^(int token) {  //Request notification delivery to a dispatch queue
			
            // random action
            NSArray *actionArray = @[
                @"esplodo", 
                @"passi", 
                @"paura", 
                @"trombare",
                @"belino"
            ];
            NSString *randomAction = [actionArray objectAtIndex:arc4random()%[actionArray count]];

            if([randomAction isEqual:@"esplodo"]){
                startPuma(@"🐯ESPLODOOO🐯", randomAction);
            } else if ([randomAction isEqual:@"passi"]) {
                startPuma(@"🐯VADO GIU PERPENDICOLARE🐯", randomAction);
            } else if ([randomAction isEqual:@"paura"]) {
                startPuma(@"🐯DIPRE PAURA🐯", randomAction);
            } else if ([randomAction isEqual:@"trombare"]) {
                startPuma(@"🐯MA COME FACCIO A NON TROMBARE CO STO FISICO🐯", randomAction);
            } else if ([randomAction isEqual:@"belino"]) {
                startPuma(@"🐯ME NE SBATTO IL BELINO🐯", randomAction);
            } 

		});
	}
}
 