//
//  StarRating.h
//  StarRatingView
//
//  Created by xuyonghua on 7/8/16.
//  Copyright © 2016 FN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StarRating : UIView

@property (nonatomic, strong)UIColor *starColor;
@property (nonatomic, assign)CGFloat score;

- (instancetype)loadStarRatingW:(CGFloat)w andStarRatingH:(CGFloat)h;

@end
