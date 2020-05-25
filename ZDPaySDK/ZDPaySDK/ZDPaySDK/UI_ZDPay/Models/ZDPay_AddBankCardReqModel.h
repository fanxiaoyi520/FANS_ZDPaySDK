//
//  ZDPay_AddBankCardReqModel.h
//  ZDPaySDK
//
//  Created by FANS on 2020/4/20.
//  Copyright © 2020 ZhongDaoGroup. All rights reserved.
//

#import "ZDPayRootModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZDPay_AddBankCardReqModel : ZDPayRootModel

@property (nonatomic ,copy)NSString *language;
@property (nonatomic ,copy)NSString *registerCountryCode;
@property (nonatomic ,copy)NSString *registerMobile;
@property (nonatomic ,copy)NSString *cardNum;
@property (nonatomic ,copy)NSString *merId;
@property (nonatomic ,copy)NSString *payType;
@end

NS_ASSUME_NONNULL_END
