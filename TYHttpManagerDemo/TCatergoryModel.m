//
//  TCatergoryModel.m
//  TYHttpManagerDemo
//
//  Created by tany on 16/5/24.
//  Copyright © 2016年 tany. All rights reserved.
//

#import "TCatergoryModel.h"
#import "TYJSONModel.h"

@implementation TCatergoryData

+ (NSDictionary *)modelClassInArrayOrDictonary
{
    return @{@"secondary_banners":[TCatergoryModel class]};
}


@end

@implementation TCatergoryModel

@end
