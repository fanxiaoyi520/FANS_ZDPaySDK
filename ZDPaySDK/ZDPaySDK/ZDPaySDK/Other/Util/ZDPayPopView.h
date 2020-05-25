//
//  ZDPayPopView.h
//  ReadingEarn
//
//  Created by FANS on 2020/4/15.
//  Copyright © 2020 FANS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
typedef enum _ZDPayPopViewEnum {
    SetPaymentPassword  = 0, //设置支付密码
    DocumentType  = 1, //证件类型
    CellPhoneAreaCode  = 2, //手机区号
    SelectPayMethod  = 3, //选择支付方式
    CreditCardInputdemonstration  = 4, //信用卡使用示范
} ZDPayPopViewEnum;

typedef void (^ZDSetPaymentPassword)(NSString *text, BOOL isFinished);
typedef void (^ZDForgetPassword)(void);
typedef void (^ZDDocumentType)(UIButton *sender);
typedef void (^ZDCellPhoneAreaCode)(UITableView *__nullable tableView,NSIndexPath *__nullable indexPath,NSString *__nullable text);
typedef void (^ZDSelectPayMethod)(UITableView *__nullable tableView,NSIndexPath *__nullable indexPath,id __nullable model);

@interface ZDPayPopView : UIView
@property (nonatomic ,copy)ZDSetPaymentPassword setPaymentPassword;
@property (nonatomic ,copy)ZDForgetPassword forgetPassword;
@property (nonatomic ,copy)ZDDocumentType documentType;
@property (nonatomic ,copy)ZDCellPhoneAreaCode cellPhoneAreaCode;
@property (nonatomic ,copy)ZDSelectPayMethod selectPayMethod;

+ (ZDPayPopView *)readingEarnPopupViewWithType:(ZDPayPopViewEnum)type;
/**
 设置支付密码
 */
- (void)showPopupViewWithData:(__nullable id)model
                      payPass:(void (^)(NSString *text, BOOL isFinished))payPass
                   forgetPass:(void (^)(void))forgetPass;

/**
证件类型
*/
- (void)showPopupViewWithData:(__nullable id)model
                       myCell:(UITableViewCell *)myCell
                 documentType:(void (^)(UIButton *sender))documentType;

/**
手机区号
*/
- (void)showPopupViewWithData:(__nullable id)model
                 phoneAreaCode:(void (^)(UITableView *__nullable tableView,NSIndexPath *__nullable indexPath,NSString *__nullable text))phoneAreaCode;
//选择支付方式
//- (void)showPopupViewWithData:(__nullable id)model
//              SelectPayMethod:(void (^)(UITableView *__nullable tableView,NSIndexPath *__nullable indexPath,id __nullable model))selectPayMethod;
- (void)showPopupViewWithData:(__nullable id)model
              SelectPayMethod:(void (^)(UITableView *__nullable tableView,NSIndexPath *__nullable indexPath,id __nullable model))selectPayMethod
         withPayListRespModel:(id __nullable)withPayListRespModel;
//信用卡使用示范
- (void)showPopupMakeViewWithData:(__nullable id)model;
- (void)closeThePopupView;

@end

NS_ASSUME_NONNULL_END
