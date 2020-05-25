//
//  ZDPay_OrderSureTableViewCell.h
//  ReadingEarn
//
//  Created by FANS on 2020/4/14.
//  Copyright © 2020 FANS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZDPay_OrderSurePayListRespModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZDPay_OrderSureTableViewCell : UITableViewCell

- (void)layoutAndLoadData:(ZDPay_OrderSurePayListRespModel *)model isImageSel:(BOOL)isImageSel;
@property (nonatomic ,strong)UIImageView *selectImageView;
@end

NS_ASSUME_NONNULL_END
