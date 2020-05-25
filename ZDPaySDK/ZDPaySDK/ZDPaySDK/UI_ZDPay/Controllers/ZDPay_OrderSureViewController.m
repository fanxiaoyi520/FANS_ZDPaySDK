//
//  ZDPay_OrderSureViewController.m
//  ReadingEarn
//
//  Created by FANS on 2020/4/13.
//  Copyright © 2020 FANS. All rights reserved.
//

#import "ZDPay_OrderSureViewController.h"
#import "ZDGPayManagerTool.h"
#import "PayModel.h"
#import "ZDPay_OrderSureHeaderView.h"
#import "ZDPay_OrderSureFooterView.h"
#import "ZDPay_OrderSureTableViewCell.h"
#import "ZDPayFuncTool.h"
#import "ZDPayNetRequestManager.h"
#import "ZDPay_MyWalletViewController.h"
#import "ZD_PayForgetPasswordViewController.h"
#import "ZDPay_AddBankCardViewController.h"
#import "ZDPay_SecurityVerificationSecondViewController.h"

#import "ZDPay_OrderSureRespModel.h"
#import "ZDPay_OrderSureBankListRespModel.h"
#import "ZDPay_OrderSurePayListRespModel.h"
#import "ZDPay_OrderSurePayListRespModel.h"
#import <WebKit/WebKit.h>
#import "AlipayTool.h"
#import "WXApi.h"

@interface ZDPay_OrderSureViewController()<UITableViewDelegate,UITableViewDataSource,WKUIDelegate,WKNavigationDelegate,PKPaymentAuthorizationViewControllerDelegate>

@property (nonatomic ,strong)UITableView *payTableView;
@property (nonatomic ,strong)ZDPay_OrderSureHeaderView *headerView;
@property (nonatomic ,strong)ZDPay_OrderSureFooterView *footerView;
@property (nonatomic ,strong)ZDPay_OrderSureModel *pay_OrderSureModel;
@property (nonatomic ,strong)ZDPay_OrderSureRespModel *pay_OrderSureRespModel;
@property (nonatomic ,strong)ZDPay_OrderSurePayListRespModel *pay_OrderSurePayListRespModel;
@property (nonatomic ,strong)NSMutableArray *bankDataList;
@property (nonatomic ,strong)NSMutableArray *payDataList;
@property (nonatomic ,strong)NSMutableArray *bankPointDataList;
@property (nonatomic ,strong)NSMutableArray *payPointDataList;
@property (nonatomic ,assign)BOOL isSelProxy;
@property (nonatomic ,copy)NSString *password;
@property (nonatomic ,strong)NSIndexPath *oldIndexPath;
@property (nonatomic ,strong)ZDPay_OrderSureTableViewCell *oldCell;
@property (nonatomic ,assign)BOOL isImageSel;
@end

@implementation ZDPay_OrderSureViewController
+ (instancetype)manager {
    return [[[self class] alloc] init];
}

- (void)ZDPay_PaymentResultCallbackWithCompletionBlock:(void (^)(id _Nonnull responseObject))completionBlock {
    self.completionBlock = completionBlock;
}

//移除通知
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setUpPayPassword:(NSNotification *)noti {
    [self.payTableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
    [self getDataFromNetWorkingOrderSure:YES];
    [self showMessage:[[ZDPayInternationalizationModel sharedSingleten] getModelData].PASSWORD_WAS_SUCCESSFULLY_CREATED target:nil];
}

- (void)bindBankCardSucceeded:(NSNotification *)noti {
    [self.payTableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
    [self getDataFromNetWorkingOrderSure:YES];
    [self showMessage:[[ZDPayInternationalizationModel sharedSingleten] getModelData].BIND_SUCCESSFULLY target:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isImageSel = 0;
    self.view.backgroundColor = COLORWITHHEXSTRING(@"#F3F3F5",1.0);
    @WeakObj(self);
    self.topNavBar.backBlock = ^{
        @StrongObj(self)
        NSMutableDictionary *mutableDic = [ZDPayFuncTool getPayResultDicToClientWithCode:@"9000" withData:@"" withMessage:@"支付取消"];
        self.completionBlock(mutableDic);
        [self.navigationController popViewControllerAnimated:YES];
    };
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setUpPayPassword:) name:SETUPPAYMENTFEED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bindBankCardSucceeded:) name:BINDBANKCARDSUCCEEDED object:nil];

    self.isSelProxy = YES;
    
    [self getDataFromNetWorkingAppInternationalization];
    //[self getDataFromNetWorkingOrderSure];
}

#pragma mark - lazy loading
- (UITableView *)payTableView {
    if (!_payTableView) {
        _payTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _payTableView.showsVerticalScrollIndicator = NO;
        _payTableView.showsHorizontalScrollIndicator = NO;
        _payTableView.backgroundView = nil;
        _payTableView.backgroundColor = [UIColor clearColor];
        _payTableView.bounces = NO;
        _payTableView.scrollEnabled = YES;
        _payTableView.frame = CGRectMake(10 ,mcNavBarAndStatusBarHeight, ZDScreen_Width-20,ZDScreen_Height - mcNavBarAndStatusBarHeight);
        _payTableView.delegate = self;
        _payTableView.dataSource = self;
        [self.view addSubview:_payTableView];
        
        ZDPay_OrderSureHeaderView *headerView = [ZDPay_OrderSureHeaderView new];
        headerView.backgroundColor = COLORWITHHEXSTRING(@"#F3F3F5", 1.0);
        headerView.frame = CGRectMake(0, 0, ZDScreen_Width, 133);
        _payTableView.tableHeaderView = headerView;
        self.headerView = headerView;
        
        ZDPay_OrderSureFooterView *footerView = [ZDPay_OrderSureFooterView new];
        footerView.backgroundColor = COLORWITHHEXSTRING(@"#F3F3F5", 1.0);
        _payTableView.tableFooterView = footerView;
        footerView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight- mcNavBarAndStatusBarHeight - _payTableView.tableFooterView.origin.y);
        self.footerView = footerView;
//        footerView.frame = CGRectMake(0, ScreenHeight-100, ScreenWidth, 100);
//        [self.view addSubview:footerView];
    }
    return _payTableView;
}

- (NSMutableArray *)payDataList {
    if (!_payDataList) {
        _payDataList = [NSMutableArray array];
    }
    return _payDataList;
}

- (NSMutableArray *)bankDataList {
    if (!_bankDataList) {
        _bankDataList = [NSMutableArray array];
    }
    return _bankDataList;
}

- (NSMutableArray *)payPointDataList {
    if (!_payPointDataList) {
        _payPointDataList = [NSMutableArray array];
    }
    return _payPointDataList;
}

- (NSMutableArray *)bankPointDataList {
    if (!_bankPointDataList) {
        _bankPointDataList = [NSMutableArray array];
    }
    return _bankPointDataList;
}

#pragma mark - tableview delegate and datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        if (self.bankDataList) {
            return self.bankPointDataList.count + 2;
        }
        return 2;
    } else {
        if (self.payDataList) {
            if (self.payPointDataList.count>2) {
                return self.payPointDataList.count;
            }
            return self.payPointDataList.count + 1;
        }
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellid = @"cellid";
    ZDPay_OrderSureTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (!cell) {
        cell = [[ZDPay_OrderSureTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = COLORWITHHEXSTRING(@"#FFFFFF", 1.0);

        UIView *lineView = [UIView new];
        [cell.contentView addSubview:lineView];
        lineView.backgroundColor = COLORWITHHEXSTRING(@"#DCDCDC", 1.0);
        lineView.tag = 30;
        
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                UILabel *label = [UILabel new];
                label.tag = 100;
                [cell.contentView addSubview:label];
                label.font = [UIFont boldSystemFontOfSize:16];
                label.textColor = COLORWITHHEXSTRING(@"#333333", 1.0);
            }
            if (indexPath.row == self.bankPointDataList.count+1) {
                UILabel *label = [UILabel new];
                [cell.contentView addSubview:label];
                label.tag = 200;
                label.font = ZD_Fout_Medium(14);
                label.textColor = COLORWITHHEXSTRING(@"#999999", 1.0);
            }
        } else {
            if (self.payPointDataList.count < 3) {
                if (indexPath.row == self.payPointDataList.count) {
                    UILabel *label = [UILabel new];
                    [cell.contentView addSubview:label];
                    label.tag = 200;
                    label.font = ZD_Fout_Medium(14);
                    label.textColor = COLORWITHHEXSTRING(@"#999999", 1.0);
                }
            }
        }
    }
    
    UIView *lineView = (UIView *)[cell.contentView viewWithTag:30];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            CGRect rect = [ZDPayFuncTool getStringWidthAndHeightWithStr:[[ZDPayInternationalizationModel sharedSingleten] getModelData].PAY_BY_UNIONPAY_CARD withFont:[UIFont boldSystemFontOfSize:16]];
            UILabel *label = [cell.contentView viewWithTag:100];
            label.frame = CGRectMake(20, 16, rect.size.width, 16);
            label.text = [[ZDPayInternationalizationModel sharedSingleten] getModelData].PAY_BY_UNIONPAY_CARD;
            lineView.frame = CGRectMake(0, 49-.5, self.payTableView.width, .5);
        }
        
        if (indexPath.row == self.bankPointDataList.count+1) {
            NSString *SWITCH_UNIONPAY_CARD = [NSString stringWithFormat:@"%@ >",[[ZDPayInternationalizationModel sharedSingleten] getModelData].SWITCH_UNIONPAY_CARD];
            CGRect rect = [ZDPayFuncTool getStringWidthAndHeightWithStr:SWITCH_UNIONPAY_CARD withFont:ZD_Fout_Medium(14)];
            UILabel *label = [cell.contentView viewWithTag:200];
            label.frame = CGRectMake(48, 19, rect.size.width, 14);
            label.text = SWITCH_UNIONPAY_CARD;
        }
        
        if (indexPath.row > 0 && indexPath.row <= self.bankPointDataList.count) {
            lineView.frame = CGRectMake(20, 49-.5, self.payTableView.width-20, .5);
            [cell layoutAndLoadData:self.bankPointDataList[indexPath.row-1] isImageSel:self.isImageSel];
            self.isImageSel = 0;
        }
    }
    
    if (indexPath.section == 1){
        if (self.payPointDataList.count < 3) {
            if (indexPath.row == self.payPointDataList.count) {
                NSString *SWITCH_UNIONPAY_CARD = [NSString stringWithFormat:@"%@ >",[[ZDPayInternationalizationModel sharedSingleten] getModelData].AND_MORE_PAYMENT_METHODS];
                CGRect rect = [ZDPayFuncTool getStringWidthAndHeightWithStr:SWITCH_UNIONPAY_CARD withFont:ZD_Fout_Medium(14)];
                UILabel *label = [cell.contentView viewWithTag:200];
                label.frame = CGRectMake(48, 19, rect.size.width, 14);
                label.text = SWITCH_UNIONPAY_CARD;
            }
            
            if (indexPath.row >= 0 && indexPath.row < self.payPointDataList.count) {
                lineView.frame = CGRectMake(20, 49-.5, self.payTableView.width-20, .5);
                [cell layoutAndLoadData:self.payPointDataList[indexPath.row] isImageSel:self.isImageSel];
            }
        } else {
            lineView.frame = CGRectMake(20, 49-.5, self.payTableView.width-20, .5);
            [cell layoutAndLoadData:self.payPointDataList[indexPath.row] isImageSel:self.isImageSel];
        }
    }

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 49;
}

//cell每组第一和最后一个单元格切圆角
- (void)tableView:(UITableView *)tableView willDisplayCell:(nonnull UITableViewCell *)cell forRowAtIndexPath:(nonnull NSIndexPath *)indexPath {

    CGFloat radius = 6.f;
    cell.backgroundColor = UIColor.clearColor;
    CAShapeLayer *normalLayer = [[CAShapeLayer alloc] init];
    CAShapeLayer *selectLayer = [[CAShapeLayer alloc] init];
    CGRect bounds = CGRectInset(cell.bounds, 0, 0);
    NSInteger rowNum = [tableView numberOfRowsInSection:indexPath.section];
    UIBezierPath *bezierPath = nil;
    if (rowNum == 1) {
        bezierPath = [UIBezierPath bezierPathWithRoundedRect:bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(radius, radius)];
    }else{
        if (indexPath.row == 0) {
            bezierPath = [UIBezierPath bezierPathWithRoundedRect:bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(radius, radius)];
        }else if (indexPath.row == rowNum - 1){
            bezierPath = [UIBezierPath bezierPathWithRoundedRect:bounds byRoundingCorners:UIRectCornerBottomLeft|UIRectCornerBottomRight cornerRadii:CGSizeMake(radius, radius)];
        }else{
            bezierPath = [UIBezierPath bezierPathWithRect:bounds];
        }
    }
     normalLayer.path = bezierPath.CGPath;
     selectLayer.path = bezierPath.CGPath;
        
     UIView *nomarBgView = [[UIView alloc] initWithFrame:bounds];
     normalLayer.fillColor = [[UIColor whiteColor] CGColor];
     [nomarBgView.layer insertSublayer:normalLayer atIndex:0];
     nomarBgView.backgroundColor = UIColor.clearColor;
     cell.backgroundView = nomarBgView;

    UIView *selectBgView = [[UIView alloc] initWithFrame:bounds];
     selectLayer.fillColor = [[UIColor whiteColor] CGColor];
     [selectBgView.layer insertSublayer:selectLayer atIndex:0];
     selectBgView.backgroundColor = UIColor.clearColor;
     cell.selectedBackgroundView = selectBgView;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    ZDPay_OrderSureModel *model = [[ZDPay_OrderSureModel sharedSingleten] getModelData];
    [self.headerView layoutAndLoadData:model];
    UIView *view = [UIView new];
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    ZDPay_OrderSureModel *model = [[ZDPay_OrderSureModel sharedSingleten] getModelData];
    [self.footerView layoutAndLoadData:model surePay:^(UIButton * _Nonnull sender) {

        if (self.pay_OrderSurePayListRespModel.channelCode) {
            if ([self.pay_OrderSurePayListRespModel.channelCode isEqualToString:@""]) {
                [self UNIONPAY];
                return ;
            }
            
            if (([self.pay_OrderSurePayListRespModel.channelCode isEqualToString:@"APPLEPAY"])) {
                [self APPLEPAY];
                return ;
            }
            
            //其他
            [self getDataFromNetWorkingPutPay];
            /**
            if (self.isSelProxy == YES) {
                if ([self.pay_OrderSurePayListRespModel.channelCode isEqualToString:@""]) {
                    [self UNIONPAY];
                    return ;
                }
                
                if (([self.pay_OrderSurePayListRespModel.channelCode isEqualToString:@"APPLEPAY"])) {
                    [self APPLEPAY];
                    return ;
                }
                
                //其他
                [self getDataFromNetWorkingPutPay];
            } else {
                [self showMessage:[[ZDPayInternationalizationModel sharedSingleten] getModelData].PLS_READ_AND_AGREE_TO_THE_PAYMENT_AGREEMENT_BEFORE_INITIATING_PAYMENT target:nil];
            }
             */
        } else {
            [self showMessage:[[ZDPayInternationalizationModel sharedSingleten] getModelData].PLEASE_SELECT_PAYMENT_METHOD target:nil];
        }
    } selProxy:^(UIButton * _Nonnull sender) {
        self.isSelProxy = !sender.selected;
    }];

    UIView *view = [UIView new];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 12;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row > 0 && indexPath.row < self.bankPointDataList.count+1) {
            
            //记录选择支付方式对应数据
            ZDPay_OrderSurePayListRespModel *model = self.bankPointDataList[indexPath.row-1];
            NSDictionary *dic = [model mj_keyValues];
            [[ZDPay_OrderSurePayListRespModel sharedSingleten] setModelProcessingDic:dic];

            //获取上一个cell，改变选择支付方式图标
            if (self.oldIndexPath) {
                self.oldCell = (ZDPay_OrderSureTableViewCell *)[tableView cellForRowAtIndexPath:self.oldIndexPath];
                self.oldCell.selectImageView.image = [UIImage imageNamed:@"btn_unch"];
            }
            
            ZDPay_OrderSureTableViewCell *cell = (ZDPay_OrderSureTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
            cell.selectImageView.image = [UIImage imageNamed:@"btn_choose"];
            self.oldIndexPath = indexPath;
            
            self.pay_OrderSurePayListRespModel = self.bankPointDataList[indexPath.row-1];
        }
        
        if (indexPath.row == self.bankPointDataList.count+1) {
            
            ZDPayPopView *popView = [ZDPayPopView readingEarnPopupViewWithType:SelectPayMethod];
            [popView showPopupViewWithData:self.bankDataList SelectPayMethod:^(UITableView * _Nullable tableView, NSIndexPath * _Nullable myIndexPath, id  _Nullable model) {

                if ([model isKindOfClass:[NSString class]]) {
                    ZDPay_OrderSureRespModel *respModel = [[ZDPay_OrderSureRespModel sharedSingleten] getModelData];
                    ZDPay_OrderSureBankListRespModel *bankModel = [[ZDPay_OrderSureRespModel sharedSingleten] getModelData].bankList;
                    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                    [userDefaults setObject:bankModel.isSetPwd forKey:@"shezhimima"];
                    [userDefaults synchronize];
                    
                    if ([bankModel isKindOfClass:[ZDPay_OrderSureBankListRespModel class]]) {
                        if ([bankModel.isSetPwd isEqualToString:@"0"] && [respModel.isUser isEqualToString:@"0"]) {
                            ZDPay_SecurityVerificationSecondViewController *vc = [ZDPay_SecurityVerificationSecondViewController new];
                            [self.navigationController pushViewController:vc animated:YES];
                        } else {
                            ZDPay_AddBankCardViewController *vc = [ZDPay_AddBankCardViewController new];
                            [self.navigationController pushViewController:vc animated:YES];
                        }
                    } else {
                        if ([respModel.isUser isEqualToString:@"0"]) {
                             ZDPay_SecurityVerificationSecondViewController *vc = [ZDPay_SecurityVerificationSecondViewController new];
                             [self.navigationController pushViewController:vc animated:YES];
                         } else {
                             ZDPay_AddBankCardViewController *vc = [ZDPay_AddBankCardViewController new];
                             [self.navigationController pushViewController:vc animated:YES];
                         }
                    }
                } else {
                    self.isImageSel = 1;
                    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                    dispatch_async(queue, ^{
                        self.pay_OrderSurePayListRespModel = (ZDPay_OrderSurePayListRespModel *)model;
                        [self.bankPointDataList removeAllObjects];
                        [self.bankPointDataList addObject:(ZDPay_OrderSurePayListRespModel *)model];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self.payTableView reloadData];
                        });
                    });

                }
            } withPayListRespModel:self.pay_OrderSurePayListRespModel];
        }
    }
    
    if (indexPath.section == 1) {

        if (indexPath.row >= 0 && indexPath.row < self.payPointDataList.count) {

            //记录选择支付方式对应数据
            ZDPay_OrderSurePayListRespModel *model = self.payPointDataList[indexPath.row];
            NSDictionary *dic = [model mj_keyValues];
            [[ZDPay_OrderSurePayListRespModel sharedSingleten] setModelProcessingDic:dic];

            //获取上一个cell，改变选择支付方式图标
            if (self.oldIndexPath) {
                self.oldCell = (ZDPay_OrderSureTableViewCell *)[tableView cellForRowAtIndexPath:self.oldIndexPath];
                self.oldCell.selectImageView.image = [UIImage imageNamed:@"btn_unch"];
            }
            
            ZDPay_OrderSureTableViewCell *cell = (ZDPay_OrderSureTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
            cell.selectImageView.image = [UIImage imageNamed:@"btn_choose"];
            self.oldIndexPath = indexPath;
            
            NSIndexPath *insetPath = [NSIndexPath indexPathForRow:1 inSection:0];
            ZDPay_OrderSureTableViewCell *cell1 = (ZDPay_OrderSureTableViewCell *)[self.payTableView cellForRowAtIndexPath:insetPath];
            cell1.selectImageView.image = [UIImage imageNamed:@"btn_unch"];
            
            //获取选中支付方式，在确认支付时传递的参数
            self.pay_OrderSurePayListRespModel = self.payPointDataList[indexPath.row];
        }
            
        if (indexPath.row == self.payPointDataList.count) {
            [self.payPointDataList removeAllObjects];
            [self.payPointDataList addObjectsFromArray:self.payDataList];
            [tableView reloadData];
        }
    }
}

#pragma mark - 支付业务处理
- (void)UNIONPAY {
    ZDPayPopView *popView = [ZDPayPopView readingEarnPopupViewWithType:0];
    [popView showPopupViewWithData:self.pay_OrderSurePayListRespModel payPass:^(NSString * _Nonnull text, BOOL isFinished) {
        self.password = text;
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:self.password forKey:@"password"];
        [userDefaults synchronize];
        
        if (isFinished) {
            [popView closeThePopupView];
            [self getDataFromNetWorkingSurePayPassword];
        }
    } forgetPass:^{
        [popView closeThePopupView];
        ZD_PayForgetPasswordViewController *vc = [ZD_PayForgetPasswordViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    }];
}

- (void)APPLEPAY {
    if (![PKPaymentAuthorizationViewController canMakePayments]) return;
    if (@available(iOS 9.2, *)) {
        if (![PKPaymentAuthorizationViewController canMakePaymentsUsingNetworks:
              @[PKPaymentNetworkVisa,PKPaymentNetworkChinaUnionPay,PKPaymentNetworkDiscover]]) {
            //进入设置银行卡界面
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.3) {
                PKPassLibrary *library = [[PKPassLibrary alloc] init];
                [library openPaymentSetup];
            } else {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"shoebox://"]];
            }
            return;
        }
    } else {
        // Fallback on earlier versions
        if (![PKPaymentAuthorizationViewController canMakePaymentsUsingNetworks:@[PKPaymentNetworkVisa,PKPaymentNetworkDiscover]]) {
            //进入设置银行卡界面
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.3) {
                PKPassLibrary *library = [[PKPassLibrary alloc] init];
                [library openPaymentSetup];
            } else {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"shoebox://"]];
            }
            return;
        }
    }
    
    NSDictionary *dic = [[ZDPayFuncTool sharedSingleton] getApplePayDictionary];

    //最后，则创建支付请求
    PKPaymentRequest *request = [PKPaymentRequest new];
    request.merchantIdentifier = [dic objectForKey:@"merchantid"];
    request.countryCode = [dic objectForKey:@"countryCode"];
    request.currencyCode = [dic objectForKey:@"currencyCode"];
    request.merchantCapabilities = PKMerchantCapabilityCredit|PKMerchantCapabilityDebit|PKMerchantCapability3DS|PKMerchantCapabilityEMV; //3DS支付方式是必须支持的，其他方式可选
    if (@available(iOS 9.2, *)) {
        request.supportedNetworks = @[PKPaymentNetworkChinaUnionPay, PKPaymentNetworkVisa, PKPaymentNetworkMasterCard, PKPaymentNetworkDiscover];
    } else {
        // Fallback on earlier versions
        request.supportedNetworks = @[PKPaymentNetworkVisa, PKPaymentNetworkMasterCard, PKPaymentNetworkDiscover];
    }
    request.shippingType = PKShippingTypeShipping;
    NSDecimalNumber *threemAmout = [NSDecimalNumber decimalNumberWithString:[ZDPayFuncTool formatToTwoDecimal:[dic objectForKey:@"txnAmt"]]];
    NSDecimalNumber *itemTotal = [NSDecimalNumber zero];
    itemTotal = [itemTotal decimalNumberByAdding:threemAmout];
    PKPaymentSummaryItem *itemSum = [PKPaymentSummaryItem summaryItemWithLabel:[[ZDPay_OrderSureModel sharedSingleten] getModelData].BeeMall amount:itemTotal];

    request.paymentSummaryItems = @[itemSum];
    PKPaymentAuthorizationViewController *paymentVC = [[PKPaymentAuthorizationViewController alloc] initWithPaymentRequest:request];
    paymentVC.delegate = self;
    if (!paymentVC) return;
    [self presentViewController:paymentVC animated:YES completion:^{
    }];
}

/**
 *  支付的时候回调
 */
#pragma mark - PKPaymentAuthorizationViewControllerDelegate
- (void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller
                       didAuthorizePayment:(PKPayment *)payment
                                   handler:(void (^)(PKPaymentAuthorizationResult * _Nonnull ))completion  API_AVAILABLE(ios(11.0)){
    if (payment){
        NSData * paymentData = payment.token.paymentData;
        NSError * error = nil ;
        NSDictionary *dics = [NSJSONSerialization JSONObjectWithData:paymentData
                                                            options:NSJSONReadingMutableContainers
                                                              error:&error];
        completion(PKPaymentAuthorizationStatusSuccess);
        PKPaymentToken *payToken = payment.token;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSDictionary *dic = [[ZDPayFuncTool sharedSingleton] getApplePayDictionary];
            NSMutableDictionary *mutableDic = [NSMutableDictionary dictionary];
            [mutableDic setObject:dic forKey:@"paymentData"];
            [mutableDic addEntriesFromDictionary:dic];
            if (dics) {
                NSData *data=[NSJSONSerialization dataWithJSONObject:dics options:NSJSONWritingPrettyPrinted error:nil];
                NSString *jsonStr=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                [mutableDic setObject:jsonStr forKey:@"paymentData"];
            }
            [[ZDPayNetRequestManager sharedSingleton] zd_netRequestVC:self Params:mutableDic postUrlStr:[NSString stringWithFormat:@"%@%@",DOMAINNAME,PAYMENT] suscess:^(id  _Nullable responseObject) {
                NSMutableDictionary *dic = [ZDPayFuncTool getPayResultDicToClientWithCode:@"1000" withData:[responseObject objectForKey:@"data"] withMessage:@"支付成功"];
                self.completionBlock(dic);
            }];
        });
    }
}

- (void)paymentAuthorizationViewControllerDidFinish:(PKPaymentAuthorizationViewController *)controller {
    
    //支付页面关闭
    //点击支付/取消按钮调用该代理方法
    [controller dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - get data
- (void)getDataFromNetWorkingOrderSure:(BOOL)isRefresh {
    if (isRefresh == YES) {
        [self.payDataList removeAllObjects];
        [self.payPointDataList removeAllObjects];
        [self.bankDataList removeAllObjects];
        [self.bankPointDataList removeAllObjects];
    }
    NSDictionary *paramsDic = [self.orderModel mj_keyValues];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic addEntriesFromDictionary:paramsDic];
    [dic setValue:self.orderModel.txnAmt forKey:@"amount"];
    [[ZDPayNetRequestManager sharedSingleton] zd_netRequestVC:self Params:dic postUrlStr:[NSString stringWithFormat:@"%@%@",DOMAINNAME,QUERYPAYMETHOD] suscess:^(id  _Nullable responseObject) {
        if ([[responseObject objectForKey:@"code"] isEqualToString:@"200"]) {
            ZDPay_OrderSureRespModel *model = [ZDPay_OrderSureRespModel mj_objectWithKeyValues:[responseObject objectForKey:@"data"]];
            [[ZDPay_OrderSureRespModel sharedSingleten] setModelProcessingDic:[responseObject objectForKey:@"data"]];
            self.pay_OrderSureRespModel = model;
            if (![self.pay_OrderSureRespModel.bankList isKindOfClass:[NSString class]]) {
                [self.pay_OrderSureRespModel.bankList.Token enumerateObjectsUsingBlock:^(ZDPay_OrderBankListTokenModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    
                    ZDPay_OrderSurePayListRespModel *model = [ZDPay_OrderSurePayListRespModel mj_objectWithKeyValues:obj];
                    [self.bankDataList addObject:model];
                }];
                if (self.bankDataList.count > 0) {
                    [self.bankPointDataList addObject:self.bankDataList[0]];
                }
            }
            
            if ([self.pay_OrderSureRespModel.payList isKindOfClass:[NSArray class]]) {
                [self.pay_OrderSureRespModel.payList enumerateObjectsUsingBlock:^(ZDPay_OrderSurePayListRespModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    ZDPay_OrderSurePayListRespModel *model = [ZDPay_OrderSurePayListRespModel mj_objectWithKeyValues:obj];
                    if (![model.channelCode isEqualToString:@"UNIONPAY"]) {
                        [self.payDataList addObject:model];
                    }
                }];
                if (self.payDataList.count > 2) {
                    [self.payPointDataList addObject:self.payDataList[0]];
                    [self.payPointDataList addObject:self.payDataList[1]];
                } else {
                    [self.payPointDataList addObjectsFromArray:self.payDataList];
                }
            }
            if (isRefresh == YES) {
                [self.payTableView reloadData];
            } else {
                [self payTableView];
            }
        }
    }];
}

- (void)getDataFromNetWorkingOrderSureRefresh {
    [self.payDataList removeAllObjects];
    ZDPay_OrderSureModel *model = [[ZDPay_OrderSureModel sharedSingleten] getModelData];
    NSDictionary *paramsDic = [model mj_keyValues];
    [[ZDPayNetRequestManager sharedSingleton] zd_netRequestVC:self Params:paramsDic postUrlStr:[NSString stringWithFormat:@"%@%@",DOMAINNAME,QUERYPAYMETHOD] suscess:^(id  _Nullable responseObject) {
        if ([[responseObject objectForKey:@"code"] isEqualToString:@"200"]) {
            ZDPay_OrderSureRespModel *model = [ZDPay_OrderSureRespModel mj_objectWithKeyValues:[responseObject objectForKey:@"data"]];
            [[ZDPay_OrderSureRespModel sharedSingleten] setModelProcessingDic:[responseObject objectForKey:@"data"]];
            self.pay_OrderSureRespModel = model;
            if (self.pay_OrderSureRespModel.bankList.Token) {
                [self.pay_OrderSureRespModel.bankList.Token enumerateObjectsUsingBlock:^(ZDPay_OrderBankListTokenModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    ZDPay_OrderSurePayListRespModel *model = [ZDPay_OrderSurePayListRespModel mj_objectWithKeyValues:obj];
                    [self.bankDataList addObject:model];
                }];
                
                if (self.bankDataList.count > 0) {
                    [self.bankPointDataList addObject:self.bankDataList[0]];
                }
            }
            if ([self.pay_OrderSureRespModel.payList isKindOfClass:[NSArray class]]) {
                [self.pay_OrderSureRespModel.payList enumerateObjectsUsingBlock:^(ZDPay_OrderSurePayListRespModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    ZDPay_OrderSurePayListRespModel *model = [ZDPay_OrderSurePayListRespModel mj_objectWithKeyValues:obj];
                    if (![model.channelCode isEqualToString:@"UNIONPAY"]) {
                        [self.payDataList addObject:model];
                    }
                }];
                if (self.payDataList.count > 2) {
                    [self.payPointDataList addObject:self.payDataList[0]];
                    [self.payPointDataList addObject:self.payDataList[1]];
                } else {
                    [self.payPointDataList addObjectsFromArray:self.payDataList];
                }
            }
            [self.payTableView reloadData];
        }
    }];
}

- (void)getDataFromNetWorkingPutPay {

    NSDictionary *dic = nil;
    NSInteger payMethod = 0;
    if ([[[ZDPay_OrderSurePayListRespModel sharedSingleten] getModelData].channelCode isEqualToString:@"ALIPAY"]) {
        dic = [[ZDPayFuncTool sharedSingleton] getPutPayDictionary];
        payMethod = Alipay;
    }

    if ([[[ZDPay_OrderSurePayListRespModel sharedSingleten] getModelData].channelCode isEqualToString:@"UNIONCLOUDPAY"]) {
        dic = [[ZDPayFuncTool sharedSingleton] getUnionCloudPayDictionary];
        payMethod = UPPay;
    }

    if ([[[ZDPay_OrderSurePayListRespModel sharedSingleten] getModelData].channelCode isEqualToString:@"WECHAT"]) {
        [WXApi registerApp:[[ZDPay_OrderSureModel sharedSingleten] getModelData].subAppid withDescription:@"demo 2.0"];
        dic = [[ZDPayFuncTool sharedSingleton] getWechatDictionary];
        payMethod = WeiXin;
    }

    [[ZDPayNetRequestManager sharedSingleton] zd_netRequestVC:self Params:dic postUrlStr:[NSString stringWithFormat:@"%@%@",DOMAINNAME,PAYMENT] suscess:^(id  _Nullable responseObject) {
        PayModel *model = [PayModel new];
        if ([[responseObject objectForKey:@"code"] isEqualToString:@"200"]) {
            if ([[[ZDPay_OrderSurePayListRespModel sharedSingleten] getModelData].channelCode isEqualToString:@"ALIPAY"]) {
                NSString *str = [[responseObject objectForKey:@"data"] objectForKey:@"payInfo"];
                NSData *jsonData = [str dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
                model.goodsName =  [dic objectForKey:@"payRequest"];
            }

            if ([[[ZDPay_OrderSurePayListRespModel sharedSingleten] getModelData].channelCode isEqualToString:@"UNIONCLOUDPAY"]) {
                model.tn = [NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"tn"]];
            }

            if ([[[ZDPay_OrderSurePayListRespModel sharedSingleten] getModelData].channelCode isEqualToString:@"WECHAT"]) {
                NSString *str = [[responseObject objectForKey:@"data"] objectForKey:@"payInfo"];
                NSData *jsonData = [str dataUsingEncoding:NSUTF8StringEncoding];

                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
                model.timeStamp =  [dic objectForKey:@"timeStamp"];
                model.partnerid = @"352466557";
                model.prepayId = [dic objectForKey:@"prepayId"];
                model.nonceStr = [dic objectForKey:@"nonceStr"];
                model.packageValue = [dic objectForKey:@"packageValue"];
                model.paySign = [dic objectForKey:@"paySign"];
            }

            [ZDGPayManagerTool startPaymentWithPayMethod:payMethod payParametersModel:model viewController:self PaySuccess:^(id  _Nonnull responseObject){
                NSMutableDictionary *mutableDic = [ZDPayFuncTool getPayResultDicToClientWithCode:@"1000" withData:[responseObject objectForKey:@"data"] withMessage:@"支付成功"];
                self.completionBlock(mutableDic);
                [self.navigationController popViewControllerAnimated:YES];
            } payCancel:^(id  _Nonnull desc) {
                //self.payCancelBlock(desc);
                NSMutableDictionary *mutableDic = [ZDPayFuncTool getPayResultDicToClientWithCode:@"3000" withData:desc withMessage:@"支付取消"];
                self.completionBlock(mutableDic);
                [self.navigationController popViewControllerAnimated:YES];
            } PayFailed:^(id  _Nonnull desc) {
                NSMutableDictionary *mutableDic = [ZDPayFuncTool getPayResultDicToClientWithCode:@"2000" withData:desc withMessage:@"支付失败"];
                self.completionBlock(mutableDic);
                [self.navigationController popViewControllerAnimated:YES];
            }];
            return ;
        }
        NSMutableDictionary *mutableDic = [ZDPayFuncTool getPayResultDicToClientWithCode:@"2000" withData:@"支付失败" withMessage:@"支付失败"];
        self.completionBlock(mutableDic);
        [self.navigationController popViewControllerAnimated:YES];
     }];
}

- (void)getDataFromNetWorkingSurePayPassword {
    NSDictionary *dic = [[ZDPayFuncTool sharedSingleton] getSurePayPasswordDictionary];
    NSMutableDictionary *mutableDic = [NSMutableDictionary dictionary];
    [mutableDic setDictionary:dic];
    [mutableDic setValue:self.pay_OrderSurePayListRespModel.cardId forKey:@"cardNum"];
    [[ZDPayNetRequestManager sharedSingleton] zd_netRequestVC:self Params:mutableDic postUrlStr:[NSString stringWithFormat:@"%@%@",DOMAINNAME,PAYMENT] suscess:^(id  _Nullable responseObject) {
        NSLog(@"responseObject:%@",responseObject);
        //收到 03 04  05 的话，直接送给商户端，由商户主动发起交易状态查询
        if ([[responseObject objectForKey:@"code"] isEqualToString:@"03"] || [[responseObject objectForKey:@"code"] isEqualToString:@"04"] || [[responseObject objectForKey:@"code"] isEqualToString:@"05"]) {
            NSMutableDictionary *mutableDic = [ZDPayFuncTool getPayResultDicToClientWithCode:@"5000" withData:[responseObject objectForKey:@"data"] withMessage:@"支付失败"];
            self.completionBlock(mutableDic);
        } else {
            NSMutableDictionary *mutableDic = [ZDPayFuncTool getPayResultDicToClientWithCode:@"1000" withData:[responseObject objectForKey:@"data"] withMessage:@"支付成功"];
            self.completionBlock(mutableDic);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

//国际化
- (void)getDataFromNetWorkingAppInternationalization {
    NSDictionary *dic = [[ZDPayFuncTool sharedSingleton] getAppInternationalizationDictionary];
    [[ZDPayNetRequestManager sharedSingleton] zd_netRequestVC:self Params:dic postUrlStr:[NSString stringWithFormat:@"%@%@",DOMAINNAME,GETALLLANGUAGES] suscess:^(id  _Nullable responseObject) {
        if ([[responseObject objectForKey:@"code"] isEqualToString:@"200"]) {
            [[ZDPayInternationalizationModel sharedSingleten] setModelProcessingDic:[responseObject objectForKey:@"data"]];
            self.naviTitle = [[ZDPayInternationalizationModel sharedSingleten] getModelData].PAYMENT;
            [self getDataFromNetWorkingOrderSure:NO];
        }
    }];
}

@end
