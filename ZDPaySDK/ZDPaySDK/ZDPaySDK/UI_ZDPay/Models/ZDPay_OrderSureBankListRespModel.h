//
//  ZDPay_OrderSureBankListRespModel.h
//  ReadingEarn
//
//  Created by FANS on 2020/4/15.
//  Copyright © 2020 FANS. All rights reserved.
//

#import "ZDPayRootModel.h"
#import "ZDPay_OrderBankListTokenModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZDPay_OrderSureBankListRespModel : ZDPayRootModel

@property (nonatomic ,copy)NSString *isInputPwd;
@property (nonatomic ,copy)NSString *isSetPwd;
@property (nonatomic ,copy)NSString *isUser;
@property (nonatomic ,strong)NSArray<ZDPay_OrderBankListTokenModel *> *Token;
@property (nonatomic ,strong)ZDPay_OrderBankListTokenModel *TokenListModel;

@end

NS_ASSUME_NONNULL_END
