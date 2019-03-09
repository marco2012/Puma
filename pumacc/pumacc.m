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

- (void)setSelected:(BOOL)selected {

    _selected = selected;
    [super refreshState];

    NSMutableDictionary *pumaPrefsDict = [NSMutableDictionary dictionaryWithDictionary:[NSDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/me.vikings.pumaprefs.plist"]];

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
