//
//  ZDPay_MyWalletViewController.h
//  ReadingEarn
//
//  Created by FANS on 2020/4/16.
//  Copyright © 2020 FANS. All rights reserved.
//

#import "ZDPayRootViewController.h"
#import "ZDPay_OrderSureModel.h"

NS_ASSUME_NONNULL_BEGIN
typedef enum _WalletType {
    WalletType_Untying = 0,
    WalletType_binding  = 1,
}WalletType;

@interface ZDPay_MyWalletViewController : ZDPayRootViewController

#pragma - mark---- 内部区分参数 客户端不要调用
@property (nonatomic ,assign)WalletType walletType;
#pragma - mark---- 内部区分参数 客户端不要调用

/**
客户端初始化方式
1.可以直接 alloc
2. [ZDPay_OrderSureViewController  manager]
 */

+ (instancetype)manager;
/**
 客户端调用中道支付回调结果SDK接口
 1.paySucess:支付成功的回调
 2.payCancel:支付取消回调
 3.payFailure:支付失败回调
 */
- (void)ZDPay_WalletResultCallbackWithBindingResult:(void (^)(id _Nonnull responseObject))bindingResult
                                      untyingResult:(void (^)(id _Nonnull reason))untyingResult;
/**
    用户端需要传递的参数，以公开的model文件属性赋值传递
 */
@property (nonatomic,strong)ZDPay_OrderSureModel *orderModel;
@end

NS_ASSUME_NONNULL_END
