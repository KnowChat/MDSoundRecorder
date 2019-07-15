//
//  WCAMRPlayer.h
//  GrabChat
//
//  Created by KnowChat02 on 2019/3/5.
//  Copyright © 2019 KnowChat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "VoiceConverter.h"
NS_ASSUME_NONNULL_BEGIN

@interface WCAMRPlayer : NSObject<AVAudioPlayerDelegate>
@property (nonatomic, readonly) AVAudioPlayer* player;
@property (nonatomic, weak) id<AVAudioPlayerDelegate>delegate;

- (instancetype)initWithURL:(NSString*)target;

- (void)play;

- (void)stop;

- (BOOL)isPlaying;

@end

NS_ASSUME_NONNULL_END
