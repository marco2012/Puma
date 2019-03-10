// https://github.com/ipadkid358/DateTap
// http://jontelang.com/guide/chapter3/

#import "Headers.h"
#define PACKAGE_NAME "me.vikings.puma"

AVAudioPlayer *audioPlayer;
static BOOL enabled; 
static BOOL bestemmie; 
static BOOL useHaptic;
static BOOL random_notifications;
static int forceLevel;


@implementation FeedbackCall
+(void)vibrateDevice {
	// if(useHaptic) {
	// 	UIImpactFeedbackGenerator * feedback = [[UIImpactFeedbackGenerator alloc] initWithStyle:forceLevel];
	// 	[feedback prepare];
	// 	[feedback impactOccurred];
	// } if(!useHaptic) {
	// 	AudioServicesPlaySystemSound(1519);
	// }
    if(useHaptic) {
        AudioServicesPlaySystemSound(forceLevel);
    }
}
@end

//---Test Vibration---//
void startTestVibration() {
	// [FeedbackCall vibrateDevice];
    AudioServicesPlaySystemSound(forceLevel);
}

//---Respring---//
static void respring() {
  [[%c(FBSystemService) sharedInstance] exitAndRelaunch:YES];
}

//---Preferences---//
static void loadPrefs() {
	static NSString *file = @"/User/Library/Preferences/me.vikings.pumaprefs.plist";
	NSMutableDictionary *preferences = [[NSMutableDictionary alloc] initWithContentsOfFile:file];
	if(!preferences) {
		preferences          = [[NSMutableDictionary alloc] init];
		enabled              = YES;
		bestemmie            = NO;
		useHaptic            = YES;
		forceLevel           = 1521;
		random_notifications = NO;
		[preferences writeToFile:file atomically:YES];
	} else {
		enabled              = [[preferences objectForKey:@"enabled"] boolValue];
		bestemmie            = [[preferences objectForKey:@"bestemmie"] boolValue];
		useHaptic            = [[preferences objectForKey:@"useHaptic"] boolValue];
		forceLevel           = [[preferences objectForKey:@"forceLevel"] intValue];
		random_notifications = [[preferences objectForKey:@"random_notifications"] boolValue];
	}
	[preferences release];
}

static NSString *nsNotificationString = @"me.vikings.pumaprefs/preferences.changed";
static void notificationCallback(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
    loadPrefs();
}

%ctor {
	NSAutoreleasePool *pool = [NSAutoreleasePool new];
	loadPrefs();
	notificationCallback(NULL, NULL, NULL, NULL, NULL);
	
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)startTestVibration, CFSTR("me.vikings.puma-testvibration"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
	
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)respring, CFSTR("me.vikings.puma-respring"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
	
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, notificationCallback, (CFStringRef)nsNotificationString, NULL, CFNotificationSuspensionBehaviorCoalesce);
	
    [pool release];
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
    if (enabled) {
        notify_post(PACKAGE_NAME); 
    }
}


%end

static NSString * generateRandomAction() {

    // // random action
    // NSArray *actionArray = @[
    //     @"esplodo", 
    //     @"passi", 
    //     @"paura", 
    //     @"trombare",
    //     @"belino",
    //     @"catafratti",
    //     @"mossa_se_voglio",
    //     @"nossa",
    //     @"sabatu_na_trombata",
    //     @"baffo_se_voglio",
    //     @"perpendicolare",
    //     @"se_voglio",
    //     @"lucapuma",
    //     @"non_son_buono"
    // ];

    NSMutableArray *actionArray = [[NSMutableArray alloc] initWithObjects:
        @"esplodo", 
        @"passi", 
        @"paura", 
        @"trombare",
        @"belino",
        @"catafratti",
        @"mossa_se_voglio",
        @"nossa",
        @"sabatu_na_trombata",
        @"baffo_se_voglio",
        @"perpendicolare",
        @"se_voglio",
        @"lucapuma",
        @"non_son_buono",
        nil];

    if (bestemmie){
        NSArray *bestemmie = @[
            @"bestemmie_dipre_paura", 
            @"bestemmie_esplodo", 
            @"bestemmie_mossa_se_voglio", 
            @"bestemmie_se_voglio"
        ];
        [actionArray addObjectsFromArray: bestemmie];
    }

    NSString *randomAction = [actionArray objectAtIndex:arc4random()%[actionArray count]];
    return randomAction;
}

static NSString * generateRandomMessage() {
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
        @"Sabatu na trombata" , 
        @"Catafratti", 
        @"Mossa se voglio", 
        @"Quale mossa che non son buono a farla?!", 
        @"Non sento niente" 
    ];
    NSString *randomMessage = [moodArray objectAtIndex:arc4random()%[moodArray count]];
    return randomMessage;
}

static NSString * generateTitle(NSString *randomAction) {
    NSString* title = @"";
    if([randomAction isEqual:@"esplodo"] || [randomAction isEqual:@"bestemmie_esplodo"]){
        title = @"ESPLODOOO";
    } else if ([randomAction isEqual:@"passi"]) {
        title = @"VADO GIU PERPENDICOLARE";
    } else if ([randomAction isEqual:@"paura"] || [randomAction isEqual:@"bestemmie_dipre_paura"]) {
        title = @"DIPRE PAURA";
    } else if ([randomAction isEqual:@"trombare"]) {
        title = @"MA COME FACCIO A NON TROMBARE CO STO FISICO";
    } else if ([randomAction isEqual:@"belino"]) {
        title = @"ME NE SBATTO IL BELINO";
    }  else if ([randomAction isEqual:@"catafratti"]) {
        title = @"CATAFRATTI";
    } else if ([randomAction isEqual:@"mossa_se_voglio"] || [randomAction isEqual:@"bestemmie_mossa_se_voglio"]) {
        title = @"MOSSA SE VOGLIO";
    } else if ([randomAction isEqual:@"nossa"]) {
        title = @"NOSSA NOSSA IL PUMA FA LA MOSSA";
    } else if ([randomAction isEqual:@"sabatu_na_trombata"]) {
        title = @"SABATU NA TROMBATA";
    } else if ([randomAction isEqual:@"baffo_se_voglio"]) {
        title = @"BAFFO SE VOGLIO";
    } else if ([randomAction isEqual:@"perpendicolare"]) {
        title = @"VADO GIÙ PERPENDICOLARE";
    } else if ([randomAction isEqual:@"se_voglio"] || [randomAction isEqual:@"bestemmie_se_voglio"]) {
        title = @"SE VOGLIO";
    } else if ([randomAction isEqual:@"lucapuma"]) {
        title = @"LUCAPUMA";
    } else if ([randomAction isEqual:@"non_son_buono"]) {
        title = @"MA QUALE MOSSA CHE NON SON BUONO A FARLA";
    } 
    return title;
}

static void alert(NSString *title, NSString *message){
    //display alert
    UIAlertController* alert = [UIAlertController
                                    alertControllerWithTitle: [NSString stringWithFormat: @"🐯\n%@", title]
                                    message: message
                                    preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* cancel = [UIAlertAction
                                actionWithTitle:@"💥💥💥"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action) {
                                    [audioPlayer stop];                         
                                }];
    [alert addAction:cancel]; 

    //https://www.reddit.com/r/jailbreakdevelopers/comments/5xv9yo/replacing_deprecated_uiactionsheet_with/
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil]; 
}

static void playAudio(NSString *audioFile){
    NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat: @"/var/mobile/Library/Puma/%@.aiff", audioFile]];
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    audioPlayer.numberOfLoops = 0;
    audioPlayer.volume = 1.0;
    [audioPlayer play];
}

void sentNotification() {

    NSString  *randomAction  = generateRandomAction();
    NSString  *title         = generateTitle(randomAction);
    NSString  *randomMessage = generateRandomMessage();

    [[objc_getClass("JBBulletinManager") sharedInstance] 
        showBulletinWithTitle: title
        message: randomMessage
        overrideBundleImage: [UIImage imageWithContentsOfFile:  @"/var/mobile/Library/Puma/icon.png" ]
        soundPath: @"/var/mobile/Library/Puma/passi.aiff"
    ];

}

static void startPuma() {

    NSString  *randomAction  = generateRandomAction();
    NSString  *title         = generateTitle(randomAction);
    NSString  *randomMessage = generateRandomMessage();
    
    //vibrate
    [FeedbackCall vibrateDevice];

    //play audio
    playAudio(randomAction);

    //display alert
    alert(title, randomMessage);

}

%ctor
{
	if ([NSBundle.mainBundle.bundleIdentifier isEqual:@"com.apple.springboard"]) { //check if its springboard
    	int regToken; // The registration token
        //Request notification delivery to a dispatch queue
		notify_register_dispatch(PACKAGE_NAME, &regToken, dispatch_get_main_queue(), ^(int token) {  
			
            startPuma();

		});
	}
}
 