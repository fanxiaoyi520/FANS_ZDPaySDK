//
//  ZDPay_OrderSureRespModel.m
//  ReadingEarn
//
//  Created by FANS on 2020/4/15.
//  Copyright © 2020 FANS. All rights reserved.
//

#import "ZDPay_OrderSureRespModel.h"
#import "ZDPayFuncTool.h"

@interface ZDPay_OrderSureRespModel()
@property (nonatomic ,strong)ZDPay_OrderSureRespModel *model;
@end

@implementation ZDPay_OrderSureRespModel
+ (NSDictionary *)mj_objectClassInArray{
    return @{
            @"payList" : @"ZDPay_OrderSurePayListRespModel",
            };//前边，是属性数组的名字，后边就是类名
}

+ (instancetype)sharedSingleten {
    static ZDPay_OrderSureRespModel *_sharedSingleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
          // 要使用self来调用
        _sharedSingleton = [[self alloc] init];
    });
    return _sharedSingleton;
}

- (void)setModelProcessingDic:(NSDictionary *)dic {
     self.model = [ZDPay_OrderSureRespModel mj_objectWithKeyValues:dic];
}

- (instancetype)getModelData {
    return self.model;
}

@end
