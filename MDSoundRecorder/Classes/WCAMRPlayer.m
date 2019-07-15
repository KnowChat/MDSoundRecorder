//
//  WCAMRPlayer.m
//  GrabChat
//
//  Created by KnowChat02 on 2019/3/5.
//  Copyright © 2019 KnowChat. All rights reserved.
//

#import "WCAMRPlayer.h"
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>
@implementation WCAMRPlayer{
    AVAudioPlayer* player;
}
- (instancetype)initWithURL:(NSString *)target
{
    self = [super init];
    if (self) {
        NSURL* url = [[NSURL URLWithString: NSTemporaryDirectory()] URLByAppendingPathComponent:@"play.wav"];
        [VoiceConverter amrToWav:target wavSavePath:url.path];
        player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
        player.delegate = self;
        [AVAudioSession.sharedInstance setCategory:AVAudioSessionCategoryPlayback error:nil];
        [AVAudioSession.sharedInstance setActive:YES error:nil];
    }
    return self;
}
- (AVAudioPlayer *)player {
    return player;
}
-(void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error{
    if (self.delegate && [self.delegate respondsToSelector:@selector(audioPlayerDecodeErrorDidOccur:error:)]) {
        [self.delegate audioPlayerDecodeErrorDidOccur:player error:error];
    }
    [[UIDevice currentDevice] setProximityMonitoringEnabled:false];
    [NSNotificationCenter.defaultCenter removeObserver:self];
    [AVAudioSession.sharedInstance setCategory:AVAudioSessionCategoryPlayback error:nil];
    [AVAudioSession.sharedInstance setActive:YES error:nil];
}
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    if (self.delegate && [self.delegate respondsToSelector:@selector(audioPlayerDidFinishPlaying:successfully:)]) {
        [self.delegate audioPlayerDidFinishPlaying:player successfully:flag];
    }
    [[UIDevice currentDevice] setProximityMonitoringEnabled:false];
    [NSNotificationCenter.defaultCenter removeObserver:self];
    [AVAudioSession.sharedInstance setCategory:AVAudioSessionCategoryPlayback error:nil];
    [AVAudioSession.sharedInstance setActive:YES error:nil];
}
- (void)play {
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(onHandlePhone:) name:UIDeviceProximityStateDidChangeNotification object:nil];
    [[UIDevice currentDevice] setProximityMonitoringEnabled:true];
    [player play];
}
- (void)stop {
    [[UIDevice currentDevice] setProximityMonitoringEnabled:false];
    [NSNotificationCenter.defaultCenter removeObserver:self];
    [player stop];
    [AVAudioSession.sharedInstance setCategory:AVAudioSessionCategoryPlayback error:nil];
    [AVAudioSession.sharedInstance setActive:YES error:nil];
}
- (BOOL)isPlaying{
    return player.isPlaying;
}
- (void)setPlayMode{
    if (UIDevice.currentDevice.proximityState) {
        [AVAudioSession.sharedInstance setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
        [AVAudioSession.sharedInstance setActive:YES error:nil];
    }else{
        [AVAudioSession.sharedInstance setCategory:AVAudioSessionCategoryPlayback error:nil];
        [AVAudioSession.sharedInstance setActive:YES error:nil];
    }
}
- (void)onHandlePhone:(NSNotification*)noti{
    [self setPlayMode];
}
@end
