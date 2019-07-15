//
//  GCPProtocol.h
//  Grape
//
//  Created by KnowChat02 on 2019/1/30.
//  Copyright © 2019 KnowChat02. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^FrameMonitor)(int16_t * _Nonnull, int);
NS_ASSUME_NONNULL_BEGIN


@protocol SoundSave<NSObject>

-(void) startSave:(NSData*)data;
-(void) appendData:(NSData*)data;
- (NSURL*)stopSave:(int)sampleRate bitRate:(int)br;
@end

@protocol GPCSoundCatch <NSObject>
@property(nonatomic,strong)id<SoundSave> save;
@property(nonatomic,readonly)BOOL isStop;
-(void)startRecordWithHandle:(FrameMonitor _Nullable)handle soundFile:(void(^)(NSURL*))url;
-(void)stop:(void(^)(void))complete;
-(void)cancel;
@end
@protocol GPCNoiseSuppression <NSObject>
-(NSData*)process:(NSData*)data;
@end

NS_ASSUME_NONNULL_END
