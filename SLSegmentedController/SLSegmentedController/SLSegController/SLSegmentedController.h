//
//  SLSegmentedController.h
//  SLSegmentedController
//
//  Created by shuanglong on 16/12/15.
//  Copyright © 2016年 shuanglong. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma -mark =======================SLSegmentedItem======================

@interface SLSegmentedItem : NSObject

@property(nonatomic,strong)NSString * title;
@property(nonatomic,strong)UIViewController * viewController;

@end

#pragma -mark =======================SLSegmentedMenuView======================
@class SLSegmentedControllerView;
@interface SLSegmentedMenuView : UIScrollView

@property(nonatomic,strong)NSArray <SLSegmentedItem*> * items;
@property(nonatomic,assign)NSInteger height;
@property(nonatomic,strong)UIColor * normalColor;
@property(nonatomic,strong)UIColor * hightlightedColor;
@property(nonatomic,strong)SLSegmentedControllerView * viewControllerView;

-(void)changeTextColorAtIndex:(NSInteger)index rate:(CGFloat)rate;

-(void)finishAtIndex:(NSInteger)index;

@end

#pragma -mark =======================SLSegmentedControllerView======================
@interface SLSegmentedControllerView : UIScrollView

@property(nonatomic,strong)NSArray <SLSegmentedItem*> * items;
@property(nonatomic,strong)SLSegmentedMenuView * menuView;

-(void)scrollToViewAtIndex:(NSInteger)index;



@end


#pragma -mark =======================SLSegmentedController======================

@interface SLSegmentedController : UIView


//@property(nonatomic,strong)NSArray <UIViewController*> * viewControllers;
//@property(nonatomic,assign)NSInteger  segHeight;
@property(nonatomic,strong)NSArray <SLSegmentedItem*> * items;

-(instancetype)initWithItems:(NSArray <SLSegmentedItem*> * )items;


@end
