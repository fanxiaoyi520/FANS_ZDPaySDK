//
//  AlipayTool.m
//  AllPayDemo
//
//  Created by JGPeng on 16/10/24.
//  Copyright © 2016年 彭金光. All rights reserved.
//

#import "AlipayTool.h"
#import "Order.h"
//#import "DataSigner.h"

@implementation AlipayTool

/**
 *  单类方法
 */
+ (instancetype)shareTool{
    
    static AlipayTool *_tool = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _tool = [[AlipayTool alloc]init];
    });
    return _tool;
}

#pragma mark - 调起支付宝支付
/**
 *  掉起支付宝支付
 *
 *  @param orderSn          订单号
 *  @param orderName        订单名称
 *  @param orderDescription 订单描述
 *  @param OrderPrice       订单价格 //于微信不同的是 0.01是1分
 *  @param success          成功回调
 *  @param Failed           失败回调
 */
- (void)sendAlipayWithOrderSn:(NSString *)orderSn
                    orderName:(NSString *)orderName
             orderDescription:(NSString *)orderDescription
                   orderPrice:(NSString *)OrderPrice
                 SuccessBlock:(AliPaySuccess)success
                  FailedBlock:(AliPayFailed)Failed{
    NSString *orderString    = nil;
    orderString              = @"";
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:@"" callback:^(NSDictionary *resultDic) {
    NSDictionary *aliDict    = resultDic;
            if ([aliDict[@"resultStatus"] isEqualToString:@"9000"]){
                if (success) {
                    success();
                }
            }
            if ([aliDict[@"resultStatus"] isEqualToString:@"8000"]) {
                if (Failed) {
                    Failed(@"正在处理中，请稍候查看结果！");
                }
            }
            if ([aliDict[@"resultStatus"] isEqualToString:@"4000"]) {
                 if (Failed) {
                Failed(@"订单支付失败！");
                 }
            }
            if ([aliDict[@"resultStatus"] isEqualToString:@"6001"]) {
                 if (Failed) {
                Failed(@"用户中途取消付款！");
                 }
            }
            if ([aliDict[@"resultStatus"] isEqualToString:@"6002"]) {
                 if (Failed) {
                Failed(@"网络连接出错！");
                 }
            }
        }];
}

/**
 *  掉起支付宝支付
 *
 *  @param orderSn          订单号
 *  @param orderName        订单名称
 *  @param orderDescription 订单描述
 *  @param OrderPrice       订单价格 //于微信不同的是 0.01是1分
 *  @param success          成功回调
 *  @param Failed           失败回调
 */
- (void)OutsideAlipayWithOrderSn:(NSString *)orderSn
                       orderName:(NSString *)orderName
                orderDescription:(NSString *)orderDescription
                      orderPrice:(NSString *)OrderPrice
                    SuccessBlock:(AliPaySuccess)success
                     FailedBlock:(AliPayFailed)Failed{
        NSString *orderString = nil;
        orderString              = @"";
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:@"" callback:^(NSDictionary *resultDic) {
            
            NSDictionary *aliDict    = resultDic;
            if ([aliDict[@"resultStatus"] isEqualToString:@"9000"]){
                if (success) {
                    success();
                }
            }
            if ([aliDict[@"resultStatus"] isEqualToString:@"8000"]) {
                if (Failed) {
                    Failed(@"正在处理中，请稍候查看结果！");
                }
            }
            if ([aliDict[@"resultStatus"] isEqualToString:@"4000"]) {
                if (Failed) {
                    Failed(@"订单支付失败！");
                }
            }
            if ([aliDict[@"resultStatus"] isEqualToString:@"6001"]) {
                if (Failed) {
                    Failed(@"用户中途取消付款！");
                }
            }
            if ([aliDict[@"resultStatus"] isEqualToString:@"6002"]) {
                if (Failed) {
                    Failed(@"网络连接出错！");
                }
            }
        }];
}



@end
