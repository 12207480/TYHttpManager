//
//  TCatergoryModel.h
//  TYHttpManagerDemo
//
//  Created by tany on 16/5/24.
//  Copyright © 2016年 tany. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TCatergoryData : NSObject

@property (nonatomic,strong) NSArray *secondary_banners;

@end

@interface TCatergoryModel : NSObject

@property (nonatomic, assign) NSInteger id;
@property (nonatomic, strong) NSString *image_url;
@property (nonatomic, strong) NSString *target_url;
@property (nonatomic, strong) NSString *webp_url;
@property (nonatomic, strong) NSArray *ad_monitors;

@end
