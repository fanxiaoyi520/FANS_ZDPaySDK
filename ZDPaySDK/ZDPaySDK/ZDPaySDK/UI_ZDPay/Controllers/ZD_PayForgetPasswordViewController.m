//
//  ZD_PayForgetPasswordViewController.m
//  ZDPaySDK
//
//  Created by FANS on 2020/4/22.
//  Copyright © 2020 ZhongDaoGroup. All rights reserved.
//

#import "ZD_PayForgetPasswordViewController.h"
#import "ZDPayFuncTool.h"
#import "ZDPay_SecurityVerificationSecondViewController.h"
#import "ZDPay_SetConfirPasswordViewController.h"

@interface ZD_PayForgetPasswordViewController ()<UITextFieldDelegate>
@property (nonatomic ,strong)UIButton *countDownBtn;
@property (strong, nonatomic)CountDown *countDownForBtn;
@property (strong, nonatomic)NSMutableDictionary *mutableDic;

@end

@implementation ZD_PayForgetPasswordViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.topNavBar setNavAndStatusBarColor:COLORWITHHEXSTRING(@"#F3F3F5", 1.0)];
    self.view.backgroundColor = [UIColor whiteColor];
    self.naviTitle = [[ZDPayInternationalizationModel sharedSingleten] getModelData].FORGOT_PASSWORD;
    
    [self.mutableDic setValue:@"" forKey:@"cardName"];
    [self.mutableDic setValue:@"" forKey:@"cardNum"];
    [self.mutableDic setValue:@"" forKey:@"smsCode"];

    [self creatTextField:@selector(textFieldAction:) andWithBtn:@selector(btnAction:)];
}

- (NSMutableDictionary *)mutableDic {
    if (!_mutableDic) {
        _mutableDic = [NSMutableDictionary dictionary];
    }
    return _mutableDic;
}

- (void)creatTextField:(SEL)textFieldAction andWithBtn:(SEL)btnAction {
    _countDownForBtn = [[CountDown alloc] init];
    CGRect countDownRect = [ZDPayFuncTool getStringWidthAndHeightWithStr:[[ZDPayInternationalizationModel sharedSingleten] getModelData].REQUEST_OTP withFont:ZD_Fout_Medium(16)];

    NSArray *libelArray = @[@"姓名",[[ZDPayInternationalizationModel sharedSingleten] getModelData].CARD_NO];
    NSArray *textArray = @[[[ZDPayInternationalizationModel sharedSingleten] getModelData].NAME,[[ZDPayInternationalizationModel sharedSingleten] getModelData].ENTER_BANK_CARD_NO,[[ZDPayInternationalizationModel sharedSingleten] getModelData].ENTER_THE_CODE];
    for (int i = 0; i<3; i++) {
        UILabel *label = [UILabel new];
        [self.view addSubview:label];
        CGRect rect = [ZDPayFuncTool getStringWidthAndHeightWithStr:[[ZDPayInternationalizationModel sharedSingleten] getModelData].CARD_NO withFont:ZD_Fout_Regular(ratioH(16))];
        label.textColor = COLORWITHHEXSTRING(@"#333333", 1);
        label.font = ZD_Fout_Regular(ratioH(16));
        if (i<2) {
            label.frame = CGRectMake(20, ratioH(54) + mcNavBarAndStatusBarHeight + i*(ratioH(40)+ratioH(16)), rect.size.width, ratioH(16));
            label.text = libelArray[i];
        }
        
        UITextField *textField = [UITextField new];
        textField.tag = 100+i;
        [self.view addSubview:textField];
        textField.textColor = COLORWITHHEXSTRING(@"#333333", 1.0);
        [textField addTarget:self action:textFieldAction forControlEvents:UIControlEventEditingChanged];
        UIView *lineView = [UIView new];
        lineView.backgroundColor = COLORWITHHEXSTRING(@"#E9EBEE", 1.0);
        NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:textArray[i] attributes:@{
            NSForegroundColorAttributeName:COLORWITHHEXSTRING(@"#999999", 1.0),
            NSFontAttributeName:textField.font,
        }];
        textField.attributedPlaceholder = attrString;
        textField.delegate = self;
        [self.view addSubview:lineView];
        if (i<3) {

            textField.frame = CGRectMake(20+rect.size.width+10, ratioH(34)+mcNavBarAndStatusBarHeight+i*(ratioH(56)), ScreenWidth-40-rect.size.width-10, ratioH(56));
            lineView.frame = CGRectMake(20, ratioH(89)+mcNavBarAndStatusBarHeight+i*(ratioH(55)), ScreenWidth-40, ratioH(1.0));
            if (i==2) {
                textField.frame = CGRectMake(20, ratioH(34)+mcNavBarAndStatusBarHeight+i*(ratioH(56)), ScreenWidth-60-countDownRect.size.width, ratioH(56));
            }
        }
        
        if (i!=0) {
            textField.keyboardType = UIKeyboardTypeNumberPad;
        }
    }
    
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    nextBtn.backgroundColor = COLORWITHHEXSTRING(@"#333333", .5);
    [self.view addSubview:nextBtn];
    [nextBtn setTitle:[[ZDPayInternationalizationModel sharedSingleten] getModelData].NEXT forState:UIControlStateNormal];
    nextBtn.titleLabel.font = ZD_Fout_Medium(18);
    [nextBtn setTitleColor:COLORWITHHEXSTRING(@"#FFFFFF", 1.0) forState:UIControlStateNormal];
    [nextBtn addTarget:self action:btnAction forControlEvents:UIControlEventTouchUpInside];
    nextBtn.frame = CGRectMake(20, ratioH(242)+mcNavBarAndStatusBarHeight, ScreenWidth-40, ratioH(42));
    nextBtn.layer.cornerRadius = ratioH(21);
    nextBtn.layer.masksToBounds = YES;
    
    UITextField *tex = [self.view viewWithTag:102];
    UIButton *countDownBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.countDownBtn = countDownBtn;
    self.countDownBtn.backgroundColor = COLORWITHHEXSTRING(@"#999999", 1.0);
    [self.countDownBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.countDownBtn setTitle:[[ZDPayInternationalizationModel sharedSingleten] getModelData].REQUEST_OTP forState:UIControlStateNormal];
    [self.view addSubview:countDownBtn];
    countDownBtn.titleLabel.font = ZD_Fout_Regular(16);
    countDownBtn.layer.cornerRadius = ratioH(13);
    countDownBtn.layer.masksToBounds = YES;
    countDownBtn.frame = CGRectMake(tex.right + 10, ratioH(160)+mcNavBarAndStatusBarHeight, countDownRect.size.width+20, ratioH(26));
    [countDownBtn addTarget:self action:@selector(countDownBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)startcountDown {
    NSTimeInterval aMinutes = 60;
    [_countDownForBtn countDownWithStratDate:[NSDate date] finishDate:[NSDate dateWithTimeIntervalSinceNow:aMinutes] completeBlock:^(NSInteger day, NSInteger hour, NSInteger minute, NSInteger second) {
        NSInteger totoalSecond =day*24*60*60+hour*60*60 + minute*60+second;
        UITextField *tex = [self.view viewWithTag:102];
        if (totoalSecond==0) {
            CGRect countDownRect = [ZDPayFuncTool getStringWidthAndHeightWithStr:[[ZDPayInternationalizationModel sharedSingleten] getModelData].RESET_OTP withFont:ZD_Fout_Medium(16)];
            tex.frame = CGRectMake(20, ratioH(146)+mcNavBarAndStatusBarHeight, ScreenWidth-40-countDownRect.size.width-30, ratioH(56));
            
            self.countDownBtn.frame = CGRectMake(tex.right + 10, ratioH(160)+mcNavBarAndStatusBarHeight, countDownRect.size.width+20, ratioH(26));
            self.countDownBtn.enabled = YES;
            self.countDownBtn.backgroundColor = COLORWITHHEXSTRING(@"#999999", 1.0);
            [self.countDownBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.countDownBtn setTitle:[[ZDPayInternationalizationModel sharedSingleten] getModelData].RESET_OTP forState:UIControlStateNormal];
        }else{
            CGRect countDownRect = [ZDPayFuncTool getStringWidthAndHeightWithStr:@"60s" withFont:ZD_Fout_Medium(16)];
            tex.frame = CGRectMake(20, ratioH(146)+mcNavBarAndStatusBarHeight, ScreenWidth-40-countDownRect.size.width-30, ratioH(56));
            self.countDownBtn.frame = CGRectMake(tex.right + 10, ratioH(160)+mcNavBarAndStatusBarHeight, countDownRect.size.width+20, ratioH(26));
            self.countDownBtn.backgroundColor = [UIColor clearColor];
            [self.countDownBtn setTitleColor:COLORWITHHEXSTRING(@"#FFB300", 1.0) forState:UIControlStateNormal];
            self.countDownBtn.enabled = NO;
            [self.countDownBtn setTitle:[NSString stringWithFormat:@"%lis",totoalSecond] forState:UIControlStateNormal];
        }
    }];
}

- (void)countDownBtnAction:(UIButton *)sender {
    ZDPay_OrderSureModel *model = [[ZDPay_OrderSureModel sharedSingleten] getModelData];
    NSDictionary *dic = @{
        @"language":model.language,
        @"merId":model.merId,
        @"registerMobile":model.registerMobile,
        @"registerCountryCode":model.registerCountryCode,
        @"cardNum":[self.mutableDic objectForKey:@"cardNum"],
        @"cardName":[self.mutableDic objectForKey:@"cardName"]
    };
    [[ZDPayNetRequestManager sharedSingleton] zd_netRequestVC:self Params:dic postUrlStr:[NSString stringWithFormat:@"%@%@",DOMAINNAME,SENDFORGETPWDSMS] suscess:^(id  _Nullable responseObject) {
        if ([[responseObject objectForKey:@"code"] isEqualToString:@"200"]) {
            [self startcountDown];
        }
    }];
}

- (void)textFieldAction:(UITextField *)textField {
    if (textField.tag == 100) {
        [self.mutableDic setValue:textField.text forKey:@"cardName"];
    } else if (textField.tag == 101) {
        [self.mutableDic setValue:textField.text forKey:@"cardNum"];
    } else {
        [self.mutableDic setValue:textField.text forKey:@"smsCode"];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

    UITextField *contentTextField = [self.view viewWithTag:101];
    if (textField == contentTextField) {
        // 4位分隔银行卡卡号
        NSString *text = [textField text];
        
        NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789\b"];
        string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
        if ([string rangeOfCharacterFromSet:[characterSet invertedSet]].location != NSNotFound) {
            return NO;
        }
        
        text = [text stringByReplacingCharactersInRange:range withString:string];
        text = [text stringByReplacingOccurrencesOfString:@" " withString:@""];

        NSString *newString = @"";
        while (text.length > 0) {
            NSString *subString = [text substringToIndex:MIN(text.length, 4)];
            newString = [newString stringByAppendingString:subString];
            if (subString.length == 4) {
                newString = [newString stringByAppendingString:@" "];
            }
            text = [text substringFromIndex:MIN(text.length, 4)];
        }
        
        newString = [newString stringByTrimmingCharactersInSet:[characterSet invertedSet]];
        if ([newString stringByReplacingOccurrencesOfString:@" " withString:@""].length >= 21) {
            return NO;
        }
        [textField setText:newString];
        NSString *str = [textField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        [self.mutableDic setValue:str forKey:@"cardNum"];
        return NO;
    }
    return YES;
}

- (void)btnAction:(UIButton *)sender {
    
    if ([[self.mutableDic objectForKey:@"cardName"] isEqualToString:@""] ) {
        [self showMessage:[[ZDPayInternationalizationModel sharedSingleten] getModelData].NAME target:nil];
    } else {
        if ([[self.mutableDic objectForKey:@"cardNum"] isEqualToString:@""]) {
            [self showMessage:[[ZDPayInternationalizationModel sharedSingleten] getModelData].ENTER_BANK_CARD_NO target:nil];
        } else {
            if ([[self.mutableDic objectForKey:@"smsCode"] isEqualToString:@""]) {
                [self showMessage:[[ZDPayInternationalizationModel sharedSingleten] getModelData].ENTER_THE_CODE target:nil];
            } else {
                ZDPay_OrderSureModel *model = [[ZDPay_OrderSureModel sharedSingleten] getModelData];
                NSDictionary *dic = @{
                    @"language":model.language,
                    @"merId":model.merId,
                    @"registerMobile":model.registerMobile,
                    @"registerCountryCode":model.registerCountryCode,
                    @"cardNum":[self.mutableDic objectForKey:@"cardNum"],
                    @"cardName":[self.mutableDic objectForKey:@"cardName"],
                    @"smsCode":[self.mutableDic objectForKey:@"smsCode"]
                };
                [[ZDPayNetRequestManager sharedSingleton] zd_netRequestVC:self Params:dic postUrlStr:[NSString stringWithFormat:@"%@%@",DOMAINNAME,CHECKFORGETPWDSMS] suscess:^(id  _Nullable responseObject) {
                    if ([[responseObject objectForKey:@"code"] isEqualToString:@"200"]) {
                        ZDPay_SetConfirPasswordViewController *vc = [ZDPay_SetConfirPasswordViewController new];
                        if ([[responseObject objectForKey:@"data"] objectForKey:@"reToken"]) {
                            vc.reToken = [[responseObject objectForKey:@"data"] objectForKey:@"reToken"];
                        } else {
                            vc.reToken = @"";
                        }
                        vc.isFirstSetPassword = NO;
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                }];
            }
        }
    }
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
