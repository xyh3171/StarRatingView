//
//  StarRatingView.h
//  StarRatingView
//
//  Created by xuyonghua on 7/8/16.
//  Copyright © 2016 FN. All rights reserved.
//

#import "StarRating.h"

@protocol StarRatingViewDelegate <NSObject>

@required

- (void)starBtnAction:(CGFloat)index;

@end


@interface StarRatingView : StarRating

@property (nonatomic, strong)id<StarRatingViewDelegate> delegate;

// 默认的效果预览方法
- (instancetype)loadStarRatingViewDefault;

// 启用的初始化方法
- (instancetype)initWithFrame:(CGRect)frame andLoadStarRatingNum:(NSUInteger)n andStarRatingW:(CGFloat)w andStarBackgroundColor:(UIColor *)starColor andLightStarColor:(UIColor *)lightStarColor;


@end
