//
//  SLSegmentedController.h
//  SLSegmentedController
//
//  Created by shuanglong on 16/12/15.
//  Copyright © 2016年 shuanglong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SLSegmentedItem;
@class SLSegmentedMenuView;
@class SLSegmentedControllerView;


/**
 SLSegmentedController 是一个随着滑动,文字大小和颜色和都会随之改变的分段控制视图
 */
@interface SLSegmentedController : UIView

/**
 items 一个SegmentedItem类型的数组
 */
@property(nonatomic,strong)NSArray <SLSegmentedItem*> * items;


/**
 普通状态的文字颜色
 */
@property(nonatomic,strong)UIColor * normalColor;


/**
 选择状态下文字颜色
 */
@property(nonatomic,strong)UIColor * hightlightedColor;


/**
 menuView的高度
 */
@property(nonatomic,assign)CGFloat menuHeight;


/**
 文字大小
 */
@property(nonatomic,assign)CGFloat fontSize;


/**
 初始化方法
 
 @param items SLSegmentedItem类型的数组
 @return SLSegmentedController
 */
-(instancetype)initWithItems:(NSArray <SLSegmentedItem*> * )items;


@end


/**
 SLSegmentedItem
 */
@interface SLSegmentedItem : NSObject

@property(nonatomic,strong)NSString * title;
@property(nonatomic,strong)UIViewController * viewController;

@end


/**
 SLSegmentedMenuView 是 SLSegmentedController 顶部的按钮视图类
 */
@class SLSegmentedControllerView;
@interface SLSegmentedMenuView : UIScrollView

@property(nonatomic,strong)NSArray <SLSegmentedItem*> * items;
@property(nonatomic,assign)NSInteger height;
@property(nonatomic,strong)UIColor * normalColor;
@property(nonatomic,strong)UIColor * hightlightedColor;
@property(nonatomic,strong)SLSegmentedControllerView * viewControllerView;
@property(nonatomic,assign)CGFloat fontSize;


/**
 改变颜色和视图

 @param index 当前页
 @param rate 移动的比率
 */
-(void)changeTextColorAtIndex:(NSInteger)index rate:(CGFloat)rate;



/**
 scrollView滑动结束,MenuView显示指定按钮

 @param index 移动到的页码
 */
-(void)finishAtIndex:(NSInteger)index;

@end


/**
 SLSegmentedControllerView 是 SLSegmentedController中呈现viewController的View的视图类
 */
@interface SLSegmentedControllerView : UIScrollView

@property(nonatomic,strong)NSArray <SLSegmentedItem*> * items;
@property(nonatomic,strong)SLSegmentedMenuView * menuView;


/**
 滚动视图到指定的位置

 @param index 目标页码
 */
-(void)scrollToViewAtIndex:(NSInteger)index;

@end



