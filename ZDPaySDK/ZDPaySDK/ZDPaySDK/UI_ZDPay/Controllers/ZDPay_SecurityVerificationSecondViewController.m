//
//  ZDPay_SecurityVerificationSecondViewController.m
//  ReadingEarn
//
//  Created by FANS on 2020/4/16.
//  Copyright © 2020 FANS. All rights reserved.
//

#import "ZDPay_SecurityVerificationSecondViewController.h"
#import "ZDPayFuncTool.h"
#import "ZD_PayForgetPasswordViewController.h"
#import "ZDPay_AddBankCardViewController.h"

@interface ZDPay_SecurityVerificationSecondViewController ()

@end

@implementation ZDPay_SecurityVerificationSecondViewController

- (void)viewDidLoad {

    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self.topNavBar setNavAndStatusBarColor:COLORWITHHEXSTRING(@"#F3F3F5", 1.0)];
    self.naviTitle = [[ZDPayInternationalizationModel sharedSingleten] getModelData].SECURITY_VERIFICATION;
    [self creatForgetPassSel:@selector(forgetPassAction:)];
}

- (void)creatForgetPassSel:(SEL)forgetPassAction {
    
    UILabel *titleLab = [UILabel new];
    [self.view addSubview:titleLab];
    titleLab.lineBreakMode = NSLineBreakByTruncatingTail;
    titleLab.numberOfLines = 0;
    titleLab.preferredMaxLayoutWidth = ScreenWidth-40;
    titleLab.textColor = COLORWITHHEXSTRING(@"#333333", 1.0);
    titleLab.font = ZD_Fout_Regular(16);
    titleLab.text = [[ZDPayInternationalizationModel sharedSingleten] getModelData].IDENTITY_VERIFICATION_VERIFY_YOUR_IDENTITY_BY_ENTERING_PAYMENT_PASSWORD;

    titleLab.textAlignment = NSTextAlignmentCenter;
    CGSize maximumLabelSize = CGSizeMake(ScreenWidth-40, 9999);
    CGSize expectSize = [titleLab sizeThatFits:maximumLabelSize];
    if (expectSize.width<ScreenWidth-102) {
        expectSize.width = ScreenWidth - 102;
    }
    titleLab.frame = CGRectMake(40, ratioH(54)+mcNavBarAndStatusBarHeight, expectSize.width, expectSize.height);
    
    NNValidationCodeView *view = [[NNValidationCodeView alloc] initWithFrame:CGRectMake(41, titleLab.bottom + 40, ScreenWidth-82, 50) andLabelCount:6 andLabelDistance:(ScreenWidth - 50*6 - 82)/5];
    [self.view addSubview:view];
    @WeakObj(self)
    view.codeBlock = ^(NSString *codeString) {
        @StrongObj(self)
        if (codeString.length == 6) {
            [self.view endEditing:YES];
            
            ZDPay_OrderSureModel *model = [[ZDPay_OrderSureModel sharedSingleten] getModelData];
            NSDictionary *dic = @{
                @"language":model.language,
                @"merId":model.merId,
                @"registerMobile":model.registerMobile,
                @"registerCountryCode":model.registerCountryCode,
                @"password":codeString,
                @"operation":@"1"//0:支付,1:绑卡校验密码
            };
            [[ZDPayNetRequestManager sharedSingleton] zd_netRequestVC:self Params:dic postUrlStr:[NSString stringWithFormat:@"%@%@",DOMAINNAME,CHECKPAYPWD] suscess:^(id  _Nullable responseObject) {
                if ([[responseObject objectForKey:@"code"] isEqualToString:@"200"]) {
                    ZDPay_AddBankCardViewController *vc = [ZDPay_AddBankCardViewController new];
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }];
        }
    };

    CGRect forgetPassRect = [ZDPayFuncTool getStringWidthAndHeightWithStr:[[ZDPayInternationalizationModel sharedSingleten] getModelData].FORGOT_PASSWORD withFont:ZD_Fout_Regular(ratioH(14))];
    UIButton *forgetPassBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:forgetPassBtn];
    [forgetPassBtn setTitle:[[ZDPayInternationalizationModel sharedSingleten] getModelData].FORGOT_PASSWORD forState:UIControlStateNormal];
    forgetPassBtn.titleLabel.font = ZD_Fout_Regular(ratioH(14));
    [forgetPassBtn setTitleColor:COLORWITHHEXSTRING(@"#FFB300", .7) forState:UIControlStateNormal];
    forgetPassBtn.frame = CGRectMake(ScreenWidth - 41 - forgetPassRect.size.width, view.bottom+20, forgetPassRect.size.width, ratioH(14));
    [forgetPassBtn addTarget:self action:forgetPassAction forControlEvents:UIControlEventTouchUpInside];
}

- (void)forgetPassAction:(UIButton *)sender {
    ZD_PayForgetPasswordViewController *vc = [ZD_PayForgetPasswordViewController new];
    [self.navigationController pushViewController:vc animated:YES];

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
