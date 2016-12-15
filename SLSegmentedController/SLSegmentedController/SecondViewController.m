//
//  SecondViewController.m
//  SLSegmentedController
//
//  Created by shuanglong on 16/12/15.
//  Copyright © 2016年 shuanglong. All rights reserved.
//

#import "SecondViewController.h"

@interface SecondViewController ()

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blueColor];
    
    UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
    btn.backgroundColor = [UIColor redColor];
    [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    
}


-(void)click:(UIButton *)button{
    
    UIButton * btn = button;
    if (btn.selected) {
        btn.transform = CGAffineTransformIdentity;
    }
    else{
        btn.transform = CGAffineTransformMakeScale(1.5, 1.5);
    }
    btn.selected = !btn.selected;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
