//
//  ZDPay_AddBankCardViewController.m
//  ReadingEarn
//
//  Created by FANS on 2020/4/15.
//  Copyright © 2020 FANS. All rights reserved.
//

#import "ZDPay_AddBankCardViewController.h"
#import "ZDPayFuncTool.h"
#import "ZDPay_AddBankCardSecondViewController.h"
#import "ZDPay_AddBankModel.h"
#import "ZDPay_OrderSurePayListRespModel.h"

@interface ZDPay_AddBankCardViewController ()

@property (nonatomic ,copy)NSString *bankCardNumStr;
@property (nonatomic ,strong)UITextField *contentTextField;

@end

@implementation ZDPay_AddBankCardViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.topNavBar setNavAndStatusBarColor:COLORWITHHEXSTRING(@"#F3F3F5", 1.0)];
    self.naviTitle = [[ZDPayInternationalizationModel sharedSingleten] getModelData].ADD_BANK_CARD;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self creatTextField:@selector(textFieldAction:) andWithBtn:@selector(btnAction:)];
}

- (void)creatTextField:(SEL)textFieldAction andWithBtn:(SEL)btnAction {
    UILabel *label = [UILabel new];
    [self.view addSubview:label];
    CGRect rect = [ZDPayFuncTool getStringWidthAndHeightWithStr:[[ZDPayInternationalizationModel sharedSingleten] getModelData].CARD_NO withFont:ZD_Fout_Regular(ratioH(16))];
    label.textColor = COLORWITHHEXSTRING(@"#333333", 1);
    label.frame = CGRectMake(20, ratioH(54) + mcNavBarAndStatusBarHeight, rect.size.width, ratioH(16));
    label.text = [[ZDPayInternationalizationModel sharedSingleten] getModelData].CARD_NO;
    label.font = ZD_Fout_Regular(ratioH(16));
    
    UITextField *textField = [UITextField new];
    textField.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:textField];
    textField.textColor = COLORWITHHEXSTRING(@"#333333", 1.0);
    [textField addTarget:self action:textFieldAction forControlEvents:UIControlEventEditingChanged];
    //textField.placeholder = [[ZDPayInternationalizationModel sharedSingleten] getModelData].ENTER_BANK_CARD_NO;
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:[[ZDPayInternationalizationModel sharedSingleten] getModelData].ENTER_BANK_CARD_NO attributes:@{
        NSForegroundColorAttributeName:COLORWITHHEXSTRING(@"#999999", 1.0),
        NSFontAttributeName:textField.font,
    }];
    textField.attributedPlaceholder = attrString;
    textField.delegate = self;
    self.contentTextField = textField;
    textField.frame = CGRectMake(20+10+rect.size.width, ratioH(34)+mcNavBarAndStatusBarHeight, ScreenWidth-40-rect.size.width-10, ratioH(56));
    
    UIView *lineView = [UIView new];
    lineView.backgroundColor = COLORWITHHEXSTRING(@"#E9EBEE", 1.0);
    [self.view addSubview:lineView];
    lineView.frame = CGRectMake(20, ratioH(89)+mcNavBarAndStatusBarHeight, ScreenWidth-40, ratioH(1.0));
    
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    nextBtn.backgroundColor = COLORWITHHEXSTRING(@"#333333", .5);
    [self.view addSubview:nextBtn];
    [nextBtn setTitle:[[ZDPayInternationalizationModel sharedSingleten] getModelData].NEXT forState:UIControlStateNormal];
    nextBtn.titleLabel.font = ZD_Fout_Medium(18);
    [nextBtn setTitleColor:COLORWITHHEXSTRING(@"#FFFFFF", 1.0) forState:UIControlStateNormal];
    [nextBtn addTarget:self action:btnAction forControlEvents:UIControlEventTouchUpInside];
    nextBtn.frame = CGRectMake(20, ratioH(130)+mcNavBarAndStatusBarHeight, ScreenWidth-40, ratioH(42));
    nextBtn.layer.cornerRadius = ratioH(21);
    nextBtn.layer.masksToBounds = YES;
}

- (void)textFieldAction:(UITextField *)textField {
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.contentTextField) {
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
        self.bankCardNumStr = [NSString stringWithFormat:@"%@",textField.text];
        return NO;
    }
    return YES;
}


- (void)btnAction:(UIButton *)sender {

    if (!self.bankCardNumStr) {
        self.bankCardNumStr = @"";
    }
    self.bankCardNumStr = [self.bankCardNumStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    ZDPay_OrderSureModel *model = [[ZDPay_OrderSureModel sharedSingleten] getModelData];
    
    if (self.bankCardNumStr.length > 22) {
        [self showMessage:@"请输入正确的卡号" target:nil];
        return;
    }
    NSDictionary *dic = @{
        //@"cardNum":@"6250947000000014",
        @"language": model.language,
        @"registerCountryCode": model.registerCountryCode,
        @"registerMobile": model.registerMobile,
        @"cardNum":self.bankCardNumStr,
        @"merId": model.merId,
        @"payType":@"UNIONPAY",
    };
    [[ZDPayNetRequestManager sharedSingleton] zd_netRequestVC:self Params:dic postUrlStr:[NSString stringWithFormat:@"%@%@",DOMAINNAME,CHECKCARDTYPE] suscess:^(id  _Nullable responseObject) {
        if ([[responseObject objectForKey:@"code"] isEqualToString:@"200"]) {
            ZDPay_AddBankCardSecondViewController *vc = [ZDPay_AddBankCardSecondViewController new];
            vc.pay_AddBankModel = [ZDPay_AddBankModel mj_objectWithKeyValues:[responseObject objectForKey:@"data"]];
            vc.cardInfo = [responseObject objectForKey:@"data"];
            [self.navigationController pushViewController:vc animated:YES];
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
