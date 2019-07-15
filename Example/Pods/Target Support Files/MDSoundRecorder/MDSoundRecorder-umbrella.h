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

#import "GCProtocol.h"
#import "GCVoiceRecode.h"
#import "lame.h"
#import "LameTransformTool.h"
#import "amrFileCodec.h"
#import "wav.h"
#import "interf_dec.h"
#import "interf_enc.h"
#import "dec_if.h"
#import "if_rom.h"
#import "VoiceConverter.h"

FOUNDATION_EXPORT double MDSoundRecorderVersionNumber;
FOUNDATION_EXPORT const unsigned char MDSoundRecorderVersionString[];

