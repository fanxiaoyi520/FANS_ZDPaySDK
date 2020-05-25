//
//  ZDPay_MyWalletViewController.m
//  ReadingEarn
//
//  Created by FANS on 2020/4/16.
//  Copyright © 2020 FANS. All rights reserved.
//

#import "ZDPay_MyWalletViewController.h"
#import "ZDPayFuncTool.h"
#import "ZDPay_MywalletTableViewCell.h"
#import "ZDPay_AddBankCardViewController.h"
#import "ZDPay_OrderSureBankListRespModel.h"
#import "ZDPay_OrderSureRespModel.h"
#import "ZDPay_SecurityVerificationSecondViewController.h"

typedef void (^UnbindCallback)(NSString *text);

typedef void(^BindingResultBlock) (id _Nonnull responseObject);
typedef void(^UntyingResultBlock) (id _Nonnull responseObject);
@interface ZDPay_MyWalletViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic ,copy)BindingResultBlock bindingResultBlock;
@property (nonatomic ,copy)UntyingResultBlock untyingResultBlock;

@property (nonatomic ,strong)UITableView *myWalletTableView;
@property (nonatomic ,copy)NSString *untyingStr;
@property (nonatomic ,copy)NSString *bindingStr;
@property (nonatomic ,copy)UnbindCallback unbindCallback;
@property (nonatomic ,strong)ZDPay_OrderSureRespModel *pay_OrderSureRespModel;
@property (nonatomic ,strong)NSMutableArray *bankDataList;
@property (nonatomic ,strong)NSMutableArray *receiveArray;
@end

@implementation ZDPay_MyWalletViewController
+ (instancetype)manager {
    return [[[self class] alloc] init];
}

- (void)ZDPay_WalletResultCallbackWithBindingResult:(void (^)(id _Nonnull responseObject))bindingResult
                                      untyingResult:(void (^)(id _Nonnull reason))untyingResult {
    self.bindingResultBlock = bindingResult;
    self.untyingResultBlock = untyingResult;
}

- (void)bindBankCardSucceeded:(NSNotification *)noti {
    [self.myWalletTableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
    [self getDataFromNetWorkingOrderSure:YES];
    [self showMessage:[[ZDPayInternationalizationModel sharedSingleten] getModelData].BIND_SUCCESSFULLY target:nil];
}

- (void)setUpPayPassword:(NSNotification *)noti {
    [self.myWalletTableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
    [self getDataFromNetWorkingOrderSure:YES];
    [self showMessage:[[ZDPayInternationalizationModel sharedSingleten] getModelData].PASSWORD_WAS_SUCCESSFULLY_CREATED target:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self.topNavBar setNavAndStatusBarColor:COLORWITHHEXSTRING(@"#FFFFFF", 1.0)];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setUpPayPassword:) name:SETUPPAYMENTFEED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bindBankCardSucceeded:) name:BINDBANKCARDSUCCEEDED object:nil];

    if (self.walletType == WalletType_Untying) {
        self.untyingStr = [[ZDPayInternationalizationModel sharedSingleten] getModelData].UNBIND;
        self.bindingStr = nil;
        self.naviTitle = [[ZDPayInternationalizationModel sharedSingleten] getModelData].MY_WALLET;
        [self myWalletTableView];
    } else {
        self.bindingStr = @"icon_add";
        self.untyingStr = nil;
        [self getDataFromNetWorkingAppInternationalization];
    }

    @WeakObj(self)
    [self.topNavBar addBankCardBTnTitle:self.untyingStr btnImage:self.bindingStr BankJumpBlock:^(UIButton * _Nonnull sender) {
        @StrongObj(self)
        if (self.walletType == WalletType_Untying) {
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否确认解绑银行卡？" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction * cancelAc = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        //点击取消要执行的代码
                    }];
                    UIAlertAction *comfirmAc = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        [self getDataFromNetWorkingUntying];
            }];
            [alertVC addAction:cancelAc];
            [alertVC addAction:comfirmAc];
            [self presentViewController:alertVC animated:YES completion:nil];
        } else {
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
        }
    }];
    self.view.backgroundColor = COLORWITHHEXSTRING(@"#F3F3F5", 1.0);
}

#pragma mark - lazy loading
- (UITableView *)myWalletTableView {
    if (!_myWalletTableView) {
        _myWalletTableView = [[UITableView alloc] initWithFrame:CGRectMake(16, mcNavBarAndStatusBarHeight, ScreenWidth-32, ScreenHeight-mcNavBarAndStatusBarHeight) style:UITableViewStylePlain];
        _myWalletTableView.delegate = self;
        _myWalletTableView.dataSource = self;
        _myWalletTableView.backgroundView = nil;
        _myWalletTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _myWalletTableView.backgroundColor = [UIColor clearColor];
        _myWalletTableView.showsVerticalScrollIndicator = NO;
        _myWalletTableView.showsHorizontalScrollIndicator = NO;
        [self.view addSubview:_myWalletTableView];
    }
    return _myWalletTableView;
}

- (NSMutableArray *)bankDataList {
    if (!_bankDataList) {
        _bankDataList = [NSMutableArray array];
    }
    return _bankDataList;
}

- (NSMutableArray *)receiveArray {
    if (!_receiveArray) {
        _receiveArray = [NSMutableArray array];
    }
    return _receiveArray;
}

#pragma mark - delegate and datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.walletType == WalletType_Untying) {
        return self.receiveArray.count;
    } else {
        return self.bankDataList.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellid = @"cellid";
    ZDPay_MywalletTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[ZDPay_MywalletTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundView = nil;
        cell.backgroundColor = [UIColor clearColor];
    }
    
    if (self.walletType == WalletType_Untying) {
        [cell layoutAndLoadData:self.receiveArray[indexPath.row]];
    } else {
        [cell layoutAndLoadData:self.bankDataList[indexPath.row]];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    __block float x;
    ZDPay_OrderBankListTokenModel *model;
    if (self.walletType == WalletType_Untying) {
        model = self.receiveArray[indexPath.row];
    } else {
        model = self.bankDataList[indexPath.row];
    }
    
    if (model.cardBgImage.length < 5) {
        UIImage *image = [UIImage imageNamed:@"card_yajincz"];
        x=image.size.height*(ScreenWidth-32)/image.size.width;
    } else {
        NSData * data = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:model.cardBgImage]];
        UIImage *image = [[UIImage alloc]initWithData:data];
        x=image.size.height*(ScreenWidth-32)/image.size.width;
    }
    return x + 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.walletType == WalletType_Untying) {
        NSLog(@"解绑");
    } else {
        [self.receiveArray removeAllObjects];
        ZDPay_OrderBankListTokenModel *model = self.bankDataList[indexPath.row];
        [[ZDPay_OrderBankListTokenModel sharedSingleten] setModelProcessingDic:[model mj_keyValues]];
        ZDPay_MyWalletViewController *vc = [ZDPay_MyWalletViewController new];
        vc.walletType = WalletType_Untying;
        [vc.receiveArray addObject:[self.bankDataList objectAtIndex:indexPath.row]];
        @WeakObj(self)
        vc.unbindCallback = ^(NSString *text) {
            @StrongObj(self)
            [self showMessage:text target:nil];
            [self.bankDataList removeObject:[self.bankDataList objectAtIndex:indexPath.row]];
            [self.myWalletTableView reloadData];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - get data
- (void)getDataFromNetWorkingOrderSure:(BOOL)isRefresh {
    if (isRefresh == YES) {
        [self.bankDataList removeAllObjects];
    }
    NSDictionary *paramsDic = [[[ZDPay_OrderSureModel sharedSingleten] getModelData] mj_JSONObject];
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
                    ZDPay_OrderBankListTokenModel *model = [ZDPay_OrderBankListTokenModel mj_objectWithKeyValues:obj];
                    [self.bankDataList addObject:model];
                }];
            }

            if (isRefresh == YES) {
                if (!(self.bankDataList.count == 0)) {
                    UIImageView *backImageView = [self.view viewWithTag:1000];
                    UILabel *tishiLab = [self.view viewWithTag:1001];
                    backImageView.hidden = YES;
                    tishiLab.hidden = YES;
                }
                [self.myWalletTableView reloadData];
            } else {
                if (self.bankDataList.count == 0) {
                    [self noneBankUI];
                } else {
                    [self myWalletTableView];
                }

            }
        }
    }];
}

- (void)getDataFromNetWorkingOrderSureRefresh {
    [self.bankDataList removeAllObjects];
    ZDPay_OrderSureModel *model = [[ZDPay_OrderSureModel sharedSingleten] getModelData];
    NSDictionary *paramsDic = [model mj_keyValues];
    [[ZDPayNetRequestManager sharedSingleton] zd_netRequestVC:self Params:paramsDic postUrlStr:[NSString stringWithFormat:@"%@%@",DOMAINNAME,QUERYPAYMETHOD] suscess:^(id  _Nullable responseObject) {
        if ([[responseObject objectForKey:@"code"] isEqualToString:@"200"]) {
            ZDPay_OrderSureRespModel *model = [ZDPay_OrderSureRespModel mj_objectWithKeyValues:[responseObject objectForKey:@"data"]];
            [[ZDPay_OrderSureRespModel sharedSingleten] setModelProcessingDic:[responseObject objectForKey:@"data"]];
            self.pay_OrderSureRespModel = model;
            if (self.pay_OrderSureRespModel.bankList.Token) {
                [self.pay_OrderSureRespModel.bankList.Token enumerateObjectsUsingBlock:^(ZDPay_OrderBankListTokenModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    ZDPay_OrderBankListTokenModel *model = [ZDPay_OrderBankListTokenModel mj_objectWithKeyValues:obj];
                    [self.bankDataList addObject:model];
                }];
            }
            [self.myWalletTableView reloadData];
        }
    }];
}


- (void)getDataFromNetWorkingUntying {
    ZDPay_OrderSureModel *model = [[ZDPay_OrderSureModel sharedSingleten] getModelData];
    ZDPay_OrderBankListTokenModel *listModel = [[ZDPay_OrderBankListTokenModel sharedSingleten] getModelData];
    NSDictionary *dic = @{
        @"language": model.language,
        @"registerCountryCode": model.registerCountryCode,
        @"registerMobile": model.registerMobile,
        @"cardNum":listModel.cardId,
        @"merId": model.merId,
        @"payType": listModel.cardType,
    };

    @WeakObj(self);
    [[ZDPayNetRequestManager sharedSingleton] zd_netRequestVC:self Params:dic postUrlStr:[NSString stringWithFormat:@"%@%@",DOMAINNAME,UNBINDBANKCARD] suscess:^(id  _Nullable responseObject) {
        @StrongObj(self)
        if ([[responseObject objectForKey:@"code"] isEqualToString:@"200"]) {
            self.unbindCallback(@"解绑成功");
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

//国际化
- (void)getDataFromNetWorkingAppInternationalization {
    NSDictionary *dic = [[ZDPayFuncTool sharedSingleton] getAppInternationalizationDictionary];
    [[ZDPayNetRequestManager sharedSingleton] zd_netRequestVC:self Params:dic postUrlStr:[NSString stringWithFormat:@"%@%@",DOMAINNAME,GETALLLANGUAGES] suscess:^(id  _Nullable responseObject) {
        NSLog(@"responseObject:%@",responseObject);
        [[ZDPayInternationalizationModel sharedSingleten] setModelProcessingDic:[responseObject objectForKey:@"data"]];

        self.naviTitle = [[ZDPayInternationalizationModel sharedSingleten] getModelData].MY_WALLET;
        [self getDataFromNetWorkingOrderSure:NO];

    }];
}

#pragma mark - 暂无银行卡
- (void)noneBankUI {
    UIImageView *backImageView = [UIImageView new];
    backImageView.tag = 1000;
    [self.view addSubview:backImageView];
    backImageView.image = [UIImage imageNamed:@"pic_wuka"];
    backImageView.frame = CGRectMake((ScreenWidth - 200)/2, mcNavBarAndStatusBarHeight+160, 200, 128);
    
    UILabel *tishiLab = [UILabel new];
    tishiLab.tag = 1001;
    tishiLab.frame = CGRectMake(0, backImageView.bottom+20, ScreenWidth, 15);
    tishiLab.text =  [[ZDPayInternationalizationModel sharedSingleten] getModelData].You_haven_added_your_card_yet;
    tishiLab.textAlignment = NSTextAlignmentCenter;
    tishiLab.font = [UIFont systemFontOfSize:16];
    tishiLab.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1/1.0];
    [self.view addSubview:tishiLab];
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
