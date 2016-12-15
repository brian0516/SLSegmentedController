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
#import "thirdViewController.h"
#import "FourthViewController.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
        SecondViewController * second = [[SecondViewController alloc]init];
        thirdViewController * third = [[thirdViewController alloc]init];
        FourthViewController * fourth = [[FourthViewController alloc]init];
    NSArray * viewControllers = @[second,third,fourth];
    NSArray * titles = @[@"viewController1",@"viewController2",@"viewController3"];
    
    NSMutableArray* items = [NSMutableArray array];
    
    for (NSInteger i = 0; i<3 ; i++) {
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
