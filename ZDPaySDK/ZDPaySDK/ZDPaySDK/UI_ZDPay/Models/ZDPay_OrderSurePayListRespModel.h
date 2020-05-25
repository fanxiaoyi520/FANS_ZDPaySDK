//
//  ZDPay_OrderSurePayListRespModel.h
//  ReadingEarn
//
//  Created by FANS on 2020/4/15.
//  Copyright © 2020 FANS. All rights reserved.
//

#import "ZDPayRootModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZDPay_OrderSurePayListRespModel : ZDPayRootModel
+ (instancetype)sharedSingleten;
- (void)setModelProcessingDic:(NSDictionary *)dic;
- (instancetype)getModelData;

@property (nonatomic ,copy)NSString *bankName;//银行名称
@property (nonatomic ,copy)NSString *cardBgImage;//银行卡背景图 url地址
@property (nonatomic ,copy)NSString *cardId;//银行卡号
@property (nonatomic ,copy)NSString *cardMsg;//银行图标url地址
@property (nonatomic ,copy)NSString *cardType;//银行卡类型 D:储蓄卡 C:信用卡
@property (nonatomic ,copy)NSString *serialNumber;//数据库ID
@property (nonatomic ,copy)NSString *sysareaId;


@property (nonatomic ,copy)NSString *channelCode;
@property (nonatomic ,copy)NSString *channelId;
@property (nonatomic ,copy)NSString *channelStatus;
@property (nonatomic ,copy)NSString *pay_id;
@property (nonatomic ,copy)NSString *imgUrl;
@property (nonatomic ,copy)NSString *merchantNo;
@property (nonatomic ,copy)NSString *name;
@property (nonatomic ,copy)NSString *merchantId;
@property (nonatomic ,copy)NSString *remark;
@property (nonatomic ,copy)NSString *cardNum;


@end

NS_ASSUME_NONNULL_END
