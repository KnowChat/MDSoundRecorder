//
//  VoiceRecode.m
//  GrabChat
//
//  Created by Francis on 2018/5/10.
//  Copyright © 2018年 KnowChat. All rights reserved.
//
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import "GCVoiceRecode.h"
#import "LameTransformTool.h"
#import "VoiceConverter.h"
#define QUEUE_BUFFER_SIZE 20
@class GPCVoiceSave;


@interface GCVoiceRecode(){
    AudioStreamBasicDescription format;
    AudioQueueRef queue;
    double bufferDuringSeconds;
    AudioQueueBufferRef audioBuffers[QUEUE_BUFFER_SIZE];
    NSMutableData* resultData;
    dispatch_queue_t savequeue;
    int channel;
}
@property(nonatomic,copy)NSString* lastCategory;
@property (nonatomic , strong)NSMutableData *audioMuData;
@property(nonatomic,copy) FrameMonitor handle;
@property(nonatomic,copy) void (^result)(NSURL * _Nonnull);
@end


@implementation GCVoiceRecode
@synthesize isStop;
- (instancetype)init{
    self = [self initWithSampleRate:48000 bitRate:128 channel:2];
    return self;
}
- (instancetype)initWithSampleRate:(Float64)rate bitRate:(int)bRat channel:(int)n{
    self = [super init];
    if (self) {
        _sampleRate = rate;
        [self resetFormat];
        savequeue = dispatch_queue_create(NULL, NULL);
        self.save = [[GCVoiceSave alloc] init];
        isStop = true;
        channel = n;
        _bitRate = bRat;
    }
    return self;
}
-(void)resetFormat{
    memset(&format, 0, sizeof(format));
    format.mSampleRate = self.sampleRate;
    format.mChannelsPerFrame = channel;
    format.mFormatID = kAudioFormatLinearPCM;
    
    format.mFormatFlags = kLinearPCMFormatFlagIsSignedInteger | kLinearPCMFormatFlagIsPacked;
    format.mBitsPerChannel = 16;
    format.mBytesPerPacket = format.mBytesPerFrame = (format.mBitsPerChannel / 8) * format.mChannelsPerFrame;
    format.mFramesPerPacket = 1;
    bufferDuringSeconds = 0.1;
    int bufferByteSize = (int)floor(bufferDuringSeconds * format.mSampleRate) * format.mBytesPerFrame;
    _bufferSize = bufferByteSize;
    self->resultData = [[NSMutableData alloc] init];
}
- (NSMutableData *)audioMuData
{
    if (!_audioMuData)
    {
        _audioMuData = [NSMutableData data];
    }
    return _audioMuData;
}
void handleAudioData(void * __nullable inUserData,
                     AudioQueueRef inAQ,
                     AudioQueueBufferRef inBuffer,
                     const AudioTimeStamp * inStartTime,
                     UInt32 inNumberPacketDescriptions,
                     const AudioStreamPacketDescription * __nullable inPacketDescs){
    GCVoiceRecode* v = (__bridge GCVoiceRecode*)inUserData;
    if(inBuffer->mAudioDataByteSize  > 0){
        void* pointer = malloc(v.bufferSize);
        memcpy(pointer, inBuffer->mAudioData, inBuffer->mAudioDataByteSize);
        
        NSData* da = [[NSData alloc] initWithBytesNoCopy:pointer length:inBuffer->mAudioDataByteSize];
        if(v.handle != nil){
            v.handle((int16_t*)da.bytes, (int)ceil(da.length / 2));
        }
        [v->resultData appendData:da];
        AudioQueueEnqueueBuffer(inAQ, inBuffer, 0, NULL);
        if(v.isStop && v->resultData.length > 0){
            [v.save appendData:v->resultData];
            v->resultData = [NSMutableData new];
        }
    }else{
        NSLog(@"noData");
    }
}
-(BOOL)enableRecode{
    NSError* e = nil;
    self.lastCategory = [[AVAudioSession sharedInstance] category];
    if (![[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryMultiRoute error:&e]){
        return false;
    }
    if(![[AVAudioSession sharedInstance] setActive:true error:&e]){
        return false;
    }
    return true;
}
-(void)disableRecode{
    NSError* e = nil;
//    [[AVAudioSession sharedInstance] setCategory:self.lastCategory error:&e];
//    [[AVAudioSession sharedInstance] setActive:false error:&e];
}

-(void)startRecode
{
//    if (queue != nil){
//        [self endRecode];
//    }
    [self enableRecode];
    [self resetFormat];
    AudioQueueNewInput(&format, handleAudioData, (__bridge void*)self, nil, nil, 0, &queue);
    for (int i = 0; i < QUEUE_BUFFER_SIZE; i++) {
        AudioQueueAllocateBuffer(queue, self.bufferSize, &audioBuffers[i]);
        AudioQueueEnqueueBuffer(queue, audioBuffers[i], 0, nil);
    }
    //开始录音
    NSLog(@"%@",@"start record sounds");
    [self.save startSave:[self voiceHeader]];
    AudioQueueStart(queue, nil);
    self->isStop = false;
}
- (void)endRecode{
    
    AudioQueueStop(queue, true);
    NSData* process = resultData;
    [self.save appendData:process];
    resultData = [NSMutableData new];
    
    NSLog(@"%@",@"stop record sounds");
    for (int i = 0; i < QUEUE_BUFFER_SIZE; i++) {
        AudioQueueFreeBuffer(queue, audioBuffers[i]);
    }
    AudioQueueDispose(queue, true);
    
    
    [self disableRecode];
}

- (NSData *)voiceHeader {
    char buffer[44] = {
        'R','I','F','F',// chunkid
        0,0,0,0,        // chunkSize
        'W','A','V','E', //type
        'f','m','t',0x20,
        0x10,0,0,0,
        1,0,
        1,0,                ///channel
        0x80,0x3e,0,0,
        0,0x7d,0,0,
        2,0,
        16,0,
        'd','a','t','a',
        0,0,0,0
    };
    *((int32_t*)(buffer + 16)) = self->format.mBitsPerChannel;
    *((int32_t*)(buffer + 22)) = self->format.mChannelsPerFrame;
    *((int32_t*)(buffer + 24)) = (uint32_t)self->format.mSampleRate;
    *((int32_t*)(buffer + 28)) = (uint32_t)(self.bufferSize / self->bufferDuringSeconds);
    return [[NSData alloc] initWithBytes:buffer length:44];
}
-(void)startRecordWithHandle:(FrameMonitor)handle soundFile:(void (^)(NSURL * _Nonnull))url{
    void(^doCatch)(void) = ^{
        self.handle = handle;
        self.result = url;
        [self startRecode];
    };
    if (AVAudioSession.sharedInstance.recordPermission == AVAudioSessionRecordPermissionGranted){
        dispatch_async(dispatch_get_global_queue(0, 0), doCatch);
    }else{
        [AVAudioSession.sharedInstance requestRecordPermission:^(BOOL granted) {
            if(granted){
                dispatch_async(dispatch_get_global_queue(0, 0), doCatch);
            }
        }];
    }
}

void convertToLittleEndian(unsigned int *data, int len)
{
    for (int index = 0; index < len; index ++) {
        
        *data = ((*data & 0xff000000) >> 24)
        | ((*data & 0x00ff0000) >>  8)
        | ((*data & 0x0000ff00) <<  8)
        | ((*data & 0x000000ff) << 24);
        
        data ++;
    }
}

-(void)stop:(void(^)(void))complete{
    if (AVAudioSession.sharedInstance.recordPermission == AVAudioSessionRecordPermissionGranted){
        [self endRecode];
        dispatch_async(savequeue, ^{
            NSURL* u = [self.save stopSave:(int)self.sampleRate bitRate:self.bitRate];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.result(u);
                self->isStop = true;
                if(complete){
                    complete();
                }
            });
        });
    }
}
- (void)cancel{
    [self endRecode];
}

@synthesize save;

@end

@interface GCVoiceSave ()
@property(nonatomic,copy) NSURL* path;
@property(nonatomic,strong)NSFileHandle* file;
@property(nonatomic,assign)uint32_t len;
@end
@implementation GCVoiceSave

@synthesize len = len;


- (void)appendData:(NSData *)data {
    [self.file writeData:data];
    len += data.length;
}

- (void)startSave:(NSData *)data {
    NSURL* p = [NSFileManager.defaultManager URLForDirectory:NSCachesDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:true error:nil];

    p = [p URLByAppendingPathComponent:[[[NSUUID alloc] init].UUIDString stringByAppendingFormat:@"_%d",arc4random()]];
    self.path = p;
    [NSFileManager.defaultManager removeItemAtPath:p.path error:nil];
    [NSFileManager.defaultManager createFileAtPath:p.path contents:data attributes:nil];
    self.file = [NSFileHandle fileHandleForUpdatingAtPath:p.path];
    [self.file seekToEndOfFile];
}

- (NSURL*)stopSave:(int)sampleRate bitRate:(int) br{
    [self.file closeFile];
    self.file = [NSFileHandle fileHandleForWritingAtPath:self.path.path];
    [self.file seekToFileOffset:4];
    uint32_t dl = len ;
    
    uint32_t sum = len + 40;
//    convertToLittleEndian(&dl, sizeof(uint32_t));
//    convertToLittleEndian(&sum, sizeof(uint32_t));
    NSData* data = [[NSData alloc] initWithBytes:&sum length:4];
    [self.file writeData:data];
    data = [[NSData alloc] initWithBytes:&dl length:4];
    [self.file seekToFileOffset:40];
    [self.file writeData:data];
    [self.file closeFile];
//    self.path = [NSURL URLWithString:[LameTransformTool audioToMP3:self.path.path isDeleteSourchFile:true sampleRate:sampleRate bitRate:br]];
    return self.path;
}

@end

@implementation GCAMRSave
-(NSURL*)stopSave:(int)sampleRate bitRate:(int)br{
    [self.file closeFile];
    self.file = [NSFileHandle fileHandleForWritingAtPath:self.path.path];
    [self.file seekToFileOffset:4];
    uint32_t dl = self.len;
    uint32_t sum = self.len + 40;
    NSData* data = [[NSData alloc] initWithBytes:&sum length:4];
    data = [[NSData alloc] initWithBytes:&dl length:4];
    [self.file seekToFileOffset:40];
    [self.file writeData:data];
    [self.file closeFile];
    NSString* target = [self.path.path stringByAppendingString:@".amr"];
    [VoiceConverter wavToAmr:self.path.path amrSavePath:target bitRate:br];
    self.path = [NSURL URLWithString: target];
    return self.path;
}
@end
