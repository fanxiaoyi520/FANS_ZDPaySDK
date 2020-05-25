//
//  ZDPay_OrderBankListTokenModel.h
//  ZDPaySDK
//
//  Created by FANS on 2020/4/20.
//  Copyright © 2020 ZhongDaoGroup. All rights reserved.
//

#import "ZDPayRootModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZDPay_OrderBankListTokenModel : ZDPayRootModel

+ (instancetype)sharedSingleten;
- (void)setModelProcessingDic:(NSDictionary *)dic;
- (instancetype)getModelData;

@property (nonatomic ,copy)NSString *bankName;//银行名称
@property (nonatomic ,copy)NSString *cardBgImage;//银行卡背景图 url地址
@property (nonatomic ,copy)NSString *cardId;//银行卡号
@property (nonatomic ,copy)NSString *cardMsg;//银行图标url地址
@property (nonatomic ,copy)NSString *cardNum;//银行卡号 银行卡后4位
@property (nonatomic ,copy)NSString *cardType;//银行卡类型 D:储蓄卡 C:信用卡
@property (nonatomic ,copy)NSString *serialNumber;//数据库ID
@property (nonatomic ,copy)NSString *sysareaId;

@end

NS_ASSUME_NONNULL_END
