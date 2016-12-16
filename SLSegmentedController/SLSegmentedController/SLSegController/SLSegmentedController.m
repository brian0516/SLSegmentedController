//
//  SLSegmentedController.m
//  SLSegmentedController
//
//  Created by shuanglong on 16/12/15.
//  Copyright © 2016年 shuanglong. All rights reserved.
//

#import "SLSegmentedController.h"

static  NSInteger const menuViewHeightDefault = 44;
static  CGFloat const deltaScale = 0.15f;
static  CGFloat const fontSizeDefault = 15.0f;
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
    self.fontSize = fontSizeDefault;
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
    btn.titleLabel.font = [UIFont systemFontOfSize:self.fontSize];
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


-(void)setNormalColor:(UIColor *)normalColor{
    if (!normalColor) {
        _normalColor = [UIColor darkGrayColor];
    }
    else{
        _normalColor = normalColor;
    }
    if (self.buttonArr.count>0) {
        for (NSInteger i = 1; i<self.buttonArr.count-1; i++) {
            UIButton * btn = self.buttonArr[i];
            [btn setTitleColor:_normalColor forState:UIControlStateNormal];
        }
    }
}

-(void)setHightlightedColor:(UIColor *)hightlightedColor{
    if (!hightlightedColor) {
        _hightlightedColor = [UIColor redColor];
    }
    else{
        _hightlightedColor = hightlightedColor;
    }
    
    if (self.buttonArr.count>0) {
        UIButton * btn = [self.buttonArr firstObject];
        [btn setTitleColor:_hightlightedColor forState:UIControlStateNormal];
    }
}

-(void)setHeight:(NSInteger)height{
    _height = height;
    self.hasSetBtnFrame = NO;
}

-(void)setFontSize:(CGFloat)fontSize{
    _fontSize = fontSize;
    if (self.buttonArr.count>0) {
        UIButton * btn = [self.buttonArr firstObject];
        btn.transform = CGAffineTransformIdentity;
        
        for (NSInteger i = 0; i<self.buttonArr.count; i++) {
            UIButton * btn = self.buttonArr[i];
            btn.titleLabel.font = [UIFont systemFontOfSize:_fontSize];
        }
    }
    self.hasSetBtnFrame = NO;
    [self layoutIfNeeded];
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
    self.menuView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame),self.menuHeight);
    self.controllersView.frame = CGRectMake(0, self.menuHeight, CGRectGetWidth(self.frame), self.bounds.size.height-self.menuHeight);
}




#pragma -mark ------------------私有方法--------------------------

-(void)_configDefault{
    self.backgroundColor = [UIColor whiteColor];
    _menuHeight = 44;

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


-(void)setNormalColor:(UIColor *)normalColor{
    if (!normalColor) {
        _normalColor = [UIColor darkGrayColor];
    }
    else{
        _normalColor = normalColor;
    }
    self.menuView.normalColor = _normalColor;
}

-(void)setHightlightedColor:(UIColor *)hightlightedColor{
    if (!hightlightedColor) {
        _hightlightedColor = [UIColor redColor];
    }
    else{
        _hightlightedColor = hightlightedColor;
    }
    self.menuView.hightlightedColor = _hightlightedColor;
}

-(void)setMenuHeight:(CGFloat)menuHeight{
    if (menuHeight<=0) {
        _menuHeight = 44;
    }
    else{
        _menuHeight = menuHeight;
    }
    self.menuView.height = _menuHeight;
    [self layoutIfNeeded];
}

-(void)setFontSize:(CGFloat)fontSize{
    _fontSize = fontSize;
 self.menuView.fontSize = _fontSize;
}



@end
