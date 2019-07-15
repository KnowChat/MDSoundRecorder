//
//  VoiceRecode.h
//  GrabChat
//
//  Created by Francis on 2018/5/10.
//  Copyright © 2018年 KnowChat. All rights reserved.
//

#import <Foundation/Foundation.h>

//#import "VoiceTranslate.h"
#import "GCProtocol.h"
@class GCVoiceRecode;

@interface GCVoiceRecode : NSObject<GPCSoundCatch>

@property(nonatomic,readonly)int bufferSize;
@property(nonatomic,readonly) Float64 sampleRate;

@property (nonatomic, assign) int bitRate;
- (instancetype)initWithSampleRate:(Float64)rate bitRate:(int)bRat channel:(int)n;
@end

@interface GCVoiceSave : NSObject<SoundSave>

@end
//@interface GCAMRSave : GCVoiceSave
//
//@end
