//
//  ZDPay_AddBankCardSecondViewController.h
//  ReadingEarn
//
//  Created by FANS on 2020/4/15.
//  Copyright © 2020 FANS. All rights reserved.
//

#import "ZDPayRootViewController.h"
#import "ZDPay_AddBankModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface ZDPay_AddBankCardSecondViewController : ZDPayRootViewController

@property (nonatomic ,strong)ZDPay_AddBankModel *pay_AddBankModel;
@property (nonatomic ,strong)NSDictionary *cardInfo;
@end

NS_ASSUME_NONNULL_END
