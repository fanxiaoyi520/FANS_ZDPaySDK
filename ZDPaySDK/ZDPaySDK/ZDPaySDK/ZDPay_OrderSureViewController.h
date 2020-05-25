//
//  ZDPay_OrderSureViewController.h
//  ReadingEarn
//
//  Created by FANS on 2020/4/13.
//  Copyright © 2020 FANS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZDPayRootViewController.h"
#import "ZDPay_OrderSureModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^CompletionBlock) (NSDictionary *resultDic);
@interface ZDPay_OrderSureViewController : ZDPayRootViewController
@property (nonatomic ,copy)CompletionBlock completionBlock;
/**
客户端初始化方式
1.可以直接 alloc
2. [ZDPay_OrderSureViewController  manager]
 */

+ (instancetype)manager;

/**
    海外支付SDK回掉给客户端code及message的具体含义
    code 1000 支付成功
    code 2000 支付失败
    code 3000 支付取消
    code 5000 由商户主动发起交易状态查询
    code 9000 没有支付直接返回app端返回的code(按返回键)
 */
- (void)ZDPay_PaymentResultCallbackWithCompletionBlock:(void (^)(id _Nonnull responseObject))completionBlock;
/**
    用户端需要传递的参数，以公开的model文件属性赋值传递
 */
@property (nonatomic,strong)ZDPay_OrderSureModel *orderModel;

@end

NS_ASSUME_NONNULL_END
