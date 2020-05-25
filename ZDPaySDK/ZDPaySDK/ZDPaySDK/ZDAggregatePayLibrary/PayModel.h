//
//  PayModel.h
//  AllPayDemo
//
//  Created by FANS on 2020/4/2.
//  Copyright © 2020 彭金光. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PayModel : NSObject

/**
    微信支付参数
 *  @param goodsName   支付现实的名称
 *  @param orderId     订单id
 *  @param goodPrice   商品价格
 */
@property (nonatomic ,copy)NSString *goodsName;
@property (nonatomic ,copy)NSString *orderId;
@property (nonatomic ,copy)NSString *goodPrice;


@property (nonatomic ,copy)NSString *timeStamp;
@property (nonatomic ,copy)NSString *partnerid;
@property (nonatomic ,copy)NSString *nonceStr;
@property (nonatomic ,copy)NSString *packageValue;
@property (nonatomic ,copy)NSString *paySign;
@property (nonatomic ,copy)NSString *prepayId;
@property (nonatomic ,copy)NSString *Appid;


/**
    支付宝支付参数
 *  @param orderSn          订单号
 *  @param orderName        订单名称
 *  @param orderDescription 订单描述
 *  @param OrderPrice       订单价格 //于微信不同的是 0.01是1分
 */
@property (nonatomic ,copy)NSString *orderSn;
@property (nonatomic ,copy)NSString *orderName;
@property (nonatomic ,copy)NSString *orderDescription;
@property (nonatomic ,copy)NSString *OrderPrice;




/**
    苹果支付参数
 *  @param tn             订单号
 *  @param mode           环境类型
 *  @param viewController 控制器
 */
@property (nonatomic ,copy)NSString *apple_tn;





/**
    银联支付参数
 *  @param tn             订单信息
 *  @param schemeStr      调用支付的app注册在info.plist中的scheme
 *  @param viewController 掉起的控制器
 */
@property (nonatomic ,copy)NSString *tn;

@end

NS_ASSUME_NONNULL_END
