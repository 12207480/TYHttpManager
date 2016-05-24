//
//  ViewController.m
//  TYHttpManagerDemo
//
//  Created by tany on 16/5/20.
//  Copyright © 2016年 tany. All rights reserved.
//

#import "ViewController.h"
#import "MBProgressHUD+MJ.h"
#import "TCategoryRequest.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

// 请求
- (IBAction)requestAction:(id)sender {
    [MBProgressHUD showMessage:@"加载中..." toView:self.view];
    TCategoryRequest *request = [TCategoryRequest requestWithGender:@"1" generation:@"1"];
//    request.requestFromCache = YES;
//    request.cacheResponse = YES;
    [request loadWithSuccessBlock:^(TCategoryRequest *request) {
        NSLog(@"%@ ",request.responseObject);
        [MBProgressHUD showSuccess:@"加载成功!" toView:self.view];
    } failureBlock:^(TCategoryRequest *request, NSError *error) {
        [MBProgressHUD showError:@"加载失败!" toView:self.view];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
