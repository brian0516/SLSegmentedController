//
//  ViewController.m
//  SLSegmentedController
//
//  Created by shuanglong on 16/12/14.
//  Copyright © 2016年 shuanglong. All rights reserved.
//

#import "ViewController.h"
#import "SLSegmentedController.h"
#import "SecondViewController.h"
#import "ThirdViewController.h"
#import "FourthViewController.h"
#import "FirstViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    FirstViewController * first = [[FirstViewController alloc]initWithString:@"这是第一页"];
    SecondViewController * second = [[SecondViewController alloc]initWithString:@"这是第二页"];
    ThirdViewController * third = [[ThirdViewController alloc]initWithString:@"这是第三页"];
    FourthViewController * fourth = [[FourthViewController alloc]initWithString:@"这是第四页"];
    
    NSArray * viewControllers = @[first,second,third,fourth];
    NSArray * titles = @[@"viewController1",@"viewController2",@"viewController3",@"viewController4"];
    
    NSMutableArray* items = [NSMutableArray array];
    
    for (NSInteger i = 0; i<4 ; i++) {
        SLSegmentedItem * item = [[SLSegmentedItem alloc]init];
        item.title = titles[i];
        item.viewController = viewControllers[i];
        [items addObject:item];
    }
    
    SLSegmentedController * seg = [[SLSegmentedController alloc]initWithItems:(NSArray*)items];
    seg.frame = CGRectMake(0, 20, self.view.frame.size.width, 600);
    [self.view addSubview:seg];

    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
