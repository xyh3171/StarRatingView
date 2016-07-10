//
//  StarRatingView.m
//  StarRatingView
//
//  Created by xuyonghua on 7/8/16.
//  Copyright © 2016 FN. All rights reserved.
//

#import "StarRatingView.h"

@interface StarRatingView ()

@property (nonatomic, strong) NSMutableArray <StarRating *> *starArray; // 第一组灰色背景
@property (nonatomic, strong) NSMutableArray <StarRating *> *starArrayHalf;// 第二组变色与显色
@property (nonatomic, assign) NSUInteger num;// 星星个数
@property (nonatomic, assign) CGFloat scale;// 点击或拖拽的数字除以星星宽度的比例
@property (nonatomic, assign) CGFloat StarRatingW;// 星星的宽度
@property (nonatomic, assign) CGFloat starInterW;// 每颗星星的间隔
@property (nonatomic, strong) UIColor *lightStarColor;// 点亮星星的颜色

@end


@implementation StarRatingView

- (instancetype)loadStarRatingViewDefault {
    id result = [self initWithFrame:CGRectMake(20, 100, 200, 25) andLoadStarRatingNum:5 andStarRatingW:25 andStarBackgroundColor:[UIColor grayColor] andLightStarColor:[UIColor orangeColor]];
    return result;
}

- (instancetype)initWithFrame:(CGRect)frame andLoadStarRatingNum:(NSUInteger)n andStarRatingW:(CGFloat)w andStarBackgroundColor:(UIColor *)starColor andLightStarColor:(UIColor *)lightStarColor {
    
    if (self = [super initWithFrame:frame]) {
        
        self.starArray = [NSMutableArray arrayWithCapacity:n];
        self.starArrayHalf = [NSMutableArray arrayWithCapacity:n];
        self.num = n;
        self.StarRatingW = w;
        CGFloat interW = (frame.size.width - (n * w)) / n;
        self.starInterW = interW;
        self.lightStarColor = lightStarColor;
        
        // 第一组灰色背景星星的设置和添加进数组
        for (int i = 0; i < n; i++) {
            StarRating *star = [[StarRating alloc] initWithFrame:CGRectMake(i * (w + interW), 0, w, w)];
            [star loadStarRatingW:w andStarRatingH:w];
            
            star.starColor = starColor;
            
            [self.starArray addObject:star];
            [self addSubview:star];
            
        }
        // 第二组变色与显现星星的设置和添加进数组
        for (int i = 0; i < n; i++) {
            StarRating *star = [[StarRating alloc] initWithFrame:CGRectMake(i * (w + interW), 0, w, w)];
            [star loadStarRatingW:w andStarRatingH:w];
            
            star.starColor = [UIColor clearColor];
            star.percent = 1;
            
            [self.starArrayHalf addObject:star];
            [self addSubview:star];
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
            [self addGestureRecognizer:tap];
            
            UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
            [self addGestureRecognizer:pan];
        }
        
    }
    return self;
}


- (void)tap:(UITapGestureRecognizer *)tap {
    CGPoint currentPoint = [tap locationInView:self];
    [self lightWholeStar:currentPoint];
}

- (void)pan:(UIPanGestureRecognizer *)pan {
    CGPoint p = [pan locationInView:self];
    [self drawHalfStar:p];
    
    // 拖拽完毕后的取数
    if (pan.state == UIGestureRecognizerStateEnded) {
        if ( p.x > ((self.starInterW + self.StarRatingW) * self.num)) {
            p.x = (self.starInterW + self.StarRatingW) * self.num;
            self.scale = p.x / (self.starInterW + self.StarRatingW);
        } else {
            self.scale = p.x / (self.starInterW + self.StarRatingW);
        }
        // x与x.5区间的取数判断
        CGFloat k = self.scale;
        int l = (k * 10);
        int m = l % 10;
        if (m >= 5) {
            k = ceil(self.scale);
        } else {
            k = floor(self.scale) + 0.5;
        }
        NSLog(@"stateEnded is %f", k);
        if (_delegate != nil && [_delegate respondsToSelector:@selector(starBtnAction:)]) {
            [_delegate starBtnAction:k];
        }
    }
}

// 两个手势同时启用的方法
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(nonnull UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

// tap点亮星星颜色的方法
- (void)lightWholeStar:(CGPoint)point {
    
    // 每次点亮前先刷新底色为透明
    if (CGRectContainsPoint(self.bounds, point)) {
        for (int i = 0; i < self.num; i++) {
            StarRating *star = self.starArrayHalf[i];
            star.percent = 1;
            star.starColor = [UIColor clearColor];
        }
        
        CGFloat maxX = point.x;
        
        if (maxX > ((self.starInterW + self.StarRatingW) * self.num)) {
            maxX = (self.starInterW + self.StarRatingW) * self.num;
            self.scale = maxX / (self.starInterW + self.StarRatingW);
        } else {
            self.scale = ceil(maxX / (self.starInterW + self.StarRatingW));
        }
        
        NSLog(@"%f",self.scale);
        
        if (_delegate != nil && [_delegate respondsToSelector:@selector(starBtnAction:)]) {
            [_delegate starBtnAction:self.scale];
        }
        
        for (int i = 0; i < self.scale; i++) {
            StarRating *star = self.starArrayHalf[i];
            star.starColor = self.lightStarColor;
        }
    } else {
        NSLog(@"click overArea");
    }
}

// 拖拽画半颗星的方法
- (void)drawHalfStar:(CGPoint)point {
    
    // 每次显示星星前先刷新星星为不存在
    for (int i = 0; i < self.num; i++) {
        StarRating *star = self.starArrayHalf[i];
        star.percent = 0;
    }
    
    CGFloat maxX = point.x;
    
    if (maxX > ((self.starInterW + self.StarRatingW) * self.num)) {
        maxX = (self.starInterW + self.StarRatingW) * self.num;
        self.scale = maxX / (self.starInterW + self.StarRatingW);
    } else {
        self.scale = maxX / (self.starInterW + self.StarRatingW);
    }
    
    NSLog(@"%f",self.scale);
    
    CGFloat i = 0;
    while (i < self.scale) {
        int j = (i * 10);
        int k = (int)i;
        // x.0半颗星
        if (j % 10 == 0) {
            StarRating *star = self.starArrayHalf[k];
            star.percent = 0.5;
            star.starColor = self.lightStarColor;
            [self addSubview:star];
            // x.5全颗星
        } else {
            StarRating *star = self.starArrayHalf[k];
            star.percent = 1;
            star.starColor = self.lightStarColor;
            [self addSubview:star];
        }
        i = i + 0.5;
    }
    
}

- (void)starBtn{
    CGFloat n = self.scale;
    if (_delegate != nil && [_delegate respondsToSelector:@selector(starBtnAction:)]) {
        [_delegate starBtnAction:n];
    }
}


@end
