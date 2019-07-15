//
//  MDViewController.m
//  MDSoundRecorder
//
//  Created by yinhaofrancis on 07/15/2019.
//  Copyright (c) 2019 yinhaofrancis. All rights reserved.
//

#import "MDViewController.h"
#import <MDSoundRecorder-umbrella.h>
#import <AVFoundation/AVFoundation.h>
@interface MDViewController ()<AVAudioPlayerDelegate>
@property (nonatomic,nullable) GCVoiceRecode * recoder;
@property (nonatomic,nonnull) NSURL * url;
@property (nonatomic,nullable) AVAudioPlayer* player;
@property (nonatomic,nullable) WCAMRPlayer* amrPlay;
@end

@implementation MDViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.recoder = [[GCVoiceRecode alloc] initWithSampleRate:8400 bitRate:16 channel:1];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)start:(id)sender {
    self.recoder.save = [[GCVoiceSave alloc] init];
    [self.recoder startRecordWithHandle:^(int16_t * _Nonnull t, int l) {
        
    } soundFile:^(NSURL * _Nonnull url) {
        self.url = url;
    }];
}
- (IBAction)end:(id)sender {
    [self.recoder stop:^{
        self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:self.url error:nil];
        [self.player play];
        
    }];
}
- (IBAction)amrStart:(id)sender {
    self.recoder.save = [[GCAMRSave alloc] init];
    [self.recoder startRecordWithHandle:^(int16_t * _Nonnull t, int l) {
        
    } soundFile:^(NSURL * _Nonnull url) {
        self.url = url;
    }];
}
- (IBAction)amrClose:(id)sender {
    [self.recoder stop:^{
        self.amrPlay = [[WCAMRPlayer alloc] initWithURL:self.url.path];
        self.amrPlay.delegate = self;
        [self.amrPlay play];
    }];
}
@end
