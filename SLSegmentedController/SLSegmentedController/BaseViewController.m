//
//  BaseViewController.m
//  SLSegmentedController
//
//  Created by shuanglong on 16/12/15.
//  Copyright © 2016年 shuanglong. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()
@property(nonatomic,strong)NSString * string;

@end

@implementation BaseViewController

-(instancetype)initWithString:(NSString *)string{
    if (self = [super init]) {
        _string = string;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel * label = [[UILabel alloc]init];
    label.frame = CGRectMake((self.view.frame.size.width/2-50), 50, 100, 44);
    label.backgroundColor = [UIColor redColor];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = self.string;
    [self.view addSubview:label];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
