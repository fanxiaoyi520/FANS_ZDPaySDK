//
//  ZDPay_AddBankModel.m
//  ZDPaySDK
//
//  Created by FANS on 2020/4/21.
//  Copyright © 2020 ZhongDaoGroup. All rights reserved.
//

#import "ZDPay_AddBankModel.h"
#import "ZDPayFuncTool.h"
@interface ZDPay_AddBankModel()
@property (nonatomic ,strong)ZDPay_AddBankModel *model;
@end

@implementation ZDPay_AddBankModel
+ (instancetype)sharedSingleten {
    static ZDPay_AddBankModel *_sharedSingleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
          // 要使用self来调用
        _sharedSingleton = [[self alloc] init];
    });
    return _sharedSingleton;
}

- (void)setModelProcessingDic:(NSDictionary *)dic {
     self.model = [ZDPay_AddBankModel mj_objectWithKeyValues:dic];
}

- (instancetype)getModelData {
    return self.model;
}

@end
