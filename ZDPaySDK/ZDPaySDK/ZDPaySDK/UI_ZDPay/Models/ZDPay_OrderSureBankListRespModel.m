//
//  ZDPay_OrderSureBankListRespModel.m
//  ReadingEarn
//
//  Created by FANS on 2020/4/15.
//  Copyright © 2020 FANS. All rights reserved.
//

#import "ZDPay_OrderSureBankListRespModel.h"

@implementation ZDPay_OrderSureBankListRespModel
+ (NSDictionary *)mj_objectClassInArray
{
    return @{
        @"Token":@"ZDPay_OrderBankListTokenModel",
    };
};
@end
