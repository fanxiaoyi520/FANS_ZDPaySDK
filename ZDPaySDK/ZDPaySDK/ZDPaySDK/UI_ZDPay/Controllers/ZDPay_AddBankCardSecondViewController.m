//
//  ZDPay_AddBankCardSecondViewController.m
//  ReadingEarn
//
//  Created by FANS on 2020/4/15.
//  Copyright © 2020 FANS. All rights reserved.
//

#import "ZDPay_AddBankCardSecondViewController.h"
#import "ZDPayFuncTool.h"
#import "ZDPay_BankCardSecondTableViewCell.h"
#import "ZDPay_SafetyCertificationViewController.h"
#import "ZDPay_AddBankCardReqModel.h"
#import "ZDPay_OrderSureViewController.h"
#import "ZDPay_MyWalletViewController.h"

@interface ZDPay_AddBankCardSecondViewController ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>

@property (nonatomic ,strong)UITableView *bankCardTableView;
@property (nonatomic ,strong)ZDPay_AddBankCardReqModel *pay_AddBankCardReqModel;
@property (nonatomic ,strong)NSArray *testArray;
@property (nonatomic ,strong)NSMutableDictionary *mutableDic;
@end

@implementation ZDPay_AddBankCardSecondViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.naviTitle = [[ZDPayInternationalizationModel sharedSingleten] getModelData].ADD_BANK_CARD;
    [self.topNavBar setNavAndStatusBarColor:COLORWITHHEXSTRING(@"#F3F3F5", 1.0)];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[self.cardInfo objectForKey:@"cardType"] forKey:@"cardType"];
    [userDefaults synchronize];
    
    [self.mutableDic setValue:[self.cardInfo objectForKey:@"cardNum"] forKey:@"cardNum"];
    [self.mutableDic setValue:[self.cardInfo objectForKey:@"cardName"] forKey:@"cardName"];
    [self.mutableDic setValue:[self.cardInfo objectForKey:@"cardType"] forKey:@"cardType"];
    [self.mutableDic setValue:[self.cardInfo objectForKey:@"cardNo"] forKey:@"cardNo"];
    [self.mutableDic setValue:@"0" forKey:@"documentType"];
    [self.mutableDic setValue:@"852" forKey:@"registerCountryCode"];

    [self.mutableDic setValue:@"" forKey:@"registerMobile"];
    [self.mutableDic setValue:@"" forKey:@"termValidity"];
    [self.mutableDic setValue:@"" forKey:@"CVN"];

    if ([self.pay_AddBankModel.cardType isEqualToString:@"C"]) {
        self.testArray = @[@[[[ZDPayInternationalizationModel sharedSingleten] getModelData].CARD_NO,[[ZDPayInternationalizationModel sharedSingleten] getModelData].NAME,[[ZDPayInternationalizationModel sharedSingleten] getModelData].ID_TYPE,[[ZDPayInternationalizationModel sharedSingleten] getModelData].ID_NO,[[ZDPayInternationalizationModel sharedSingleten] getModelData].PHONE_NO],@[[[ZDPayInternationalizationModel sharedSingleten] getModelData].EXPIRATION_DATE,@"CVN"]];
    } else {
        self.testArray = @[[[ZDPayInternationalizationModel sharedSingleten] getModelData].CARD_NO,[[ZDPayInternationalizationModel sharedSingleten] getModelData].NAME,[[ZDPayInternationalizationModel sharedSingleten] getModelData].ID_TYPE,[[ZDPayInternationalizationModel sharedSingleten] getModelData].ID_NO,[[ZDPayInternationalizationModel sharedSingleten] getModelData].PHONE_NO];
    }
    [self bankCardTableView];
    
}

#pragma mark - lazy loading
- (UITableView *)bankCardTableView {
    if (!_bankCardTableView) {
        _bankCardTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _bankCardTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _bankCardTableView.showsVerticalScrollIndicator = NO;
        _bankCardTableView.showsHorizontalScrollIndicator = NO;
        _bankCardTableView.backgroundView = nil;
        _bankCardTableView.backgroundColor = [UIColor clearColor];
        _bankCardTableView.bounces = YES;
        _bankCardTableView.frame = CGRectMake(0, mcNavBarAndStatusBarHeight, ZDScreen_Width,ZDScreen_Height - mcNavBarAndStatusBarHeight);
        
        UITableViewController *tableVC = [[UITableViewController alloc] initWithStyle:UITableViewStyleGrouped];
        tableVC.view.frame =CGRectMake(0, mcNavBarAndStatusBarHeight, ZDScreen_Width,ZDScreen_Height - mcNavBarAndStatusBarHeight);
        // 加上这句代码,就不会出现_tableView中的自定义的横线和UITableViewController中默认带的横线重合的情况了。
        tableVC.tableView.separatorStyle =UITableViewCellSeparatorStyleNone;
        tableVC.view.backgroundColor = [UIColor clearColor];
        [self addChildViewController:tableVC];
        _bankCardTableView = tableVC.tableView;

        _bankCardTableView.delegate = self;
        _bankCardTableView.dataSource = self;
        [self.view addSubview:_bankCardTableView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard:)];
        tap.delegate = self;
        [_bankCardTableView addGestureRecognizer:tap];
    }
    return _bankCardTableView;
}

- (void)hideKeyBoard:(UIGestureRecognizer *)tap {
    [self.view endEditing:YES];
}

- (NSMutableDictionary *)mutableDic {
    if (!_mutableDic) {
        _mutableDic = [NSMutableDictionary dictionary];
    }
    return _mutableDic;
}

#pragma mark - delegate and datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([self.pay_AddBankModel.cardType isEqualToString:@"C"]) {
        return self.testArray.count;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self.pay_AddBankModel.cardType isEqualToString:@"C"]) {
        if (section == 0) {
            NSArray *array = self.testArray[0];
            return array.count;
        }
        NSArray *array = self.testArray[1];
        return array.count;
    }
    return self.testArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellid = @"cellid";
    ZDPay_BankCardSecondTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[ZDPay_BankCardSecondTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        cell.backgroundColor = [UIColor clearColor];
        UIView *lineView = [UIView new];
        lineView.backgroundColor = COLORWITHHEXSTRING(@"#E9EBEE", 1.0);
        [cell.contentView addSubview:lineView];
        lineView.tag = 10;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UIView *lineView = [cell.contentView viewWithTag:10];
    lineView.frame = CGRectMake(20, ratioH(54.5), self.view.width-40, ratioH(.5));
    [cell layoutAndLoadData:self.pay_AddBankModel myIndexPath:indexPath array:self.testArray];
    cell.addBankCardTextField = ^(UITextField * _Nonnull textField) {

        if (textField.tag == 101) {
            [self.mutableDic setValue:textField.text forKey:@"cardName"];
        } else if (textField.tag == 103) {
            [self.mutableDic setValue:textField.text forKey:@"cardNo"];
        } else if (textField.tag == 104) {
            [self.mutableDic setValue:textField.text forKey:@"registerMobile"];
        } else if (textField.tag == 200) {
            [self.mutableDic setValue:textField.text forKey:@"termValidity"];
        } else if (textField.tag == 201) {
            [self.mutableDic setValue:textField.text forKey:@"CVN"];
        }
        self.pay_AddBankModel = [ZDPay_AddBankModel mj_objectWithKeyValues:self.mutableDic];        
    };
    cell.selDocumentTypeClick = ^(UIButton * _Nonnull sender) {
        [self.view endEditing:YES];
        if (sender.tag == 2) {
            ZDPay_BankCardSecondTableViewCell *cell = (ZDPay_BankCardSecondTableViewCell *)[[sender superview] superview];
            NSArray *array = @[[[ZDPayInternationalizationModel sharedSingleten] getModelData].ID_CARD,[[ZDPayInternationalizationModel sharedSingleten] getModelData].PASSPORT,[[ZDPayInternationalizationModel sharedSingleten] getModelData].HOME_REENTRY_PERMIT,[[ZDPayInternationalizationModel sharedSingleten] getModelData].ARMY_ID_CARD,[[ZDPayInternationalizationModel sharedSingleten] getModelData].POLICE_OFFICER_ID_CARD];
            ZDPayPopView *popView = [ZDPayPopView readingEarnPopupViewWithType:DocumentType];
            [popView showPopupViewWithData:array myCell:cell documentType:^(UIButton * _Nonnull docSender) {
                NSString *cardflag = [NSString stringWithFormat:@"%ld",docSender.tag-10];
                [self.mutableDic setValue:cardflag forKey:@"documentType"];
                
                [sender setTitle:docSender.titleLabel.text forState:UIControlStateNormal];
                [sender setImage:[UIImage imageNamed:@"icon_zjlx"] forState:UIControlStateNormal];
                
                CGRect contentRect = [ZDPayFuncTool getStringWidthAndHeightWithStr:docSender.titleLabel.text withFont:ZD_Fout_Regular(16)];
                sender.frame = CGRectMake(cell.width-contentRect.size.width-sender.imageView.image.size.width-ratioW(38), ratioH(20), contentRect.size.width+sender.imageView.image.size.width, 16);
                [sender setTitleEdgeInsets:UIEdgeInsetsMake(0, - sender.imageView.image.size.width, 0, sender.imageView.image.size.width)];
                [sender setImageEdgeInsets:UIEdgeInsetsMake(0, sender.titleLabel.bounds.size.width, 0, -sender.titleLabel.bounds.size.width)];

                [popView closeThePopupView];
            }];
        } else if (sender.tag == 0){
            NSArray *array = @[@"popup_youxiao",[[ZDPayInternationalizationModel sharedSingleten] getModelData].DATA_FORMAT_enter_0915];
            ZDPayPopView *popView = [ZDPayPopView readingEarnPopupViewWithType:CreditCardInputdemonstration];
            [popView showPopupMakeViewWithData:array];
        } else if (sender.tag == 1){
            NSArray *array = @[@"popup_cvn",[[ZDPayInternationalizationModel sharedSingleten] getModelData].Three_digits_on_the_back_of_the_card_such_as_888];
            ZDPayPopView *popView = [ZDPayPopView readingEarnPopupViewWithType:CreditCardInputdemonstration];
            [popView showPopupMakeViewWithData:array];
        }else {
            NSString *MAINLAND_CHINA = [NSString stringWithFormat:@"+86 %@",[[ZDPayInternationalizationModel sharedSingleten] getModelData].MAINLAND_CHINA];
            NSString *HONG_KONG = [NSString stringWithFormat:@"+852 %@",[[ZDPayInternationalizationModel sharedSingleten] getModelData].HONG_KONG];
            NSString *SINGAPORE = [NSString stringWithFormat:@"+65 %@",[[ZDPayInternationalizationModel sharedSingleten] getModelData].SINGAPORE];
            NSString *MACAO = [NSString stringWithFormat:@"+853 %@",[[ZDPayInternationalizationModel sharedSingleten] getModelData].MACAO];
            NSString *MALAYSIA = [NSString stringWithFormat:@"+60 %@",[[ZDPayInternationalizationModel sharedSingleten] getModelData].MALAYSIA];
            
            NSArray *array = @[MAINLAND_CHINA,HONG_KONG,SINGAPORE,MACAO,MALAYSIA];
            ZDPayPopView *popView = [ZDPayPopView readingEarnPopupViewWithType:CellPhoneAreaCode];
            [popView showPopupViewWithData:array phoneAreaCode:^(UITableView * _Nullable tableView, NSIndexPath * _Nullable indexPath, NSString * _Nullable text) {
                NSRange start = [text rangeOfString:@"+"];
                NSRange end = [text rangeOfString:@" "];
                NSRange range = NSMakeRange(start.location, end.location-start.location);
                NSString *result = [text substringWithRange:range];
                [sender setTitle:result forState:UIControlStateNormal];
                NSString *bankCountryCode = [result stringByReplacingOccurrencesOfString:@"+" withString:@""];
                [self.mutableDic setValue:bankCountryCode forKey:@"registerCountryCode"];
                [popView closeThePopupView];
            }];
        }
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ratioH(55);
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [UIView new];
    UIView *view2 = [UIView new];
    view2.backgroundColor = COLORWITHHEXSTRING(@"#F3F3F5", 1.0);
    view.userInteractionEnabled = YES;
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [view addSubview:btn];
    
    btn.backgroundColor = COLORWITHHEXSTRING(@"#333333", .5);
    [btn setTitle:[[ZDPayInternationalizationModel sharedSingleten] getModelData].NEXT forState:UIControlStateNormal];
    [btn setTitleColor:COLORWITHHEXSTRING(@"#FFFFFF", 1.0) forState:UIControlStateNormal];
    btn.titleLabel.font = ZD_Fout_Medium(18);
    btn.frame = CGRectMake(20, ratioH(40), ScreenWidth-40, ratioH(42));
    [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    btn.layer.cornerRadius = ratioH(21);
    btn.layer.masksToBounds = YES;
    if ([self.pay_AddBankModel.cardType isEqualToString:@"C"]) {
        if (section == 0) {
            return view2;
        } else {
            return view;
        }
    } else {
        return view;
    }
    return nil;
}

- (void)btnAction:(UIButton *)sender {
    [self.view endEditing:YES];
    sender.enabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        sender.enabled = YES;
    });
    
    self.pay_AddBankModel = [ZDPay_AddBankModel mj_objectWithKeyValues:self.mutableDic];
    [[ZDPay_AddBankModel sharedSingleten] setModelProcessingDic:self.mutableDic];
    if ([self.pay_AddBankModel.cardName isEqualToString:@""] || self.pay_AddBankModel.cardName.length > 15) {
        [self showMessage:[[ZDPayInternationalizationModel sharedSingleten] getModelData].PLEASE_ENTER_YOUR_NAME target:nil];
        return;
    }
    
    
    //[ZDPayFuncTool cly_verifyIDCardString:self.pay_AddBankModel.cardNo]
    if ([self.pay_AddBankModel.cardNo isEqualToString:@""]) {
        [self showMessage:[[ZDPayInternationalizationModel sharedSingleten] getModelData].PLEASE_ENTER_YOUR_ID_NUMBER target:nil];
        return;
    }
    
    if ([self.pay_AddBankModel.registerCountryCode isEqualToString:@"86"]) {
        if (self.pay_AddBankModel.registerMobile.length != 11) {
            [self showMessage:[[ZDPayInternationalizationModel sharedSingleten] getModelData].PLEASE_ENTER_AN_11DIGIT_PHONE_NUMBER target:nil];
            return;
        }
    } else {
        if (self.pay_AddBankModel.registerMobile.length != 8) {
            [self showMessage:[[ZDPayInternationalizationModel sharedSingleten] getModelData].PLEASE_ENTER_AN_8DIGIT_PHONE_NUMBER target:nil];
            return;
        }
    }

    if ([self.pay_AddBankModel.cardType isEqualToString:@"C"]) {
        if (self.pay_AddBankModel.termValidity.length != 4) {
            [self showMessage:[[ZDPayInternationalizationModel sharedSingleten] getModelData].PLEASE_ENTER_EXPIRY_DAY target:nil];
            return;
        }

        if (self.pay_AddBankModel.CVN.length != 3) {
            [self showMessage:[[ZDPayInternationalizationModel sharedSingleten] getModelData].PLEASE_ENTER_CVN target:nil];
            return;
        }

    }
    
    if ([self.pay_AddBankModel.cardType isEqualToString:@""]) {
        [self showMessage:[[ZDPayInternationalizationModel sharedSingleten] getModelData].PLEASE_SELECT_ID_TYPE target:nil];
        return;
    }

    [self getDataFromNetWorkingGetSmsCode:sender];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if ([self.pay_AddBankModel.cardType isEqualToString:@"C"]) {
        if (section == 0) {
            return 10;
        } else {
            return ratioH(200);
        }
    } else {
        return ratioH(200);
    }
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [UIView new];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - get data
- (void)getDataFromNetWorkingGetSmsCode:(UIButton *)sender {
    [self.view endEditing:YES];
    NSDictionary *dic = [[ZDPayFuncTool sharedSingleton] getGetSmsCodeDictionary];
    sender.enabled = NO;
    [[ZDPayNetRequestManager sharedSingleton] zd_netRequestVC:self Params:dic postUrlStr:[NSString stringWithFormat:@"%@%@",DOMAINNAME,SENDBINDCARDSMS] suscess:^(id  _Nullable responseObject) {
        if ([[responseObject objectForKey:@"code"] isEqualToString:@"200"]) {
            ZDPay_SafetyCertificationViewController *vc = [ZDPay_SafetyCertificationViewController new];
            [self.navigationController pushViewController:vc animated:YES];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                sender.enabled = YES;
            });
        }
        
        if ([[responseObject objectForKey:@"code"] isEqualToString:@"79"]) {
            [self getDataFromNetWorkingChecksmsCode];
        }
     }];
}

- (void)getDataFromNetWorkingChecksmsCode {
    NSDictionary *dic = [[ZDPayFuncTool sharedSingleton] getChecksmsCodeDictionary];;
    [[ZDPayNetRequestManager sharedSingleton] zd_netRequestVC:self Params:dic postUrlStr:[NSString stringWithFormat:@"%@%@",DOMAINNAME,CHECKBINDCARDSMS] suscess:^(id  _Nullable responseObject) {

         if ([[responseObject objectForKey:@"code"] isEqualToString:@"200"]) {
             [[NSNotificationCenter defaultCenter] postNotificationName:BINDBANKCARDSUCCEEDED object:self userInfo:nil];
             for (UIViewController *temp in self.navigationController.viewControllers) {
                 if ([temp isKindOfClass:[ZDPay_OrderSureViewController class]]) {
                     [self.navigationController popToViewController:temp animated:YES];
                 }
                 if ([temp isKindOfClass:[ZDPay_MyWalletViewController class]]) {
                     [self.navigationController popToViewController:temp animated:YES];
                 }
             }
         }
    }];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
