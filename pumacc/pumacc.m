#import "pumacc.h"

@implementation pumacc

//Return the icon of your module here
- (UIImage *)iconGlyph {
	return [UIImage imageNamed:@"AppIcon" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
}

//Return the color selection color of your module here
- (UIColor *)selectedColor {
	// return [UIColor blueColor];
	return [UIColor colorWithRed:(0.0/255.0) green:(108.0/255.0) blue:(255.0/255.0) alpha:1.0];

}

- (BOOL)isSelected {
  return _selected;
}


// static void alert(NSString* message) {
//     UIAlertController* alert = [UIAlertController
//                                     alertControllerWithTitle: message
//                                     message:@""
//                                     preferredStyle:UIAlertControllerStyleAlert];
//     UIAlertAction* cancel = [UIAlertAction
//                                 actionWithTitle:@"OK"
//                                 style:UIAlertActionStyleDefault
//                                 handler:^(UIAlertAction * action) {
//                                 }];
//     [alert addAction:cancel]; 
//    //https://www.reddit.com/r/jailbreakdevelopers/comments/5xv9yo/replacing_deprecated_uiactionsheet_with/
//     [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil]; 
// }


- (void)setSelected:(BOOL)selected {

    NSMutableDictionary *pumaPrefsDict = [NSMutableDictionary dictionaryWithDictionary:[NSDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/me.vikings.pumaprefs.plist"]];

    // BOOL enabled = [[pumaPrefsDict objectForKey:@"enabled"] boolValue];
    // alert([NSString stringWithFormat: @"selected: %@ \nenabled: %@", selected ? @"YES" : @"NO" , enabled ? @"YES" : @"NO"]);
    
    _selected = selected;
    // _selected = !enabled;
    [super refreshState];

    if(_selected){
        //Your module got selected, do something
        [pumaPrefsDict setValue:[NSNumber numberWithBool:TRUE] forKey:@"enabled"];
    } else {
        //Your module got unselected, do something
        [pumaPrefsDict setValue:[NSNumber numberWithBool:FALSE] forKey:@"enabled"];
    }
        [pumaPrefsDict writeToFile:@"/var/mobile/Library/Preferences/me.vikings.pumaprefs.plist" atomically:TRUE];
        CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), 
                                            CFSTR("me.vikings.pumaprefs/preferences.changed"), NULL, NULL, TRUE);

}

@end
