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
#import "TYChainRequest.h"
#import "TYBatchRequest.h"

@interface ViewController ()<TYRequestDelegate>
@property (nonatomic, weak) THttpRequest *request;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

// 请求 使用block
- (IBAction)requestBlockAction:(id)sender {
    
    [MBProgressHUD showMessage:@"加载中..." toView:self.view];
    
     // request 使用继承
    [_request cancle];
    _request = [TCategoryRequest requestWithGender:@"1" generation:@"1"];
    // 缓存数据
    _request.requestFromCache = YES;
    _request.cacheResponse = YES;
    
    [_request loadWithSuccessBlock:^(TCategoryRequest *request) {
        NSLog(@"%@ data:%@",request.responseObject,request.responseObject.data);
        [MBProgressHUD showSuccess:@"加载成功!" toView:self.view];
    } failureBlock:^(TCategoryRequest *request, NSError *error) {
        [MBProgressHUD showError:@"加载失败!" toView:self.view];
    }];
}

// 请求 使用delegate
- (IBAction)requestDelegateAction:(id)sender {
    
    [MBProgressHUD showMessage:@"加载中..." toView:self.view];
    
    // 不用继承 直接使用request
    THttpRequest *request = [THttpRequest requestWithModelClass:[TCatergoryData class]];
    // 可以在appdeleagte 里 设置 TYRequstConfigure baseURL
    request.URLString = @"http://api.liwushuo.com/v2/secondary_banners";
    request.parameters = @{@"gender":@"1",@"generation":@"1"};
    request.delegate = self;
    [request load];
}

- (IBAction)chainRquestAction:(id)sender {
    [MBProgressHUD showMessage:@"加载中..." toView:self.view];
    
    THttpRequest *request1 = [self reuqetWithidentifer:@"11111"];
    THttpRequest *request2 = [self reuqetWithidentifer:@"22222"];
    THttpRequest *request3 = [self reuqetWithidentifer:@"33333"];
    THttpRequest *request4 = [self reuqetWithidentifer:@"44444"];
    THttpRequest *request5 = [self reuqetWithidentifer:@"55555"];
    
    TYChainRequest *chainRequest = [[TYChainRequest alloc]init];
    [chainRequest addRequest:request1];
     [chainRequest addRequest:request2];
     [chainRequest addRequest:request3];
     [chainRequest addRequest:request4];
     [chainRequest addRequest:request5];
    
    [chainRequest loadWithSuccessBlock:^(TYChainRequest *request) {
        // TYChainRequest
        [MBProgressHUD showSuccess:@"chainRequest 加载成功!" toView:self.view];
    } failureBlock:^(TYChainRequest *request, NSError *error) {
        // TYChainRequest
        [MBProgressHUD showError:@"chainRequest 加载失败!" toView:self.view];
    }];
}

- (IBAction)batchRequestAction:(id)sender {
    [MBProgressHUD showMessage:@"加载中..." toView:self.view];
    
    THttpRequest *request1 = [self reuqetWithidentifer:@"11111"];
    THttpRequest *request2 = [self reuqetWithidentifer:@"22222"];
    THttpRequest *request3 = [self reuqetWithidentifer:@"33333"];
    THttpRequest *request4 = [self reuqetWithidentifer:@"44444"];
    THttpRequest *request5 = [self reuqetWithidentifer:@"55555"];
    
    TYBatchRequest *batchRequest = [[TYBatchRequest alloc]init];
    [batchRequest addRequest:request1];
    [batchRequest addRequest:request2];
    [batchRequest addRequest:request3];
    [batchRequest addRequest:request4];
    [batchRequest addRequest:request5];
    
    [batchRequest loadWithSuccessBlock:^(TYBatchRequest *request) {
        // batchRequest
        [MBProgressHUD showSuccess:@"batchRequest 加载成功!" toView:self.view];
    } failureBlock:^(TYBatchRequest *request, NSError *error) {
        // batchRequest
        [MBProgressHUD showError:@"batchRequest 加载失败!" toView:self.view];
    }];

}

- (THttpRequest *)reuqetWithidentifer:(NSString *)identifer
{
    THttpRequest *request = [TCategoryRequest requestWithGender:@"1" generation:@"1"];
    request.identifier = identifer;
    // 缓存数据
    //    request.requestFromCache = YES;
    //    request.cacheResponse = YES;
    
    [request setRequestSuccessBlock:^(TCategoryRequest *request) {
        NSLog(@"请求成功 request id %@",request.identifier);
    } failureBlock:^(TCategoryRequest *request, NSError *error) {
        NSLog(@"请求失败 request id %@",request.identifier);
    }];
    return request;
}

#pragma mark - delegate

- (void)requestDidFinish:(THttpRequest *)request
{
     NSLog(@"%@ data:%@",request.responseObject,request.responseObject.data);
    [MBProgressHUD showSuccess:@"加载成功!" toView:self.view];
}

- (void)requestDidFail:(THttpRequest *)request error:(NSError *)error
{
     [MBProgressHUD showError:@"加载失败!" toView:self.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
