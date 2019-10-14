//
//  GCSoundWaveView.m
//  GrabChat
//
//  Created by KnowChat02 on 2019/2/25.
//  Copyright © 2019 KnowChat. All rights reserved.
//

#import "GCSoundWaveView.h"
#define displaySizeW 33.0
#define displaySizeH (33.0 * 0.618)
@implementation GCSoundWaveView {
    CAShapeLayer* shape;
    CGFloat* volumes;
    CGSize bound;
}
- (instancetype)init {
    shape = [[CAShapeLayer alloc] init];
    self = [super init];
    if(self){
        shape = [[CAShapeLayer alloc] init];
        [self.layer addSublayer:shape];
        self.strokeColor = UIColor.blackColor;
        self.clipsToBounds = false;
        shape.lineCap  = kCALineCapRound;
        shape.frame = CGRectMake(0, 0, displaySizeW, displaySizeH);
        self.sizeWave = 8;
        [self setContentHuggingPriority:1000 forAxis:UILayoutConstraintAxisVertical];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)coder
{
    shape = [[CAShapeLayer alloc] init];
    self = [super initWithCoder:coder];
    if (self) {
       
        [self.layer addSublayer:shape];
        self.strokeColor = UIColor.blackColor;
        self.clipsToBounds = false;
        shape.lineCap  = kCALineCapRound;
        shape.frame = CGRectMake(0, 0, displaySizeW, displaySizeH);
        self.sizeWave = 8;
        [self setContentHuggingPriority:1000 forAxis:UILayoutConstraintAxisVertical];
    }
    return self;
}
- (void)layoutSubviews{
    shape.frame = self.bounds;
    bound = self.bounds.size;
}
- (void)setSizeWave:(NSInteger)sizeWave{
    _sizeWave = sizeWave;
    if(volumes != nil){
        free(volumes);
    }
    volumes = malloc(sizeWave * sizeof(CGFloat));
}
- (void)setStrokeColor:(UIColor *)strokeColor {
    shape.strokeColor = strokeColor.CGColor;
}
- (UIColor *)strokeColor{
    return [[UIColor alloc] initWithCGColor:shape.strokeColor];
}
- (CGFloat)max:(int16_t*)nums c:(int16_t)c index:(int32_t)indx {
    CGFloat sum = [self db:nums[indx]];
//    CGFloat ratio = sum  - 130;
    if(sum < 3){
        return 0.1;
    }else{
        CGFloat a = (sum - 60) / 110;
        return a > 1 ? 1 : a;
    }
}
- (CGFloat)lineWidth{
    return shape.lineWidth;
}
- (void)setLineWidth:(CGFloat)lineWidth{
    shape.lineWidth = lineWidth;
}
- (double)db:(int16_t)v {
    double a = 20 * log(abs(v));
    
    return a;
}
-(CGPathRef)makePath{
    CGMutablePathRef path = CGPathCreateMutable();
    for (int i = 0; i < self.sizeWave; i++) {
        CGPathMoveToPoint(path, nil, [self calcXStepPoint:i], [self calcYStepPoint:i]);
        CGPathAddLineToPoint(path, nil, [self calcXStepPoint:i], [self calcYStepPoint:i] + volumes[i] * bound.height);
    }
    return path;
}
- (CGFloat)calcXStepPoint:(int)idx{
    CGFloat stepSize = (CGFloat)(bound.width) / self.sizeWave;
    return idx * stepSize + stepSize / 2;
}
- (CGFloat)calcYStepPoint:(int)idx{
    return (bound.height - volumes[idx] * bound.height) / 2;
}
- (void)catchBuffer:(int16_t*)nums c:(int16_t)c {
    [self moveVolume];
    volumes[self.sizeWave - 1] = [self max:nums c:c index:c / 2];
    CGPathRef path = [self makePath];
    shape.path = path;
    CGPathRelease(path);
}
- (void)moveVolume {
    for (int i = 1 ; i < self.sizeWave; i++) {
        volumes[i - 1] = volumes[i];
    }
}
- (void)dealloc
{
    free(volumes);
}
@end
