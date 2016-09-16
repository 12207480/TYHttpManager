//
//  THttpRequest.m
//  TYHttpManagerDemo
//
//  Created by tany on 16/5/24.
//  Copyright © 2016年 tany. All rights reserved.
//

#import "THttpRequest.h"

@implementation THttpRequest

@dynamic responseObject;

- (instancetype)initWithModelClass:(Class)modelClass
{
    if (self = [super init]) {
        self.responseParser = [[TResponseObject alloc]initWithModelClass:modelClass];
    }
    return self;
}

+ (instancetype)requestWithModelClass:(Class)modelClass
{
    return [[self alloc]initWithModelClass:modelClass];
}

@end
