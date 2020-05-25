//
//  ZDPay_OrderSureRespModel.h
//  ReadingEarn
//
//  Created by FANS on 2020/4/15.
//  Copyright © 2020 FANS. All rights reserved.
//

#import "ZDPayRootModel.h"
#import "ZDPay_OrderSureBankListRespModel.h"
#import "ZDPay_OrderSurePayListRespModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZDPay_OrderSureRespModel : ZDPayRootModel
+ (instancetype)sharedSingleten;
- (void)setModelProcessingDic:(NSDictionary *)dic;
- (instancetype)getModelData;

/**
 用户存在标识
 0:用户存在
 1:用户不存在
 */
@property (nonatomic ,copy)NSString *isUser;
@property (nonatomic ,strong)ZDPay_OrderSureBankListRespModel *bankList;

@property (nonatomic ,strong)NSArray<ZDPay_OrderSurePayListRespModel *> *payList;
@property (nonatomic ,strong)ZDPay_OrderSurePayListRespModel *payListModel;

@end

NS_ASSUME_NONNULL_END
