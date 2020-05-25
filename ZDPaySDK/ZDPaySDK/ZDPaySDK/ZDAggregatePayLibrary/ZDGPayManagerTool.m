//
//  ZDGPayManagerTool.m
//  AllPayDemo
//
//  Created by FANS on 2020/4/2.
//  Copyright © 2020 彭金光. All rights reserved.
//

#import "ZDGPayManagerTool.h"
#import "AlipayTool.h"
#import "WeiXinPayTool.h"
#import "UPPayTool.h"
#import "UPPaymentControl.h"
#import "ZDPayFuncTool.h"

@implementation ZDGPayManagerTool

+ (void)startPaymentWithPayMethod:(NSInteger)payMethod
               payParametersModel:(PayModel *)paymodel
                   viewController:(UIViewController*)viewController
                       PaySuccess:(PaySuccess)success
                        payCancel:(PayCancel)payCancel
                        PayFailed:(PayFailed)Failed {
    if (payMethod == WeiXin) {
        NSDictionary *dic = [paymodel mj_keyValues];
        [[WeiXinPayTool shareTool] PayWithPrograms:dic WeiXinPaySuccess:^{
            success(@"支付成功");
        } WeiXinPayFailed:^(WeixinPayErrorCode code) {
            NSString *str = [NSString stringWithFormat:@"%lu",(unsigned long)code];
            Failed(str);
        }];
    } else if (payMethod == Alipay) {
        NSString *str = [NSString stringWithFormat:@"%@",paymodel.goodsName];
        [[AlipaySDK defaultService] payOrder:str fromScheme:@"alisdkdemo" callback:^(NSDictionary *resultDic) {
        NSDictionary *aliDict    = resultDic;
                if ([aliDict[@"resultStatus"] isEqualToString:@"9000"]){
                    if (success) {
                        success(resultDic);
                    }
                }
                if ([aliDict[@"resultStatus"] isEqualToString:@"8000"]) {
                    if (Failed) {
                        payCancel(resultDic);
                    }
                }
                if ([aliDict[@"resultStatus"] isEqualToString:@"4000"]) {
                     if (Failed) {
                         Failed(resultDic);
                     }
                }
                if ([aliDict[@"resultStatus"] isEqualToString:@"6001"]) {
                     if (payCancel) {
                         payCancel(resultDic);
                     }
                }
                if ([aliDict[@"resultStatus"] isEqualToString:@"6002"]) {
                     if (Failed) {
                         Failed(resultDic);
                     }
                }
        }];
    } else if (payMethod == ApplePay) {
       [[UPPayTool shareTool] startApplePay:paymodel.apple_tn viewController:viewController ApplePayCallBack:^(UPPayResult *payResult) {
           if (payResult.paymentResultStatus == UPPaymentResultStatusSuccess) {
               success(payResult);
               return ;
           }
           
           if (payResult.paymentResultStatus == UPPaymentResultStatusFailure) {
               Failed(payResult);
               return;
           }
           if (payResult.paymentResultStatus == UPPaymentResultStatusCancel) {
               payCancel(payResult);
               return;
           }
           if (payResult.paymentResultStatus == UPPaymentResultStatusUnknownCancel) {
               payCancel(payResult);
               return;
           }
       }];
    } else if (payMethod == UPPay) {
       [[UPPayTool shareTool] startPay:paymodel.tn viewController:viewController SuccessBlock:^{
           success(@"支付成功");
       } FailedBlock:^(NSString *desc) {
            Failed(desc);
       }];
    } else {
        NSString *str = [NSString stringWithFormat:@"%@",[[ZDPayInternationalizationModel sharedSingleten] getModelData].The_correct_payment_method_is_not_passed_in_please_refer_to_the_document];
        Failed(str);
    }
}

@end
