//
//  TYResponseObject.m
//  TYHttpManagerDemo
//
//  Created by tany on 16/5/24.
//  Copyright © 2016年 tany. All rights reserved.
//

#import "TResponseObject.h"
#import "TYJSONModel.h"

@implementation TResponseObject

- (BOOL)isValidResponse:(id)response request:(TYHttpRequest *)request error:(NSError *__autoreleasing *)error
{
    if (![super isValidResponse:response request:request error:error]) {
        return NO;
    }
    
    // 根据 response 结构 应该为字典
    if (![response isKindOfClass:[NSDictionary class]]) {
        *error = [NSError errorWithDomain:@"response is invalide, is not NSDictionary" code:-1  userInfo:nil];
        return NO;
    }
    
    // 获取自定义的状态码
    NSInteger status = [[response objectForKey:@"code"] integerValue];
    if (status != TYStauteSuccessCode) {
        self.status = status;
        self.msg = [response objectForKey:@"message"];
        *error = [NSError errorWithDomain:self.msg code:self.status  userInfo:nil];
        return NO;
    }
    
    return YES;
}

- (id)parseResponse:(id)response request:(TYHttpRequest *)request
{
    self.status = [[response objectForKey:@"code"] integerValue];
    self.msg = [response objectForKey:@"message"];
    id json = [response objectForKey:@"data"];
//    _pgIndex = [[response objectForKey:@"pgIndex"] integerValue];
//    _pgSize = [[response objectForKey:@"pgSize"] integerValue];
//    _count = [[response objectForKey:@"count"] integerValue];
    
    if (self.modelClass) {
        if ([json isKindOfClass:[NSDictionary class]]) {
            self.data = [[self modelClass] ty_ModelWithDictonary:json];
        }else if ([json isKindOfClass:[NSArray class]]) {
            self.data = [[self modelClass] ty_modelArrayWithDictionaryArray:json];
        }
    }else {
        self.data = json;
    }
    return self;
}

//- (void)dealloc
//{
//    NSLog(@"%@%s",NSStringFromClass([self class]),__func__);
//}

@end
