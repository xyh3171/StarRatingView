# StarRatingView
# StarRatingView

# 效果GIF图
![github](https://github.com/xyh3171/StarRatingView/blob/master/StarRatingViewFeature.gif)

# 使用方法
1. 将StarRatingView.h/.m和StarRating.h/.m拖入项目，然后在控制器中导入StarRatingView.h,遵守<StarRatingViewDelegate>协议即可。
2. 在控制器中，输入以下代码，第一段为默认设置的方法，第二段代码可自由定制。

``` 
StarRatingView *starRatingView1 = [[StarRatingView alloc] loadStarRatingViewDefault];
    [self.view addSubview:starRatingView1];
    starRatingView1.delegate = self;
    
StarRatingView *starRatingViwe2 = [[StarRatingView alloc] initWithFrame:CGRectMake(20, 200, 370, 60) andLoadStarRatingNum:4 andStarRatingW:60 andStarBackgroundColor:[UIColor grayColor] andLightStarColor:[UIColor orangeColor]];
    [self.view addSubview:starRatingViwe2];
    starRatingViwe2.delegate = self;
```
   
# 1. 星星评分控件功能需求分析
a. 比如点击第三颗星星，前三颗星星由灰变橙色，往回点击第一颗星星时，第二颗星星及后面的星星变灰
b. 往第三颗星星方向拖拽，可以实现第一颗星星半个星精度的逐渐由灰色填充为橙色背景的星星，往回向第一颗星星拖拽时，橙色星星以半颗星精度逐渐由橙色变灰。
c. 每颗星星的大小和之间的间距可自由定制

# 2. 整体控件设计思路
### a. 第一种 
			i. 启用一组数据
				1) 此组数据用于变色、控制底色和改变精度
			ii. 启用图片操作
			iii. 启用button置顶为上层操作
			iv. 采用一组数据控制不了；使用图片操作，每次变更大小时都需要美工配合；用button点击控制，实现逻辑非常复杂，层层嵌套，且无法实现拖拽的半颗星精度。
### b. 第二种
			i. 启用两组数据
				1) 第一组用于展示全部灰色星星背景，添加点击事件用于改变星星颜色
				2) 第二组用于展示半颗星精度的橙色星星，添加拖拽事件用于改变星星精度
			ii. 启用绘制方法
			iii. 启用tap与pan结合距离进行控制
			iv. 采用两组分别控制，过于麻烦与复杂，第二种废弃，改进为第三种
### c. 第三种
			i. 启用两组数据
				1) 第一组用于展示全部灰色星星背景，不添加任何事件，作为背景view.
				2) 第二组用于显示拖拽后半颗星精度的橙色星星和点击后改变星星颜色
			ii. 启用绘制方法
				1) Bezier与CAShaperLayer结合使用
					a) 一颗一颗星星的绘制
						i) 以此实现半颗星的精度和颜色控制
							One. 在此基类开放出精度和颜色的属性控制方法与星星大小设置的方法
						ii) 由此想到建立StarRating基类，然后将独立的一颗颗星星按顺序放置在StarRatingView上，最后在控制器视图中控制StarRatingView的frame即可。
							One. 再去想通过设置StarRatingView的w、h，结合设置StarRating的w、h来控制每颗星星的大小与每颗星星之间的距离。
							Two. 再去想通过在此StarRatingView上开放出一个初始化方法和一个常用的默认方法
			iii. 启用tap与pan结合距离进行控制
				1) tap点击事件
					a) 每次点击哪颗星星的距离除以单颗星星的宽度得到一个比值，用for循环将小于此比值的星星抽出第二组数组，改变其颜色为点亮的颜色
						i) 由于要往回点击，点亮颜色要变回背景色，由此想到，每次点击星星之前，先将第二组数据抽出，设置所有星星为透明颜色，再让其设置点击后的点亮颜色显示，以此实现往回点击的颜色变化。
				2) pan拖拽事件
					a) 每次拖拽哪颗星星的距离除以单颗星星的宽度的到一个比值，用for循环将小于此比值的星星抽出第二组数组，改变其颜色为点亮的颜色，并改变半颗星的精度
						i) 由于要往回拖拽，点亮颜色要变回背景色，之前点击点亮的颜色要变回背景色，由此想到，每次拖拽星星之前，先将第二组数据抽出，设置所有星星为未绘制完成，再让其设置拖拽后的点亮颜色和完成度去显示其精度，以此实现往回拖拽的颜色变化
							One. 完成度的半颗星精度，在拖拽时，用while循环去判断最后一颗星的距离区间在x.0到x.5之间实现半颗星精度，x.5后实现最后一个星的全颗星显示。
								First. 因为while循环的自由定制度更高，在while循环中，每次加0.5，对于循环数则强制类型转换为整型
									1. 当循环数取余到x.0与x.5区间范围，则通过循环数强制类型转换后的整数取出第二组数据，将其设置为半颗星
									2. 当循环数取余到x.5与x.0区间范围，则通过循环数强制类型转换后的整数取出第二组数据，将其设置为全颗星
									
									
			iv. 最终采用第三种方法

