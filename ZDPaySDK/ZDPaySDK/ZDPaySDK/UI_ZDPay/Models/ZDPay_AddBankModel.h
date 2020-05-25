//
//  ZDPay_AddBankModel.h
//  ZDPaySDK
//
//  Created by FANS on 2020/4/21.
//  Copyright © 2020 ZhongDaoGroup. All rights reserved.
//

#import "ZDPayRootModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZDPay_AddBankModel : ZDPayRootModel
+ (instancetype)sharedSingleten;
- (void)setModelProcessingDic:(NSDictionary *)dic;
- (instancetype)getModelData;

@property (nonatomic ,copy)NSString *cardNum;
@property (nonatomic ,copy)NSString *cardName;
@property (nonatomic ,copy)NSString *cardType;
@property (nonatomic ,copy)NSString *cardNo;
@property (nonatomic ,copy)NSString *registerMobile;
@property (nonatomic ,copy)NSString *registerCountryCode;
@property (nonatomic ,copy)NSString *termValidity;//有效期
@property (nonatomic ,copy)NSString *CVN;
@property (nonatomic ,copy)NSString *documentType;
@property (nonatomic ,copy)NSString *zhenjianType;

@property (nonatomic ,copy)NSString *bankName;
@property (nonatomic ,copy)NSString *cardflag;

@end

NS_ASSUME_NONNULL_END
