@interface FeedbackCall : NSObject
+(void)vibrateDevice;
@end

@interface FBSystemService : NSObject
+(id)sharedInstance;
-(void)exitAndRelaunch:(BOOL)arg1;
@end
