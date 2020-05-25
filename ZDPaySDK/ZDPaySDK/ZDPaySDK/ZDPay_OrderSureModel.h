//
//  ZDPay_OrderSureModel.h
//  ReadingEarn
//
//  Created by FANS on 2020/4/14.
//  Copyright © 2020 FANS. All rights reserved.
//

#import "ZDPayRootModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZDPay_OrderSureModel : ZDPayRootModel


+ (instancetype)sharedSingleten;
- (void)setModelProcessingDic:(NSDictionary *)dic;
- (instancetype)getModelData;

#pragma mark - 后台需要的参数
@property (nonatomic ,copy)NSString *AES_Key; //AES加密key
@property (nonatomic ,copy)NSString *md5_salt; //md5拼接盐
@property (nonatomic ,copy)NSString *registerMobile;//注册手机号
@property (nonatomic ,copy)NSString *registerCountryCode;//注册手机区号
@property (nonatomic ,copy)NSString *merId;//商户号
@property (nonatomic ,copy)NSString *countryCode;//国家编码      中国大陆-142 香港-110 新加坡-132 马来西亚-122
@property (nonatomic ,copy)NSString *phoneSystem;//手机系统 Android or Ios
@property (nonatomic ,copy)NSString *orderNo;//订单号 商家订单号唯一
@property (nonatomic ,copy)NSString *language;//语言 中文:zh-CN 英文:en-US 繁体:zh-HK
@property (nonatomic ,copy)NSString *isSendPurchase;//是否发起消费
@property (nonatomic ,copy)NSString *realIp;//真实ip
@property (nonatomic ,copy)NSString *userId;//用户id
@property (nonatomic ,copy)NSString *version;//版本号
@property (nonatomic ,copy)NSString *purchaseType;//01：消费  02：预授权.
@property (nonatomic ,copy)NSString *service_d;//服务类型

/**
    ************************
    进入支付模块时新加参数，我的钱包模块可不传
    ************************
 */
@property (nonatomic ,copy)NSString *currencyCode;//苹果支付支付币种
@property (nonatomic ,copy)NSString *BeeMall;//苹果支付 商家名字
@property (nonatomic ,copy)NSString *merchantid;//applePay支付需要配置的 merchantid
@property (nonatomic ,copy)NSString *txnAmt;//交易金额 分为单位
@property (nonatomic ,copy)NSString *txnCurr;//交易币种
@property (nonatomic ,copy)NSString *timeExpire;//订单有效时间 单位为分钟，最少为2分钟
@property (nonatomic ,copy)NSString *payTimeout;//订单支付超时时间
@property (nonatomic ,copy)NSString *txnTime;//交易发送时间
@property (nonatomic ,copy)NSString *notifyUrl;//异步通知地址 交易成功时通知的回调地址
@property (nonatomic ,copy)NSString *mcc;//商业行业类别 Mcc，微信支付宝时必填
@property (nonatomic ,copy)NSString *subject;//交易内容 交易商品，微信支付宝时必填
@property (nonatomic ,copy)NSString *referUrl;//首页地址 网站首页地址，当交易类型为支付宝时该参数必填
@property (nonatomic ,copy)NSString *subAppid;//子商户appId 微信必传，微信官方审核通过的appId
@property (nonatomic ,copy)NSString *desc;//订单描述
@end

NS_ASSUME_NONNULL_END
