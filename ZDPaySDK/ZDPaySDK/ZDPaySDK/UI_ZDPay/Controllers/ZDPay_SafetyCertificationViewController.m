//
//  ZDPay_SafetyCertificationViewController.m
//  ReadingEarn
//
//  Created by FANS on 2020/4/15.
//  Copyright © 2020 FANS. All rights reserved.
//

#import "ZDPay_SafetyCertificationViewController.h"
#import "ZDPayFuncTool.h"
#import "ZDPay_OrderSureViewController.h"
#import "ZDPay_SetConfirPasswordViewController.h"
#import "ZDPay_MyWalletViewController.h"

@interface ZDPay_SafetyCertificationViewController ()

@property (strong, nonatomic)CountDown *countDownForBtn;
@property (nonatomic ,strong)UITextField *textField;
@property (nonatomic ,strong)UIButton *countDownBtn;
@property (nonatomic ,copy)NSString *smsCode;

@end

@implementation ZDPay_SafetyCertificationViewController

- (void)viewDidLoad {

    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.naviTitle = [[ZDPayInternationalizationModel sharedSingleten] getModelData].SECURITY_VERIFICATION;
    [self.topNavBar setNavAndStatusBarColor:COLORWITHHEXSTRING(@"#F3F3F5", 1.0)];

    [self creatTextField:@selector(textFieldAction:) andWithBtn:@selector(btnAction:)];
}

- (void)creatTextField:(SEL)textFieldAction andWithBtn:(SEL)btnAction {
    _countDownForBtn = [[CountDown alloc] init];
    
    UILabel *titleLab = [UILabel new];
    [self.view addSubview:titleLab];
    titleLab.textColor = COLORWITHHEXSTRING(@"#333333", 1.0);
    titleLab.font = ZD_Fout_Regular(16);
    titleLab.text = [[ZDPayInternationalizationModel sharedSingleten] getModelData].PLEASE_ENTER_ONE_TIME_PIN;
    titleLab.frame = CGRectMake(0, ratioH(54)+mcNavBarAndStatusBarHeight, ScreenWidth, 16);
    titleLab.textAlignment = NSTextAlignmentCenter;
    
    ZDPay_AddBankModel *addModel = [[ZDPay_AddBankModel sharedSingleten] getModelData];
    UILabel *iphoneLab = [UILabel new];
    [self.view addSubview:iphoneLab];
    iphoneLab.textColor = COLORWITHHEXSTRING(@"#333333", 1.0);
    iphoneLab.font = ZD_Fout_Regular(16);
    iphoneLab.text = [NSString stringWithFormat:@"%@ %@",addModel.registerCountryCode,addModel.registerMobile];
    iphoneLab.frame = CGRectMake(0, ratioH(80)+mcNavBarAndStatusBarHeight, ScreenWidth, 16);
    iphoneLab.textAlignment = NSTextAlignmentCenter;

    
    CGRect countDownRect = [ZDPayFuncTool getStringWidthAndHeightWithStr:[[ZDPayInternationalizationModel sharedSingleten] getModelData].REQUEST_OTP withFont:ZD_Fout_Medium(16)];
    UITextField *textField = [UITextField new];
    self.textField = textField;
    [self.view addSubview:textField];
    textField.textColor = COLORWITHHEXSTRING(@"#333333", 1.0);
    textField.keyboardType = UIKeyboardTypeNumberPad;
    [textField addTarget:self action:textFieldAction forControlEvents:UIControlEventEditingChanged];
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:[[ZDPayInternationalizationModel sharedSingleten] getModelData].ENTER_THE_CODE attributes:@{
        NSForegroundColorAttributeName:COLORWITHHEXSTRING(@"#999999", 1.0),
        NSFontAttributeName:textField.font,
    }];
    textField.attributedPlaceholder = attrString;
    textField.frame = CGRectMake(20, ratioH(126)+mcNavBarAndStatusBarHeight, ScreenWidth-40-countDownRect.size.width-30, ratioH(56));
    
    UIView *lineView = [UIView new];
    lineView.backgroundColor = COLORWITHHEXSTRING(@"#E9EBEE", 1.0);
    [self.view addSubview:lineView];
    lineView.frame = CGRectMake(20, ratioH(181)+mcNavBarAndStatusBarHeight, ScreenWidth-40, .5);
    
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    nextBtn.backgroundColor = COLORWITHHEXSTRING(@"#333333", 1);
    [self.view addSubview:nextBtn];
    [nextBtn setTitle:[[ZDPayInternationalizationModel sharedSingleten] getModelData].NEXT forState:UIControlStateNormal];
    nextBtn.titleLabel.font = ZD_Fout_Medium(18);
    [nextBtn setTitleColor:COLORWITHHEXSTRING(@"#FFFFFF", 1.0) forState:UIControlStateNormal];
    [nextBtn addTarget:self action:btnAction forControlEvents:UIControlEventTouchUpInside];
    nextBtn.frame = CGRectMake(20, ratioH(222)+mcNavBarAndStatusBarHeight, ScreenWidth-40, ratioH(42));
    nextBtn.layer.cornerRadius = ratioH(21);
    nextBtn.layer.masksToBounds = YES;
    
    UIButton *countDownBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.countDownBtn = countDownBtn;
    self.countDownBtn.backgroundColor = COLORWITHHEXSTRING(@"#999999", 1.0);
    [self.countDownBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.countDownBtn setTitle:@"60s" forState:UIControlStateNormal];
    [self.view addSubview:countDownBtn];
    countDownBtn.titleLabel.font = ZD_Fout_Regular(16);
    countDownBtn.layer.cornerRadius = ratioH(13);
    countDownBtn.layer.masksToBounds = YES;
    countDownBtn.frame = CGRectMake(textField.right + 10, ratioH(140)+mcNavBarAndStatusBarHeight, countDownRect.size.width+20, ratioH(26));
    [countDownBtn addTarget:self action:@selector(countDownBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self startcountDown];
}

- (void)startcountDown {
    NSTimeInterval aMinutes = 60;
    [_countDownForBtn countDownWithStratDate:[NSDate date] finishDate:[NSDate dateWithTimeIntervalSinceNow:aMinutes] completeBlock:^(NSInteger day, NSInteger hour, NSInteger minute, NSInteger second) {
        NSInteger totoalSecond =day*24*60*60+hour*60*60 + minute*60+second;
        if (totoalSecond==0) {
            CGRect countDownRect = [ZDPayFuncTool getStringWidthAndHeightWithStr:[[ZDPayInternationalizationModel sharedSingleten] getModelData].RESET_OTP withFont:ZD_Fout_Medium(16)];
            self.textField.frame = CGRectMake(20, ratioH(126)+mcNavBarAndStatusBarHeight, ScreenWidth-40-countDownRect.size.width-30, ratioH(56));
            self.countDownBtn.frame = CGRectMake(self.textField.right + 10, ratioH(140)+mcNavBarAndStatusBarHeight, countDownRect.size.width+20, ratioH(26));
            self.countDownBtn.enabled = YES;
            self.countDownBtn.backgroundColor = COLORWITHHEXSTRING(@"#999999", 1.0);
            [self.countDownBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.countDownBtn setTitle:[[ZDPayInternationalizationModel sharedSingleten] getModelData].RESET_OTP forState:UIControlStateNormal];
        }else{
            CGRect countDownRect = [ZDPayFuncTool getStringWidthAndHeightWithStr:@"60s" withFont:ZD_Fout_Medium(16)];
            self.textField.frame = CGRectMake(20, ratioH(126)+mcNavBarAndStatusBarHeight, ScreenWidth-40-countDownRect.size.width-30, ratioH(56));
            self.countDownBtn.frame = CGRectMake(self.textField.right + 10, ratioH(140)+mcNavBarAndStatusBarHeight, countDownRect.size.width+20, ratioH(26));
            self.countDownBtn.backgroundColor = [UIColor clearColor];
            [self.countDownBtn setTitleColor:COLORWITHHEXSTRING(@"#FFB300", 1.0) forState:UIControlStateNormal];
            self.countDownBtn.enabled = NO;
            [self.countDownBtn setTitle:[NSString stringWithFormat:@"%lis",totoalSecond] forState:UIControlStateNormal];
        }
    }];
}

- (void)countDownBtnAction:(UIButton *)sender {
    //[self getDataFromNetWorkingGetSmsCode];
    [self startcountDown];
}

- (void)textFieldAction:(UITextField *)textField {
    self.smsCode = textField.text;
}

- (void)btnAction:(UIButton *)sender {
    if ([self.countDownBtn.titleLabel.text isEqualToString:[[ZDPayInternationalizationModel sharedSingleten] getModelData].RESET_OTP]) {
        [self showMessage:[[ZDPayInternationalizationModel sharedSingleten] getModelData].OTP_EXPIRATION target:nil];

    } else {
        if (self.smsCode) {
            [self getDataFromNetWorkingChecksmsCode];
        } else {
            [self showMessage:[[ZDPayInternationalizationModel sharedSingleten] getModelData].ENTER_THE_CODE target:nil];
        }
    }
}

#pragma mark - get data
- (void)getDataFromNetWorkingGetSmsCode {
    ZDPay_OrderSureModel *model = [[ZDPay_OrderSureModel sharedSingleten] getModelData];
    ZDPay_AddBankModel *addModel = [[ZDPay_AddBankModel sharedSingleten] getModelData];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *cardType = [userDefaults objectForKey:@"cardType"];
    NSDictionary *dic;
    if ([cardType isEqualToString:@"C"]) {
        dic = @{
            @"language":model.language,
            @"registerCountryCode":model.registerCountryCode,
            @"registerMobile":model.registerMobile,
            @"bankCountryCode":addModel.registerCountryCode,
            @"merId":model.merId,
            @"cardNo":addModel.cardNo,
            @"cardNum":addModel.cardNum,
            @"cardName":addModel.cardName,
            @"bankMobile":addModel.registerMobile,
            @"cvn":addModel.CVN,
            @"expired":addModel.termValidity,
            @"cardflag":addModel.documentType,//证件类型
            @"orderNo":model.orderNo,//订单号
        };
    } else {
        dic = @{
            @"language":model.language,
            @"registerCountryCode":model.registerCountryCode,
            @"registerMobile":model.registerMobile,
            @"bankCountryCode":addModel.registerCountryCode,
            @"merId":model.merId,
            @"cardNo":addModel.cardNo,
            @"cardNum":addModel.cardNum,
            @"cardName":addModel.cardName,
            @"bankMobile":addModel.registerMobile,
            @"cardflag":addModel.documentType,//证件类型
            @"orderNo":model.orderNo,//订单号
        };
    }

    [[ZDPayNetRequestManager sharedSingleton] zd_netRequestVC:self Params:dic postUrlStr:[NSString stringWithFormat:@"%@%@",DOMAINNAME,SENDBINDCARDSMS] suscess:^(id  _Nullable responseObject) {
        if ([[responseObject objectForKey:@"code"] isEqualToString:@"200"]) {
            NSLog(@"responseObject:%@",responseObject);
            [self startcountDown];
        }
     }];
}

- (void)getDataFromNetWorkingChecksmsCode {
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setDictionary:[[ZDPayFuncTool sharedSingleton] getChecksmsCodeDictionary]];
    [dic setValue:self.smsCode forKey:@"smsCode"];
     [[ZDPayNetRequestManager sharedSingleton] zd_netRequestVC:self Params:dic postUrlStr:[NSString stringWithFormat:@"%@%@",DOMAINNAME,CHECKBINDCARDSMS] suscess:^(id  _Nullable responseObject) {
         if ([[responseObject objectForKey:@"code"] isEqualToString:@"200"]) {
             NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
             NSString *model = [userDefaults objectForKey:@"shezhimima"];
             if ([model isEqualToString:@"0"]) {
                 [[NSNotificationCenter defaultCenter] postNotificationName:BINDBANKCARDSUCCEEDED object:self userInfo:nil];
                 for (UIViewController *temp in self.navigationController.viewControllers) {
                     if ([temp isKindOfClass:[ZDPay_OrderSureViewController class]]) {
                         [self.navigationController popToViewController:temp animated:YES];
                     }
                     if ([temp isKindOfClass:[ZDPay_MyWalletViewController class]]) {
                         [self.navigationController popToViewController:temp animated:YES];
                     }
                 }
             } else {
                 ZDPay_SetConfirPasswordViewController *vc = [ZDPay_SetConfirPasswordViewController new];
                 vc.showTips = [[ZDPayInternationalizationModel sharedSingleten] getModelData].BIND_SUCCESSFULLY;
                 vc.isFirstSetPassword = YES;
                 [self.navigationController pushViewController:vc animated:YES];
             }
         }
     }];
}

- (void)dealloc {
    [self.countDownForBtn destoryTimer];
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
