//
//  ZDPay_MywalletTableViewCell.h
//  ReadingEarn
//
//  Created by FANS on 2020/4/16.
//  Copyright © 2020 FANS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZDPay_OrderBankListTokenModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZDPay_MywalletTableViewCell : UITableViewCell

- (void)layoutAndLoadData:(ZDPay_OrderBankListTokenModel * __nullable)model;
@end

NS_ASSUME_NONNULL_END
