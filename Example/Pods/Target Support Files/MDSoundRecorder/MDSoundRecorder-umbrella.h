#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "amrFileCodec.h"
#import "dec_if.h"
#import "GCProtocol.h"
#import "GCVoiceRecode.h"
#import "if_rom.h"
#import "interf_dec.h"
#import "interf_enc.h"
#import "lame.h"
#import "LameTransformTool.h"
#import "VoiceConverter.h"
#import "GCSoundWaveView.h"
#import "WCAMRPlayer.h"

FOUNDATION_EXPORT double MDSoundRecorderVersionNumber;
FOUNDATION_EXPORT const unsigned char MDSoundRecorderVersionString[];

