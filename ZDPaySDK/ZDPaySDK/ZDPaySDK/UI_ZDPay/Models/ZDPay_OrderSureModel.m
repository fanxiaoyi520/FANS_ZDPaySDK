//
//  ZDPay_OrderSureModel.m
//  ReadingEarn
//
//  Created by FANS on 2020/4/14.
//  Copyright © 2020 FANS. All rights reserved.
//

#import "ZDPay_OrderSureModel.h"
#import "ZDPayFuncTool.h"

@interface ZDPay_OrderSureModel()
@property (nonatomic ,strong)ZDPay_OrderSureModel *model;
@end
@implementation ZDPay_OrderSureModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"service_d" : @"service"//前边的是你想用的key，后边的是返回的key
             };
}

+ (instancetype)sharedSingleten {
    static ZDPay_OrderSureModel *_sharedSingleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
          // 要使用self来调用
        _sharedSingleton = [[self alloc] init];
    });
    return _sharedSingleton;
}

- (void)setModelProcessingDic:(NSDictionary *)dic {
     self.model = [ZDPay_OrderSureModel mj_objectWithKeyValues:dic];
}

- (instancetype)getModelData {
    return self.model;
}
@end
