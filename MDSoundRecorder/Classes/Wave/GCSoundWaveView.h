//
//  GCSoundWaveView.h
//  GrabChat
//
//  Created by KnowChat02 on 2019/2/25.
//  Copyright © 2019 KnowChat. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GCSoundWaveView : UIView
@property(nonnull,nonatomic)IBInspectable UIColor* strokeColor;
@property(nonatomic,assign) IBInspectable NSInteger sizeWave;
@property(nonatomic,assign) IBInspectable CGFloat lineWidth;
-(void)catchBuffer:(int16_t*)nums c:(int16_t)c;
@end

NS_ASSUME_NONNULL_END
