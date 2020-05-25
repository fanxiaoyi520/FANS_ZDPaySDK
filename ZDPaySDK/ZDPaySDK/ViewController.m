//
//  ViewController.m
//  ZDPaySDK
//
//  Created by FANS on 2020/4/20.
//  Copyright © 2020 ZhongDaoGroup. All rights reserved.
//

#import "ViewController.h"
#import "ZDPay_OrderSureViewController.h"
#import "ZDPay_OrderSureModel.h"
#import "ZDPay_MyWalletViewController.h"
#import "ZDPayFuncTool.h"

@interface ViewController ()<UITextFieldDelegate>

@property (nonatomic ,copy)NSString *mobileStr;
@property (nonatomic ,copy)NSString *sandomNumStr;
@property (nonatomic ,copy)NSString *languageStr;
@property (nonatomic ,copy)NSString *moneyStr;
@property (nonatomic ,copy)NSString *cardNumStr;
@property (nonatomic ,assign)NSInteger btnTag;
@property (nonatomic ,strong)UIButton *oldBtn;
@property (nonatomic ,assign)NSInteger textTag;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    "身份证": "430702198810317016",
//    "银行卡号": "6250947000000014",
//    "bankName": "南洋商业银行",
//    "idtCardName": "陈刚"
//    银行卡手机号：+852 11112222
//    有效期：1233
//    cvn：123
//    验证码:111111

    [self registerForKeyboardNotifications];
    self.mobileStr = @"13927495764";
    self.sandomNumStr = @"23423143253215";
    self.languageStr = @"zh_CN";
    self.moneyStr = @"1200.5";
    self.cardNumStr = @"6223164991230014";
    [self creatMyWalletBtnSel:@selector(btnAction:)];
    [self creatTestPagramsUISel:@selector(textFieldAction:) languageActiom:@selector(languageBtnAction:)];
}

- (void)textFieldAction:(UITextField *)textField {
    self.textTag = textField.tag;
    if (textField.tag == 100) {
        self.mobileStr = textField.text;
    }
    if (textField.tag == 101) {
        self.sandomNumStr = textField.text;
    }
    if (textField.tag == 102) {
        self.moneyStr = textField.text;
    }
    if (textField.tag == 103) {
        self.cardNumStr = textField.text;
    }
}

- (void)languageBtnAction:(UIButton *)sender {
    self.languageStr = sender.titleLabel.text;

    self.oldBtn = [self.view viewWithTag:self.btnTag];
    
    if (sender.tag == self.btnTag) {
        return;
    }
    if (sender.selected == YES) {
        sender.backgroundColor = [UIColor redColor];
        self.oldBtn.backgroundColor = COLORWITHHEXSTRING(@"#333333", 1.0);
        sender.selected = NO;
        self.btnTag = sender.tag;
    } else {
        sender.backgroundColor = [UIColor redColor];
        self.oldBtn.backgroundColor = COLORWITHHEXSTRING(@"#333333", 1.0);
        self.btnTag = sender.tag;
        sender.selected = YES;
    }
}

- (void)creatTestPagramsUISel:(SEL)action languageActiom:(SEL)languageAction{

    NSArray *libelArray = @[@"注册手机号",@"随机订单号",@"金      额",@"身份证号"];
    NSArray *textArray = @[self.mobileStr,self.sandomNumStr,self.moneyStr,self.cardNumStr];
    for (int i = 0; i<libelArray.count; i++) {
        UILabel *label = [UILabel new];
        [self.view addSubview:label];
        CGRect rect = [ZDPayFuncTool getStringWidthAndHeightWithStr:@"注册手机号" withFont:ZD_Fout_Regular(ratioH(16))];
        label.textColor = COLORWITHHEXSTRING(@"#333333", 1);
        label.font = ZD_Fout_Regular(ratioH(16));
        label.frame = CGRectMake(20, ratioH(200+20) + mcNavBarAndStatusBarHeight + i*(ratioH(40)+ratioH(16)), rect.size.width, ratioH(16));
        label.text = libelArray[i];

        UITextField *textField = [UITextField new];
        textField.tag = 100+i;
        textField.textColor = [UIColor grayColor];
        textField.keyboardType = UIKeyboardTypeNumberPad;
        textField.delegate = self;
        [self.view addSubview:textField];
        [textField addTarget:self action:action forControlEvents:UIControlEventEditingChanged];

        UIView *lineView = [UIView new];
        lineView.backgroundColor = COLORWITHHEXSTRING(@"#E9EBEE", 1.0);
        [self.view addSubview:lineView];
        
        textField.text = textArray[i];
        textField.frame = CGRectMake(20+rect.size.width+10, ratioH(200)+mcNavBarAndStatusBarHeight+i*(ratioH(56)), ScreenWidth-40-rect.size.width-10, ratioH(56));
        lineView.frame = CGRectMake(20, ratioH(200+57)+mcNavBarAndStatusBarHeight+i*(ratioH(55)), ScreenWidth-40, ratioH(1.0));
        if (i == libelArray.count-1) {
            textField.keyboardType = UIKeyboardTypeASCIICapable;
        }
        
        if (i==2) {
            textField.keyboardType = UIKeyboardTypeDecimalPad;
        }
        if (i==1) {
            textField.keyboardType = UIKeyboardTypeASCIICapable;
        }
    }
    
    NSArray *languageTypeAry = @[@"zh_CN",@"en_US",@"zh_HK"];
    float s = (ScreenWidth-80*languageTypeAry.count-40)/(languageTypeAry.count+1);
    for (int i = 0; i<languageTypeAry.count; i++) {
        UIButton *languageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.view addSubview:languageBtn];
        [languageBtn addTarget:self action:@selector(languageBtnAction:) forControlEvents:UIControlEventTouchUpInside];

        languageBtn.frame = CGRectMake(20+i*(80 + s), ratioH(280)+mcNavBarAndStatusBarHeight+56*4, 80, 40);
        languageBtn.layer.cornerRadius = 20;
        languageBtn.layer.masksToBounds = YES;
        languageBtn.tag = 200+i;
        languageBtn.backgroundColor = COLORWITHHEXSTRING(@"#333333", 1.0);
        [languageBtn setTitle:languageTypeAry[i] forState:UIControlStateNormal];
        [languageBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        languageBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        if (languageBtn.tag == 200) {
            self.btnTag = 200;
            languageBtn.selected = YES;
            languageBtn.backgroundColor = [UIColor redColor];
        }
    }
}

- (void)creatMyWalletBtnSel:(SEL)action {
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    btn.frame = CGRectMake(40, 130, [UIScreen mainScreen].bounds.size.width-80,45);
    btn.backgroundColor = [UIColor redColor];
    [btn setTitle:@"支付" forState:UIControlStateNormal];
    btn.layer.cornerRadius = 22.5;
    btn.layer.masksToBounds = YES;
    btn.tag = 100;
    [self.view addSubview:btn];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn2 addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    btn2.frame = CGRectMake(40, 200, [UIScreen mainScreen].bounds.size.width-80,45);
    btn2.backgroundColor = [UIColor redColor];
    //[[ZDPayInternationalizationModel sharedSingleten] getModelData].MY_WALLET
    [btn2 setTitle:@"我的钱包" forState:UIControlStateNormal];
    btn2.layer.cornerRadius = 22.5;
    btn2.layer.masksToBounds = YES;
    btn2.tag = 101;
    [self.view addSubview:btn2];
}

- (void)btnAction:(UIButton *)sender {
    if (sender.tag == 100) {
        [self callbackInterface];
    } else {

        NSDictionary *dic = @{
            @"merId": @"606034453992033",
            @"mcc": @"5045",
            @"orderNo": self.sandomNumStr,//@"23423143253215"
            @"notifyUrl": @"http://test.powerpay.hk/notify",
            @"realIp": @"127.0.0.1",
            @"service": @"1",
            @"subject": @"HK Micro Test",
            @"phoneSystem":@"Ios",
            @"userId": @"oNLy6wLBpaX8QK8rk3v0ikzB-thg",
            @"version": @"1.0",
            @"txnAmt": self.moneyStr,
            @"language": self.languageStr,
            @"registerCountryCode": @"86",
            @"registerMobile": self.mobileStr,//@"13927495764"
            @"txnCurr": @"1",
            @"purchaseType":@"TRADE",//TRADE
            @"countryCode":@"HK",
            @"isSendPurchase":@"1",
//            @"AES_Key":@"030646fd09ba4c44",
//            @"md5_salt":@"FqkTPuuSbPO7iYZ",
            @"AES_Key":@"1234567890secret",
            @"md5_salt":@"md5_key",
        };
        [[ZDPay_OrderSureModel sharedSingleten] setModelProcessingDic:dic];
        ZDPay_MyWalletViewController *vc = [ZDPay_MyWalletViewController new];
        vc.orderModel = [[ZDPay_OrderSureModel sharedSingleten] getModelData];
        vc.walletType = WalletType_binding;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)callbackInterface {
    NSDictionary *dic = @{
        @"merId": @"606034453992033",
        @"desc": @"desc",
        @"mcc": @"5045",
        @"orderNo": self.sandomNumStr,
        @"notifyUrl": @"http://test.powerpay.hk/notify",
        @"realIp": @"127.0.0.1",
        @"referUrl": @"www.baidu.com",
        @"service": @"1",
        @"subAppid": @"wx53a612d04b9e1a22",
        @"subject": @"HK Micro Test",
        @"timeExpire": @"2",
        @"phoneSystem":@"Ios",
        @"userId": @"oNLy6wLBpaX8QK8rk3v0ikzB-thg",
        @"version": @"1.0",
        @"txnAmt": self.moneyStr,
        @"language": self.languageStr,
        @"registerCountryCode": @"86",
        @"registerMobile": self.mobileStr,
        @"txnCurr": @"1",
        @"cardNum": self.cardNumStr,//6223164991230014
        @"purchaseType":@"TRADE",
        @"isSendPurchase":@"1",
        @"countryCode":@"HK",
        @"subAppid": @"wx53a612d04b9e1a22",
        @"subject": @"HK Micro Test",
        @"merchantid":@"merchant.testhk.qtopay.cn.ZDPaySDK",
        @"payTimeout": @"20200427094403",
        @"txnTime": @"20200427094403",//@"txnTime": @"20200427094403",
        @"currencyCode":@"HKD",
        @"BeeMall":@"苹果支付",
//        @"AES_Key":@"030646fd09ba4c44",
//        @"md5_salt":@"FqkTPuuSbPO7iYZ",
        @"AES_Key":@"1234567890secret",
        @"md5_salt":@"md5_key",
    };
    [[ZDPay_OrderSureModel sharedSingleten] setModelProcessingDic:dic];
    ZDPay_OrderSureViewController *vc = [ZDPay_OrderSureViewController manager];
    vc.orderModel = [[ZDPay_OrderSureModel sharedSingleten] getModelData];

//    [vc ZDPay_PaymentResultCallbackWithPaySucess:^(id  _Nonnull responseObject) {
//        NSLog(@"responseObject:%@",responseObject);
//    } payCancel:^(id  _Nonnull reason) {
//        NSLog(@"reason:%@",reason);
//    } payFailure:^(id  _Nonnull desc, NSError * _Nonnull error) {
//        NSLog(@"desc:%@  error:%@",desc,error);
//    }];
    [vc ZDPay_PaymentResultCallbackWithCompletionBlock:^(id  _Nonnull responseObject) {
        NSLog(@"responseObject:%@",responseObject);
        [self showMessage:[responseObject objectForKey:@"message"] target:nil];
    }];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 键盘遮挡
- (void)registerForKeyboardNotifications {
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShown:)
                                                 name:UIKeyboardWillChangeFrameNotification object:nil];
}

//键盘弹出 处理遮挡问题
- (void)keyboardWillShown: (NSNotification *)notify {
    UITextField *_numField = [self.view viewWithTag:self.textTag];
    NSDictionary *dic = notify.userInfo;
//    CGFloat duration = [[dic objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    NSValue *value = [dic objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize size = [value CGRectValue].size;
//获取键盘高度
    CGFloat keyBoardHeight = size.height;

    CGRect frame = _numField.frame;
    int offset = frame.origin.y + 300 - (ScreenHeight - keyBoardHeight);
    
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:0.3f];
    
    //将视图y坐标向上移动offset个单位，以使下面有地方显示键盘
    
    if(offset > 0){
        self.view.frame = CGRectMake(0.0f, -offset, ScreenWidth,ScreenHeight);
        self.view.backgroundColor = [UIColor whiteColor];
    }
    [UIView commitAnimations];
     
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    self.textTag = textField.tag;
    return YES;
}

#pragma mark--UITextFieldDelegate编辑完成，视图恢复原状
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    self.view.frame =CGRectMake(0, 0, ScreenWidth, ScreenHeight);
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
