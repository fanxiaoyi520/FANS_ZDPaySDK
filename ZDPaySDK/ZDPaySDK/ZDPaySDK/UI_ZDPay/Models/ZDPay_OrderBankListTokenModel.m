//
//  ZDPay_OrderBankListTokenModel.m
//  ZDPaySDK
//
//  Created by FANS on 2020/4/20.
//  Copyright © 2020 ZhongDaoGroup. All rights reserved.
//

#import "ZDPay_OrderBankListTokenModel.h"
#import "ZDPayFuncTool.h"

@interface ZDPay_OrderBankListTokenModel()
@property (nonatomic ,strong)ZDPay_OrderBankListTokenModel *model;
@end

@implementation ZDPay_OrderBankListTokenModel

+ (instancetype)sharedSingleten {
    static ZDPay_OrderBankListTokenModel *_sharedSingleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
          // 要使用self来调用
        _sharedSingleton = [[self alloc] init];
    });
    return _sharedSingleton;
}

- (void)setModelProcessingDic:(NSDictionary *)dic {
     self.model = [ZDPay_OrderBankListTokenModel mj_objectWithKeyValues:dic];
}

- (instancetype)getModelData {
    return self.model;
}

@end
