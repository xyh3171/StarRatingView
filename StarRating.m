//
//  StarRating.m
//  StarRatingView
//
//  Created by xuyonghua on 7/8/16.
//  Copyright © 2016 FN. All rights reserved.
//

#import "StarRating.h"
@interface StarRating ()

@property (nonatomic, weak)CAShapeLayer *backgroundLayer;

@end

@implementation StarRating

- (instancetype)loadStarRatingW:(CGFloat)w andStarRatingH:(CGFloat)h {
    
    //如果要使用，确保宽度要大于长度
    self.backgroundColor = [UIColor clearColor];
    
    //底层
    UIBezierPath *backgroundPath = [UIBezierPath bezierPath];
    [backgroundPath moveToPoint:CGPointMake(0, h * 0.5)];
    [backgroundPath addLineToPoint:CGPointMake(w, h * 0.5)];
    
    CAShapeLayer *backgroundLayer = [CAShapeLayer layer];
    backgroundLayer.path = backgroundPath.CGPath;
    backgroundLayer.lineWidth = h;
    [self.layer addSublayer:backgroundLayer];
    self.backgroundLayer = backgroundLayer;
    
    //该组件的核心部分 五角星画图的算法
    UIBezierPath *star = [[UIBezierPath alloc] init];
    for (int i = 1; i < 2; i ++) {
        if (i % 2 != 0) {
            CGFloat startX = w / (w / h) * i;
            CGPoint center = CGPointMake(startX * 0.5, h * 0.5);
            CGFloat radius = h * 0.5;
            CGFloat angle = 4 * M_PI / 5;
            
            //画五角星,这里不用改动
            [star moveToPoint:CGPointMake(startX * 0.5, 0)];
            for (int i = 0; i < 5; i ++) {
                CGFloat x = center.x - sinf((i + 1) * angle) * radius;
                CGFloat y = center.y - cosf((i + 1) * angle) * radius;
                [star addLineToPoint:CGPointMake(x, y)];
            }
            [star addLineToPoint:CGPointMake(startX * 0.5, 0)];
        }
    }
    
    //遮罩
    CAShapeLayer *starLayer = [CAShapeLayer layer];
    starLayer.path = star.CGPath;
    self.layer.mask = starLayer;
    
    return self;
}

// 设置五角星的颜色
- (void)setStarColor:(UIColor *)starColor {
    _starColor = starColor;
    self.backgroundLayer.strokeColor = starColor.CGColor;
    self.backgroundLayer.fillColor = starColor.CGColor;
}

// 设置五角星的完成度，画半颗星和全颗星的方法
- (void)setPercent:(CGFloat)percent {
    _percent = percent;
    self.backgroundLayer.strokeEnd = percent;
}

@end