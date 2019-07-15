//
//  LameTransformTool.h
//  SZAudioTool
//
//  Created by KnowChat01 on 2019/2/21.
//  Copyright © 2019年 KeepKong. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface LameTransformTool : NSObject
+ (NSString *)audioToMP3: (NSString *)sourcePath isDeleteSourchFile:(BOOL)isDelete sampleRate:(int)rate bitRate:(int)br;
@end


