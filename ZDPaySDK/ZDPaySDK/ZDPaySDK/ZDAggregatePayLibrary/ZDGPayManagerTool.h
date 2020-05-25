//
//  ZDGPayManagerTool.h
//  AllPayDemo
//
//  Created by FANS on 2020/4/2.
//  Copyright © 2020 彭金光. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "PayModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, PayMethod) {
    
    WeiXin = 0,         //微信支付
    Alipay = 1,         //支付宝支付
    ApplePay = 2,       //苹果支付
    UPPay = 3,          //银联支付
};

/**
 *  支付成功回调
 */
typedef void (^PaySuccess)(id responseObject);

/**
 *  支付失败回调
 */
typedef void (^PayFailed)(id desc);
/**
 *  支付取消回调
 */
typedef void (^PayCancel)(id desc);
@interface ZDGPayManagerTool : NSObject


@property (nonatomic ,strong)PayModel *payModel;
/**************************** 支付  ******************************/

/**
 *  掉起支付
 *
 *  @param payMethod            支付方式
 *  @param paymodel              支付需要传递的参数
 *  @param vc                           调起支付接口的控制器
 *  @param success                成功回调
 *  @param payCancel            取消回调
 *  @param Failed                  失败回调
 */
+ (void)startPaymentWithPayMethod:(NSInteger)payMethod
               payParametersModel:(PayModel *)paymodel
                   viewController:(UIViewController*)viewController
                       PaySuccess:(PaySuccess)success
                        payCancel:(PayCancel)payCancel
                        PayFailed:(PayFailed)Failed;
@end

NS_ASSUME_NONNULL_END
