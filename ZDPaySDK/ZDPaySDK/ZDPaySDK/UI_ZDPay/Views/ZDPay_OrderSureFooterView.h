//
//  ZDPay_OrderSureFooterView.h
//  ReadingEarn
//
//  Created by FANS on 2020/4/14.
//  Copyright © 2020 FANS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZDPay_OrderSureModel.h"

NS_ASSUME_NONNULL_BEGIN
typedef void (^SurePay)(UIButton *sender);
typedef void (^SelProxy)(UIButton *sender);
@interface ZDPay_OrderSureFooterView : UITableViewHeaderFooterView

@property (nonatomic ,copy)SurePay surePay;
@property (nonatomic ,copy)SelProxy selProxy;

- (void)layoutAndLoadData:(ZDPay_OrderSureModel *)model
                  surePay:(void(^)(UIButton *sender))surePay
                 selProxy:(void(^)(UIButton *sender))selProxy;
@end

NS_ASSUME_NONNULL_END
