//
//  TCategoryRequest.m
//  TYHttpManagerDemo
//
//  Created by tany on 16/5/24.
//  Copyright © 2016年 tany. All rights reserved.
//

#import "TCategoryRequest.h"

@implementation TCategoryRequest

+ (instancetype)requestWithGender:(NSString *)gender generation:(NSString *)generation
{
    TCategoryRequest *request = [TCategoryRequest requestWithModelClass:[TCatergoryData class]];
    // 可以在appdeleagte 里 设置 TYRequstConfigure baseURL
    request.URLString = @"http://api.liwushuo.com/v2/secondary_banners";
    request.parameters = @{@"gender":gender,@"generation":generation};;
    return request;
}

@end
