//
//  ZDPay_SetConfirPasswordViewController.m
//  ZDPaySDK
//
//  Created by FANS on 2020/4/23.
//  Copyright © 2020 ZhongDaoGroup. All rights reserved.
//

#import "ZDPay_SetConfirPasswordViewController.h"
#import "ZDPayFuncTool.h"
#import "ZDPay_OrderSureViewController.h"
#import "ZDPay_MyWalletViewController.h"

@interface ZDPay_SetConfirPasswordViewController ()

@property (nonatomic ,copy)NSString *password;
@end

@implementation ZDPay_SetConfirPasswordViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.naviTitle  = [[ZDPayInternationalizationModel sharedSingleten] getModelData].SECURITY_VERIFICATION;
    if (self.showTips) {
        [self showMessage:self.showTips target:nil];
    }
    self.view.backgroundColor = [UIColor whiteColor];
    [self.topNavBar setNavAndStatusBarColor:COLORWITHHEXSTRING(@"#F3F3F5", 1.0)];
    [self creatSetConfirmationPassword];
}

- (void)creatSetConfirmationPassword {
    UILabel *titleLab = [UILabel new];
    [self.view addSubview:titleLab];
    titleLab.textColor = COLORWITHHEXSTRING(@"#333333", 1.0);
    titleLab.font = ZD_Fout_Regular(16);
    titleLab.frame = CGRectMake(0, ratioH(54)+mcNavBarAndStatusBarHeight, ScreenWidth, 16);
    titleLab.textAlignment = NSTextAlignmentCenter;
    if (!self.isSurePass) {
        titleLab.text = [[ZDPayInternationalizationModel sharedSingleten] getModelData].PLEASE_SET_NEW_PASSWORD;
    } else {
        titleLab.text = [[ZDPayInternationalizationModel sharedSingleten] getModelData].PLEASE_CONFIRM_PASSWORD;
    }
    
    NNValidationCodeView *view = [[NNValidationCodeView alloc] initWithFrame:CGRectMake(41, mcNavBarAndStatusBarHeight + ratioH(110), ScreenWidth-82, 50) andLabelCount:6 andLabelDistance:(ScreenWidth - 50*6 - 82)/5];
    [self.view addSubview:view];
    @WeakObj(self)
    view.codeBlock = ^(NSString *codeString) {
        self.password = codeString;
        @StrongObj(self)
        if (!self.isSurePass) {
            if (codeString.length == 6) {
                if (self.isFirstSetPassword == YES) {
                    [self getDataFromNetWorkingSetPayPassword];
                } else {
                    [self getDataFromNetWorkingChangePayPassword];
                }
            }
        } else {
            if (codeString.length == 6) {
                if ([codeString isEqualToString:self.codeString]) {
                    [self getDataFromNetWorkingSurePayPassword];
                } else {
                    [self showMessage:@"两次密码不一致,请重新输入" target:nil];
                }
            }
        }
    };
}

#pragma mark - sure passwrod data
- (void)getDataFromNetWorkingSetPayPassword {
    ZDPay_OrderSureModel *model = [[ZDPay_OrderSureModel sharedSingleten] getModelData];
    NSDictionary *dic = @{
        @"language":model.language,
        @"registerMobile":model.registerMobile,
        @"registerCountryCode":model.registerCountryCode,
        @"password":self.password,
        @"isSendPurchase":model.isSendPurchase
    };
    
    [[ZDPayNetRequestManager sharedSingleton] zd_netRequestVC:self Params:dic postUrlStr:[NSString stringWithFormat:@"%@%@",DOMAINNAME,SETPAYPWD] suscess:^(id  _Nullable responseObject) {
        if ([[responseObject objectForKey:@"code"] isEqualToString:@"200"]) {
            ZDPay_SetConfirPasswordViewController *vc = [ZDPay_SetConfirPasswordViewController new];
            vc.isSurePass = YES;
            vc.codeString = self.password;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
}

- (void)getDataFromNetWorkingChangePayPassword {
    ZDPay_OrderSureModel *model = [[ZDPay_OrderSureModel sharedSingleten] getModelData];
    NSDictionary *dic = @{
        @"language":model.language,
        @"registerMobile":model.registerMobile,
        @"registerCountryCode":model.registerCountryCode,
        @"password":self.password,
        @"reToken":self.reToken
    };
    
    [[ZDPayNetRequestManager sharedSingleton] zd_netRequestVC:self Params:dic postUrlStr:[NSString stringWithFormat:@"%@%@",DOMAINNAME,CHANGEACCOUNTPWD] suscess:^(id  _Nullable responseObject) {
        if ([[responseObject objectForKey:@"code"] isEqualToString:@"200"]) {
            ZDPay_SetConfirPasswordViewController *vc = [ZDPay_SetConfirPasswordViewController new];
            vc.isSurePass = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
}

- (void)getDataFromNetWorkingSurePayPassword {
   [[NSNotificationCenter defaultCenter] postNotificationName:SETUPPAYMENTFEED object:self userInfo:nil];
   for (UIViewController *temp in self.navigationController.viewControllers) {
       if ([temp isKindOfClass:[ZDPay_OrderSureViewController class]]) {
           [self.navigationController popToViewController:temp animated:YES];
       }
    
       if ([temp isKindOfClass:[ZDPay_MyWalletViewController class]]) {
           [self.navigationController popToViewController:temp animated:YES];
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
