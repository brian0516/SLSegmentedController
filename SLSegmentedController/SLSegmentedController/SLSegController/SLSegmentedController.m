//
//  SLSegmentedController.m
//  SLSegmentedController
//
//  Created by shuanglong on 16/12/15.
//  Copyright © 2016年 shuanglong. All rights reserved.
//

#import "SLSegmentedController.h"

static  NSInteger const menuViewHeightDefault = 44;
static  CGFloat const deltaScale = 0.15;

//=============================================================================
#pragma -mark =======================SLSegmentedItem======================
@interface SLSegmentedItem ()

@end

@implementation SLSegmentedItem

-(instancetype)initWithTitle:(NSString*)title viewController:(UIViewController*)viewController{
    
    if (self = [super init]) {
        _title = title;
        _viewController = viewController;
    }
    return self;
    
}

@end





//=============================================================================
#pragma -mark =======================SLSegmentedMenuView======================

@interface SLSegmentedMenuView ()

@property(nonatomic,strong)NSMutableArray * buttonArr;

@property(nonatomic,assign)BOOL hasSetBtnFrame;
@property(nonatomic,strong)UIButton * lastSelectedBtn;//以前点击的按钮

@end

@implementation SLSegmentedMenuView

#pragma -mark  ----------初始化------------
-(instancetype)init{
    if (self = [super init]) {
        [self _configDefault];
    }
    return self;
}

#pragma -mark ------------------重写父类方法-------------------------

-(void)layoutSubviews{
    [super layoutSubviews];
    
    if (!self.hasSetBtnFrame) {
        NSInteger x = 20;
    for (NSInteger i = 0; i<self.items.count; i++) {
        SLSegmentedItem * item = self.items[i];
        UIButton * btn = self.buttonArr[i];
        CGSize size = [item.title sizeWithAttributes:@{NSFontAttributeName:btn.titleLabel.font}];
        
        btn.frame = CGRectMake(x,CGRectGetMidY(self.frame)-size.height/2,size.width+20,size.height);
        
        x+=btn.frame.size.width;
        x+=20;
        
    }
    self.contentSize = CGSizeMake(x, 0);
        self.hasSetBtnFrame = YES;
        UIButton * btn = self.buttonArr[0];
        btn.transform = CGAffineTransformMakeScale(1+deltaScale, 1+deltaScale);
    }
}

#pragma -mark  ----------公有方法------------
-(void)changeTextColorAtIndex:(NSInteger)index rate:(CGFloat)rate{
    
    if (index>=self.buttonArr.count-1) {
        return;
    }
    [self _changeNextButtonAtIndex:index rate:rate];
    [self _changeCurrentButtonAtIndex:index rate:rate];
}

-(void)finishAtIndex:(NSInteger)index{
    self.lastSelectedBtn = self.buttonArr[index];
    [self setSelectedButtonToCenter:self.lastSelectedBtn];
    
}

#pragma -mark  ----------私有方法------------

-(void)_configDefault{
    self.backgroundColor = [UIColor whiteColor];
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.height = menuViewHeightDefault;
    self.normalColor = [UIColor darkGrayColor];
    self.hightlightedColor = [UIColor redColor];
}

-(void)_initSubViews{
    
    for (SLSegmentedItem * item in _items) {
        UIButton * btn = [self _createButtonWithItem:item];
        [self.buttonArr addObject:btn];
        [self addSubview:btn];
    }
    UIButton * btn = self.buttonArr[0];
    [btn setTitleColor:self.hightlightedColor forState:UIControlStateNormal];
    self.lastSelectedBtn = btn;
}

-(UIButton*)_createButtonWithItem:(SLSegmentedItem*)item{
    UIButton * btn = [[UIButton alloc]init];
    [btn setTitle:item.title forState:UIControlStateNormal];
    [btn setTitleColor:_normalColor forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    btn.backgroundColor = [UIColor whiteColor];
    return btn;
}


-(void)_changeNextButtonAtIndex:(NSInteger)index rate:(CGFloat)rate{
    UIButton * button = self.buttonArr[index+1];
    [self _changeNextButtonFrame:button rate:rate];
    [self _changeNextButtonTitleColor:button rate:rate];
}

-(void)_changeCurrentButtonAtIndex:(NSInteger)index rate:(CGFloat)rate{
    UIButton * button = self.buttonArr[index];
    [self _changeCurrentButtonFrame:button rate:rate];
    [self _changeCurrentButtonTitleColor:button rate:rate];
}

-(void)_changeNextButtonFrame:(UIButton*)button rate:(CGFloat)rate{
    UIButton * nextButton = button;
    CGFloat scale = 1 + deltaScale * rate;
    nextButton.transform = CGAffineTransformMakeScale(scale, scale);
}

-(void)_changeNextButtonTitleColor:(UIButton*)button rate:(CGFloat)rate{

    UIButton * nextButton = button;
    UIColor * color = [self getColorWithBeginColor:self.normalColor endColor:self.hightlightedColor rate:rate];
    [nextButton setTitleColor:color forState:UIControlStateNormal];
    
}

-(void)_changeCurrentButtonFrame:(UIButton*)button rate:(CGFloat)rate{
    UIButton * currentBtn = button;
    CGFloat scale = (1+deltaScale)-rate*deltaScale;
    currentBtn.transform = CGAffineTransformMakeScale(scale, scale);
}

-(void)_changeCurrentButtonTitleColor:(UIButton*)button rate:(CGFloat)rate{
    UIButton * currentButton = button;
    UIColor * color = [self getColorWithBeginColor:self.hightlightedColor endColor:self.normalColor rate:rate];
    [currentButton setTitleColor:color forState:UIControlStateNormal];
}


- (NSArray *)getRGBWithColor:(UIColor *)color
{
    CGFloat red = 0.0;
    CGFloat green = 0.0;
    CGFloat blue = 0.0;
    CGFloat alpha = 0.0;
    [color getRed:&red green:&green blue:&blue alpha:&alpha];
    return @[@(red), @(green), @(blue), @(alpha)];
}


-(UIColor *)getColorWithBeginColor:(UIColor*)beginColor endColor:(UIColor*)endColor rate:(CGFloat)rate{
    
    NSArray * hightlightedColorArray = [self getRGBWithColor:endColor];
    NSArray * nomalColorArray = [self getRGBWithColor:beginColor];
    
    CGFloat rDelta = [hightlightedColorArray[0]floatValue] - [nomalColorArray[0] floatValue];
    CGFloat gDelta = [hightlightedColorArray[1]floatValue] - [nomalColorArray[1] floatValue];
    CGFloat bDelta =  [hightlightedColorArray[2]floatValue] - [nomalColorArray[2] floatValue];
    CGFloat r = [nomalColorArray[0] floatValue] +  rDelta*rate;
    CGFloat g = [nomalColorArray[1] floatValue] +  gDelta*rate;
    CGFloat b = [nomalColorArray[2] floatValue] +  bDelta*rate;
    
    UIColor * color = [UIColor colorWithRed:r green:g blue:b alpha:1];
    
    return color;
}

-(void)setSelectedButtonToCenter:(UIButton*)button{
    CGSize contentSize = self.contentSize;
    CGPoint contentOffSet = self.contentOffset;
    CGPoint buttonCenter = button.center;
    CGPoint convertCenter = [self convertPoint:buttonCenter toView:self.superview];
    CGFloat buttonCenterX = convertCenter.x;
    CGFloat selfCenterX = self.center.x;
    if (buttonCenterX == selfCenterX) {
        return;
    }
    
    CGFloat deltaX = buttonCenterX - selfCenterX;
    //判断右边界
    if (deltaX>0) {
        if (deltaX > (contentSize.width-(contentOffSet.x+self.frame.size.width))) {
            deltaX = contentSize.width-(contentOffSet.x+self.frame.size.width);
        }
    }
    //判断左边界
    else{
        if ((contentOffSet.x + deltaX) < 0) {
            deltaX = -contentOffSet.x;
        }
    }
    //判断是否会出界
    CGFloat destinationContentOffSetX = contentOffSet.x+deltaX;
    [self setContentOffset:CGPointMake(destinationContentOffSetX, 0) animated:YES];
}


#pragma -mark  ----------点击动作------------
-(void)btnClick:(id)sender{
    UIButton * button = sender;
    UIButton * lastButton = self.lastSelectedBtn;
    if (button == lastButton) {
        return;
    }
    
    self.userInteractionEnabled = NO;
    [button setTitleColor:self.hightlightedColor forState:UIControlStateNormal];
    [lastButton setTitleColor:self.normalColor forState:UIControlStateNormal];
    
    NSInteger  selectedIndex = [self.buttonArr indexOfObject:button];
    [self.viewControllerView scrollToViewAtIndex:selectedIndex];
    [UIView animateWithDuration:0.25 animations:^{
        button.transform = CGAffineTransformMakeScale(1+deltaScale, 1+deltaScale);
        lastButton.transform = CGAffineTransformIdentity;
        
    } completion:^(BOOL finished) {
        self.lastSelectedBtn = button;
        self.userInteractionEnabled = YES;
        
        //设置button的位置
        [self setSelectedButtonToCenter:button];
        
    }];
}



#pragma -mark  ----------getterAndSetter------------
-(void)setItems:(NSArray<SLSegmentedItem *> *)items{
    if (items.count == 0 || !items) {
        items = nil;
        return;
    }
    
    _items = items;
    [self _initSubViews];
}

-(NSMutableArray *)buttonArr{
    if (!_buttonArr) {
        _buttonArr = [NSMutableArray array];
    }
    return _buttonArr;
}


@end

//=============================================================================
#pragma -mark =======================SLSegmentedControllerView================

@interface SLSegmentedControllerView ()<UIScrollViewDelegate>

@property(nonatomic,strong)NSMutableArray * viewControllerArr;
@property(nonatomic,assign)BOOL isClickMenuBtn;


@end

@implementation SLSegmentedControllerView

#pragma -mark  ----------初始化------------
-(instancetype)init{
    if (self = [super init]) {
        [self _configDefault];
    }
    return self;
}

#pragma -mark ------------------重写父类方法-----------------------
-(void)layoutSubviews{
    [super layoutSubviews];
    
    for (NSInteger i = 0; i<self.viewControllerArr.count; i++) {
        UIView * view = self.viewControllerArr[i];
        view.frame = CGRectMake(i*self.frame.size.width, 0, self.frame.size.width,self.frame.size.height);
    }

    self.contentSize = CGSizeMake(self.frame.size.width*self.viewControllerArr.count, 0);
}

#pragma -mark  ----------公有方法------------
-(void)scrollToViewAtIndex:(NSInteger)index{
    self.isClickMenuBtn = YES;
    [self setContentOffset:CGPointMake(index*self.frame.size.width, 0) animated:YES];
}

#pragma -mark  ----------私有方法------------
-(void)_configDefault{
    self.backgroundColor = [UIColor whiteColor];
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.pagingEnabled = YES;
    self.delegate = self;
}

-(void)_initSubViews{

    for (SLSegmentedItem * item in self.items) {
        UIViewController * viewController = item.viewController;
        UIView * view = viewController.view;
        [self.viewControllerArr addObject:view];
        [self addSubview:view];
    }
}

-(void)_changeTextColorAndFrameAtIndex:(NSInteger)index rate:(CGFloat)rate{
    [self.menuView changeTextColorAtIndex:index rate:rate];

}



#pragma -mark  ----------delegate------------
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    self.isClickMenuBtn = NO;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (self.isClickMenuBtn) {
        return;
    }
    
    CGPoint  point = scrollView.contentOffset;
    if (point.x<0) {
        return;
    }
    
    if (point.x>(self.frame.size.width*(self.items.count-1))) {
        return;
    }
    
    NSInteger index = point.x/(self.frame.size.width);
    
    NSInteger remainder = (NSInteger)point.x % (NSInteger)self.frame.size.width;
    CGFloat rate =  remainder /self.frame.size.width;
    
    [self _changeTextColorAndFrameAtIndex:index rate:rate];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{

    if (self.isClickMenuBtn) {
        return;
    }
    CGPoint  point = scrollView.contentOffset;
    NSInteger index = point.x/(self.frame.size.width);
    [self.menuView finishAtIndex:index];
}

#pragma -mark  ----------getterAndSetter------------
-(void)setItems:(NSArray<SLSegmentedItem *> *)items{
    if (items.count == 0 || !items) {
        items = nil;
        return;
    }
    _items = items;
    [self _initSubViews];
}

-(NSMutableArray *)viewControllerArr{
    if (!_viewControllerArr) {
        _viewControllerArr = [NSMutableArray array];
    }
    return _viewControllerArr;
}


@end




//=============================================================================
#pragma -mark =======================SLSegmentedController======================
@interface SLSegmentedController ()

@property(nonatomic,strong)SLSegmentedMenuView * menuView;

@property(nonatomic,strong)SLSegmentedControllerView * controllersView;

@end


@implementation SLSegmentedController

#pragma -mark ------------------初始化方法-----------------------------

-(instancetype)initWithItems:(NSArray <SLSegmentedItem*> * )items{
    if (self = [super init]) {
        [self _configDefault];
        self.items = items;
    }
    return self;
}

#pragma -mark ------------------重写父类方法--------------------------
-(void)layoutSubviews{
    [super layoutSubviews];
    self.menuView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame),44);
    self.controllersView.frame = CGRectMake(0, 44, CGRectGetWidth(self.frame), self.bounds.size.height-44);
}




#pragma -mark ------------------私有方法--------------------------

-(void)_configDefault{
    self.backgroundColor = [UIColor whiteColor];

}

#pragma -mark ------------------getterAndSetter--------------------------

-(void)setItems:(NSArray<SLSegmentedItem *> *)items{
    _items = items;

    self.menuView.items = items;
    self.controllersView.items = items;

    self.menuView.viewControllerView = self.controllersView;
    self.controllersView.menuView = self.menuView;
}



-(SLSegmentedMenuView *)menuView{
    if (!_menuView) {
        _menuView = [[SLSegmentedMenuView alloc]init];
        [self addSubview:_menuView];
    }
    return _menuView;
}


-(SLSegmentedControllerView *)controllersView{
    if (!_controllersView) {
        _controllersView = [[SLSegmentedControllerView alloc]init];
        [self addSubview:_controllersView];
    }
    return _controllersView;
}

//
//
//@interface NSString (sl_stringCategory)
//
//@end
//
//@implementation NSString (sl_stringCategory)
//
//@end
//


/*
#pragma -mark ------------------初始化方法-----------------------------
-(instancetype)init{
    self = [super init];
    if (self) {
        
        [self _configDefualt];
    }
    return self;
}


-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self _configDefualt];
    }
    return self;
}


-(instancetype)initWithTitles:(NSArray <NSString*> *)titles{
    self = [super init];
    if (self) {
        [self _configDefualt];
        self.titles = titles;
    }
    return self;
}


#pragma -mark ------------------重新父类方法-------------------------------

-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.segmentedControllBackgroudView.frame = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, CGRectGetWidth(self.frame), self.segHeight);
    
    
    self.viewControllersBackgroundView.frame = CGRectMake(self.bounds.origin.x, self.segHeight, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)-self.segHeight);
    
    
    UILabel * lastLabel = nil;
    for (UILabel * label in self.lablesArr) {
        NSInteger x = 30;
        if (lastLabel) {
            x = lastLabel.frame.origin.x+lastLabel.frame.size.width+30;
        }
        label.frame = CGRectMake(x,0, 50, 40);
        self.segmentedControllBackgroudView.contentSize = CGSizeMake(label.frame.origin.x+label.frame.size.width+30, 0);
        lastLabel = label;
    }
    
//    NSInteger i = 0;
//    for (UIView * view in self.viewArr) {
//        view.frame = CGRectMake(i*100,0,self.bounds.size.width, self.bounds.size.height-self.segHeight);
//        i++;
//        NSLog(@"i ======= %ld",i);
//    }
//    self.viewControllersBackgroundView.contentSize = CGSizeMake(self.bounds.size.width*self.viewArr.count, 0);
    
}



#pragma -mark -------------------私有方法-------------------------------
-(void)_configDefualt{
    _segHeight = segHightDefault;


}


-(void)_initSegmentedController{

    for (NSString * title in _titles) {
        UILabel * label = [[UILabel alloc]init];
        label.text = title;
        [self.lablesArr addObject:label];
        [self.segmentedControllBackgroudView addSubview:label];
    }

    [self layoutIfNeeded];
}

-(void)_initViewControllersBackgroudView{
    
    NSInteger i = 0;
    for (UIViewController * vc in _viewControllers) {
        [self.viewControllersBackgroundView addSubview:vc.view];
        vc.view.frame = CGRectMake(i*self.frame.size.width,0, self.frame.size.width, self.frame.size.height-self.segHeight);
        [self.viewArr addObject:vc.view];
        i++;
    }
    self.viewControllersBackgroundView.contentSize = CGSizeMake(self.bounds.size.width*self.viewArr.count, 0);
    
    [self layoutIfNeeded];
}

#pragma -mark ------------------getterAndSetter--------------------------
-(void)setTitles:(NSArray<NSString *> *)titles{
    if (titles.count == 0) {
        _titles = nil;
        return;
    }

    _titles = titles;
    [self _initSegmentedController];
}

-(void)setViewControllers:(NSArray<UIViewController *> *)viewControllers{
    if (viewControllers.count == 0) {
        viewControllers = nil;
        return;
    }

    _viewControllers = viewControllers;
    [self _initViewControllersBackgroudView];

}

-(UIScrollView *)segmentedControllBackgroudView{
    if (!_segmentedControllBackgroudView) {
        _segmentedControllBackgroudView = [[UIScrollView alloc]init];
        _segmentedControllBackgroudView.backgroundColor = [UIColor redColor];
        [self addSubview:_segmentedControllBackgroudView];
    }
    return _segmentedControllBackgroudView;
}

-(NSMutableArray *)lablesArr{
    if (!_lablesArr) {
        _lablesArr = [NSMutableArray array];
    }
    return _lablesArr;
}

-(UIScrollView *)viewControllersBackgroundView{
    if (!_viewControllersBackgroundView) {
        _viewControllersBackgroundView = [[UIScrollView alloc]init];
        _viewControllersBackgroundView.backgroundColor = [UIColor blackColor];
        [self addSubview:_viewControllersBackgroundView];
    }
    return _viewControllersBackgroundView;
}


-(NSMutableArray *)viewArr{
    if (!_viewArr) {
        _viewArr = [NSMutableArray array];
    }
    
    return _viewArr;
}
*/
@end
