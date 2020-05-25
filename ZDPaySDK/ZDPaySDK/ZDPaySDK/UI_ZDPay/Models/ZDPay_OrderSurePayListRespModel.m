//
//  ZDPay_OrderSurePayListRespModel.m
//  ReadingEarn
//
//  Created by FANS on 2020/4/15.
//  Copyright © 2020 FANS. All rights reserved.
//

#import "ZDPay_OrderSurePayListRespModel.h"
#import "ZDPayFuncTool.h"

@interface ZDPay_OrderSurePayListRespModel()
@property (nonatomic ,strong)ZDPay_OrderSurePayListRespModel *model;
@end

@implementation ZDPay_OrderSurePayListRespModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"pay_id" : @"id"//前边的是你想用的key，后边的是返回的key
             };
}

+ (instancetype)sharedSingleten {
    static ZDPay_OrderSurePayListRespModel *_sharedSingleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
          // 要使用self来调用
        _sharedSingleton = [[self alloc] init];
    });
    return _sharedSingleton;
}

- (void)setModelProcessingDic:(NSDictionary *)dic {
     self.model = [ZDPay_OrderSurePayListRespModel mj_objectWithKeyValues:dic];
}

- (ZDPay_OrderSurePayListRespModel *)getModelData {
    return self.model;
}
@end
