// https://github.com/ipadkid358/DateTap

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <notify.h>

#define ESPLODO @"/var/mobile/Library/Puma/esplodo.aiff"
#define PASSI @"/var/mobile/Library/Puma/passi.aiff"
#define PAURA @"/var/mobile/Library/Puma/paura.aiff"
#define TROMBARE @"/var/mobile/Library/Puma/trombare.aiff"
#define PASSOIMG @"/var/mobile/Library/Puma/passo.png"
// static NSString* PUMA_PATH = @"/var/mobile/Library/Puma/passi.aiff";

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
			
            // NSMutableDictionary *plist = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/me.vikings.puma.plist"];
            // static BOOL mossa = [[plist objectForKey:@"mossa"]boolValue];

            //random message
            NSArray *moodArray = @[
                @"Vado giù perpendicolare", 
                @"Baffo se voglio", 
                @"Dipre paura Dipre paura", 
                @"Son matto", 
                @"Matto se voglio", 
                @"Ma come faccio a non trombare co sto fisico?!",
                @"Nossa nossa il puma fa la mossa" 
            ];
            NSString *randomMessage = [moodArray objectAtIndex:arc4random()%[moodArray count]];

            // random action
            // NSArray *actionArray = @[
            //     @"esplodo", 
            //     @"passi", 
            //     @"paura", 
            //     @"trombare"
            // ];
            // NSString *randomAction = [actionArray objectAtIndex:arc4random()%[actionArray count]];
            NSString *randomAction = @"esplodo"; //REMOVE

            if([randomAction isEqual:@"esplodo"]){

                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"🐯ESPLODOOO🐯"
                                                    message:randomMessage
                                                   delegate:nil
                                          cancelButtonTitle:@"💥💥💥"
                                          otherButtonTitles:nil];
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(220, 80, 50, 50)];
                NSString *path = [[NSString alloc] initWithString:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:PASSOIMG]];
                UIImage *img = [[UIImage alloc] initWithContentsOfFile:path];
                [basePic setImage:[UIImage imageWithContentsOfFile:@"//var/mobile/Library/Puma/passo.png"]];

                // UIImage *img = [UIImage imageNamed:@"passo.png"];
                imageView.contentMode = UIViewContentModeScaleAspectFit;

                [imageView setImage:img];
                if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
                    [alert setValue:imageView forKey:@"accessoryView"];
                }else{
                    [alert addSubview:imageView];
                }
                [alert show];
                [alert release];

                
                // UIAlertView *successAlert = [[UIAlertView alloc] initWithTitle:@"🐯ESPLODOOO🐯" message:randomMessage delegate:nil cancelButtonTitle:@"💥💥💥" otherButtonTitles:nil];
                // UIImageView *imageViewCloud = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 40, 40)];
                // UIImage *bkgImg = [UIImage imageNamed:@"passo"];
                // NSString *path = [[NSString alloc] initWithString:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:PASSOIMG]];
                // UIImage *bkgImg = [[UIImage alloc] initWithContentsOfFile:path];
                // [imageViewCloud setImage:bkgImg];
                // // [successAlert imageViewCloud forKey:@"accessoryView"];
                // [successAlert addSubview:imageViewCloud];
                // [successAlert show];
                // [successAlert release];

            
                // UIAlertView *successAlert = [[UIAlertView alloc] initWithTitle:@"🐯ESPLODOOO🐯" message:randomMessage delegate:nil cancelButtonTitle:@"💥💥💥" otherButtonTitles:nil];
                // UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(220, 10, 40, 40)];
                // NSString *path = [[NSString alloc] initWithString:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:PASSOIMG]];
                // UIImage *bkgImg = [[UIImage alloc] initWithContentsOfFile:path];
                // [imageView setImage:bkgImg];
                // [successAlert addSubview:imageView];
                // [successAlert show];
                // [successAlert release];

                // //display alert
                // UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"🐯Mossa se voglio🐯" 
                //     message: randomMessage
                //     delegate:nil 
                //     cancelButtonTitle:@"💥💥💥" 
                //     otherButtonTitles:nil];
                // [alert show];
                // [alert release];

                //play audio
                NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat: ESPLODO]];
                audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
                audioPlayer.numberOfLoops = 0;
                audioPlayer.volume = 1.0;
                [audioPlayer play];
                
            } else if ([randomAction isEqual:@"passi"]) {
                //display alert
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"🐯VADO GIU PERPENDICOLARE🐯" 
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

            } else if ([randomAction isEqual:@"paura"]) {
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

            } else if ([randomAction isEqual:@"trombare"]) {
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
            } 

		});
	}
}
 