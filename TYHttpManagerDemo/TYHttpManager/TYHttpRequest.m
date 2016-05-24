//
//  TYHttpRequest.m
//  TYHttpManagerDemo
//
//  Created by tany on 16/5/23.
//  Copyright © 2016年 tany. All rights reserved.
//

#import "TYHttpRequest.h"
#import "TYResponseCache.h"
#import "TYHttpManager.h"

@interface TYResponseCache ()<TYHttpResponseCache>

@end

@implementation TYHttpRequest

- (instancetype)init
{
    if (self = [super init]) {
        _responseCache = [[TYResponseCache alloc]init];
    }
    return self;
}

#pragma mark - load reqeust

- (void)loadRequest
{
    _responseFromCache = NO;
    if (_requestResponseFromCache && _cacheTimeInSeconds > 0) {
        // 从缓存中获取
        [self loadResponseFromCache];
    }
    
    if (!_responseFromCache) {
        // 请求数据
        [super loadRequest];
    }
}

// 从缓存中获取数据
- (void)loadResponseFromCache
{
    id<TYHttpResponseCache> responseCache = [self responseCache];
    
    // 计算过期时间
    double pastTimeInterval = [[NSDate date] timeIntervalSince1970]-[self cacheTimeInSeconds];
    NSDate *pastDate = [NSDate dateWithTimeIntervalSince1970:pastTimeInterval];
    
    // 根据URL 和 过期时间 获取缓存
    NSString *urlKey = [self serializeURLKey];
    id responseObject = [responseCache objectForKey:urlKey overdueDate:pastDate];
    if (responseObject) {
        // 获取到缓存
        _responseFromCache = YES;
        [self requestDidResponse:responseObject error:nil];
    }
}

// 验证缓存
- (BOOL)validResponseObject:(id)responseObject error:(NSError *__autoreleasing *)error
{
    if (_cacheResponse && !_responseFromCache) {
        // 缓存数据
        NSString *urlKey = [self serializeURLKey];
        [[self responseCache]setObject:responseObject forKey:urlKey];
    }
    
    id<TYHttpResponseParser> responseParser = [self responseParser];
    if (responseParser == nil) {
        return [super validResponseObject:responseObject error:error];
    }
    
    if ([responseParser isValidResponse:responseObject request:self error:error]) {
        // 验证后 解析数据
        id responseParsedObject = [responseParser parseResponse:responseObject request:self];
        return [super validResponseObject:responseParsedObject error:error];
    }else {
        return NO;
    }
}

#pragma mark - private

// 拼装url key
- (NSString *)serializeURLKey
{
    NSDictionary *paramters = [self parameters];
    NSArray *ignoreParamterKeys = [self cacheIgnoreParamtersKeys];
    if (ignoreParamterKeys) {
        NSMutableDictionary *fiterParamters = [NSMutableDictionary dictionaryWithDictionary:paramters];
        [fiterParamters removeObjectsForKeys:ignoreParamterKeys];
        paramters = fiterParamters;
    }
    NSString *URLString = [[TYHttpManager sharedInstance]buildRequstURL:self];
    return [URLString stringByAppendingString:[self serializeParams:paramters]];
}

// 拼接params
- (NSString *)serializeParams:(NSDictionary *)params {
    NSMutableArray *parts = [NSMutableArray array];
    [params enumerateKeysAndObjectsUsingBlock:^(id key, id<NSObject> obj, BOOL *stop) {
        NSString *encodedKey = [key stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
        NSString *encodedValue = [obj.description stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
        NSString *part = [NSString stringWithFormat: @"%@=%@", encodedKey, encodedValue];
        [parts addObject: part];
    }];
    NSString *queryString = [parts componentsJoinedByString: @"&"];
    return queryString?[NSString stringWithFormat:@"?%@", queryString]:@"";
}

@end
