//
//  ZDPay_SetConfirPasswordViewController.h
//  ZDPaySDK
//
//  Created by FANS on 2020/4/23.
//  Copyright © 2020 ZhongDaoGroup. All rights reserved.
//

#import "ZDPayRootViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZDPay_SetConfirPasswordViewController : ZDPayRootViewController

@property (nonatomic ,assign)BOOL isSurePass;
@property (nonatomic ,copy)NSString *showTips;

@property (nonatomic ,assign)BOOL isFirstSetPassword;
@property (nonatomic ,copy)NSString *reToken;
@property (nonatomic ,copy)NSString *codeString;
@end

NS_ASSUME_NONNULL_END
