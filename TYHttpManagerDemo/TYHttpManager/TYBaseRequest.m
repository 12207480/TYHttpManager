//
//  TYBaseRequest.m
//  TYHttpManagerDemo
//
//  Created by tany on 16/5/23.
//  Copyright © 2016年 tany. All rights reserved.
//

#import "TYBaseRequest.h"
#import "TYHttpManager.h"

@interface TYBaseRequest ()
@property (nonatomic, copy) TYRequestSuccessBlock successBlock;
@property (nonatomic, copy) TYRequestFailureBlock failureBlock;

@property (nonatomic, assign) TYRequestState state;
@property (nonatomic, strong) id responseObject;
@end

@implementation TYBaseRequest

-(instancetype)init
{
    if (self = [super init]) {
        _method = TYRequestMethodGet;
        _serializerType = TYRequestSerializerTypeJSON;
        _timeoutInterval = 60;
    }
    return self;
}

#pragma mark - load request

// 请求
- (void)load
{
    // 请求数据
    [self loadRequest];
    
    // 请求已经开始
    [self requestDidStart];
}

// 取消
- (void)cancle
{
    [_dataTask cancel];
}

// 请求缓存
- (void)loadRequest
{
    [[TYHttpManager sharedInstance] addRequest:self];
}

- (void)setRequestSuccessBlock:(TYRequestSuccessBlock)successBlock failureBlock:(TYRequestFailureBlock)failureBlock
{
    _successBlock = successBlock;
    _failureBlock = failureBlock;
    
}

- (void)loadWithSuccessBlock:(TYRequestSuccessBlock)successBlock failureBlock:(TYRequestFailureBlock)failureBlock
{
    [self setRequestSuccessBlock:successBlock failureBlock:failureBlock];
    
    [self load];
}

#pragma mark - call delegate , block

// 请求已经开始
- (void)requestDidStart
{
    _state = TYRequestStateLoading;
    if ([_delegate respondsToSelector:@selector(requestDidStart:)]) {
        [_delegate requestDidStart:self];
    }
}

// 收到数据
- (void)requestDidResponse:(id)responseObject error:(NSError *)error
{
    if (error) {
        [self requestDidFailWithError:error];
    }else {
        if ([self validResponseObject:responseObject error:&error]){
            [self requestDidFinish];
        }else{
            [self requestDidFailWithError:error];
        }
        
    }
}

// 验证数据
- (BOOL)validResponseObject:(id)responseObject error:(NSError *__autoreleasing *)error
{
    _responseObject = responseObject;
    return YES;
}

// 请求成功
- (void)requestDidFinish
{
    _state = TYRequestStateFinish;
    if ([_delegate respondsToSelector:@selector(requestDidFinish:)]) {
        [_delegate requestDidFinish:self];
    }
    
    if (_successBlock) {
        _successBlock(self);
    }
}

// 请求失败
- (void)requestDidFailWithError:(NSError* )error
{
    _state = TYRequestStateError;
    if ([_delegate respondsToSelector:@selector(request:didFailWithError:)]) {
        [_delegate request:self didFailWithError:error];
    }
    
    if (_failureBlock) {
        _failureBlock(self,error);
    }
}

// 清除block引用
- (void)clearRequestBlock
{
    _successBlock = nil;
    _failureBlock = nil;
}

- (void)dealloc
{
    [self clearRequestBlock];
    
    _delegate = nil;
    _progressBlock = nil;
    _constructingBodyBlock = nil;
    
    NSLog(@"%@%s",NSStringFromClass([self class]),__func__);
}

@end
