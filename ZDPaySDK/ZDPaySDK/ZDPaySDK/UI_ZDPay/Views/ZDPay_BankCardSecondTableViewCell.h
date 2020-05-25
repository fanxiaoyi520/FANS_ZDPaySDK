//
//  ZDPay_BankCardSecondTableViewCell.h
//  ReadingEarn
//
//  Created by FANS on 2020/4/15.
//  Copyright © 2020 FANS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZDPay_AddBankModel.h"

NS_ASSUME_NONNULL_BEGIN
typedef void (^SelDocumentTypeClick)(UIButton *_Nonnull sender);
typedef void (^AddBankCardTextField)(UITextField * _Nonnull textField);

@interface ZDPay_BankCardSecondTableViewCell : UITableViewCell
@property (nonatomic ,strong)UITextField *inputTextField;
@property (nonatomic ,copy)SelDocumentTypeClick selDocumentTypeClick;
@property (nonatomic ,copy)AddBankCardTextField addBankCardTextField;

- (void)layoutAndLoadData:(ZDPay_AddBankModel *)model myIndexPath:(NSIndexPath *)myIndexPath array:(NSArray *)array;
@end

NS_ASSUME_NONNULL_END
