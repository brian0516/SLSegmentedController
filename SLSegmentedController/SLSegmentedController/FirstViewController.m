//
//  FirstViewController.m
//  SLSegmentedController
//
//  Created by shuanglong on 16/12/15.
//  Copyright © 2016年 shuanglong. All rights reserved.
//

#import "FirstViewController.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView * v = [UIView new];
    [self.view addSubview:v];
    v.frame = self.view.bounds;
    v.backgroundColor = [UIColor purpleColor];
    
    v.layer.borderWidth = 5;
    v.layer.borderColor = [UIColor blackColor].CGColor;
}


-(void)loadView{
    UIScrollView * v = [[UIScrollView alloc]init];
    v.frame = CGRectMake(0, 0, 100, 100);
    v.backgroundColor = [UIColor greenColor];
    v.clipsToBounds = YES;
    self.view = v;
}


@end
