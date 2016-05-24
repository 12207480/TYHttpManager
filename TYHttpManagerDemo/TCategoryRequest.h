//
//  TCategoryRequest.h
//  TYHttpManagerDemo
//
//  Created by tany on 16/5/24.
//  Copyright © 2016年 tany. All rights reserved.
//

#import "TYModelRequest.h"
#import "TCatergoryModel.h"

@interface TCategoryRequest : TYModelRequest

+ (instancetype)requestWithGender:(NSString *)gender generation:(NSString *)generation;

@end
