//
//  ViewController.m
//  StarRatingView
//
//  Created by xuyonghua on 7/8/16.
//  Copyright © 2016 FN. All rights reserved.
//

#import "ViewController.h"
#import "StarRatingView.h"

@interface ViewController ()<StarRatingViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    StarRatingView *starRatingView1 = [[StarRatingView alloc] loadStarRatingViewDefault];
    [self.view addSubview:starRatingView1];
    starRatingView1.delegate = self;
    
    
    StarRatingView *starRatingViwe2 = [[StarRatingView alloc] initWithFrame:CGRectMake(20, 200, 370, 60) andLoadStarRatingNum:4 andStarRatingW:60 andStarBackgroundColor:[UIColor grayColor] andLightStarColor:[UIColor orangeColor]];
    [self.view addSubview:starRatingViwe2];
    starRatingViwe2.delegate = self;
    
    StarRatingView *starRatingViwe3 = [[StarRatingView alloc] initWithFrame:CGRectMake(20, 300, 300, 40) andLoadStarRatingNum:6 andStarRatingW:40 andStarBackgroundColor:[UIColor blueColor] andLightStarColor:[UIColor redColor]];
    [self.view addSubview:starRatingViwe3];
    starRatingViwe3.delegate = self;
}

- (void)starBtnAction:(CGFloat)index {
    NSLog(@"VC click index is %f", index);
}


@end
