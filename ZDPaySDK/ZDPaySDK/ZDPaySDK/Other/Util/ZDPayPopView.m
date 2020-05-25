
//
//  ZDPayPopView.m
//  ReadingEarn
//
//  Created by FANS on 2020/4/15.
//  Copyright © 2020 FANS. All rights reserved.
//

#import "ZDPayPopView.h"
#import "ZDPayFuncTool.h"
#import "ZDPay_OrderSurePayListRespModel.h"

@interface ZDPayPopView()<UIGestureRecognizerDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic ,weak)UIWindow *myWindow;
@property (nonatomic ,strong)UIView *coverView;
@property (nonatomic ,assign)ZDPayPopViewEnum type;
@property (nonatomic ,copy)NSString *data;
@property (nonatomic ,strong)NSDictionary *model;
@property (nonatomic ,strong)ZDPay_OrderSurePayListRespModel *pay_OrderSurePayListRespModel;
@property (nonatomic ,strong)NSString *boxInputViewstr;
@property (nonatomic ,strong)UIButton *certainButton;
@property (nonatomic ,strong)NSArray *gratypeArray;
@property (nonatomic ,copy)NSString *gratype_idStr;
@property (nonatomic ,assign)NSInteger btnTag;

@property (nonatomic ,strong)UITableView *popTableView;
@property (nonatomic ,strong)NSMutableArray *dataList;
@property (nonatomic ,strong)NSMutableArray *dataPointList;
@property (nonatomic ,strong)NSIndexPath *oldIndexPath;
@property (nonatomic ,strong)UITableViewCell *oldCell;
@end
@implementation ZDPayPopView

#pragma mark - private
- (instancetype)initWithFrame:(CGRect)frame withType:(ZDPayPopViewEnum)type
{
    self = [super initWithFrame:frame];
    if (self) {
        self.type = type;
        [self initialize];
    }
    return self;
}

- (void)initialize {

    self.myWindow = [UIApplication sharedApplication].keyWindow;
    self.coverView = [UIView new];
    [self.myWindow addSubview:self.coverView];
    self.coverView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeThePopupView)];
    [self.coverView addGestureRecognizer:tap];
    
    if (self.type == SetPaymentPassword) {
        self.coverView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        self.coverView.alpha = 0.5;

        [self re_loadSetPaymentPasswordUI];
    } else if (self.type == DocumentType) {
        self.coverView.backgroundColor = [UIColor clearColor];

        [self re_loadDocumentTypeUI];
    } else if (self.type == CellPhoneAreaCode) {
        self.coverView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        self.coverView.alpha = 0.5;

        [self re_loadCellPhoneAreaCodeUI];
    } else if (self.type == SelectPayMethod) {
        self.coverView.backgroundColor = COLORWITHHEXSTRING(@"#000000", .5);
        
        [self re_loadSelectPayMethodUI];
    } else if (self.type == CreditCardInputdemonstration) {
        self.coverView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        self.coverView.alpha = 0.5;
        [self re_loadCreditCardInputdemonstrationUI];
    }
}

- (void)re_loadCreditCardInputdemonstrationUI {
    UIImageView *backImage = [UIImageView new];
    [self addSubview:backImage];
    backImage.tag = 10;
    backImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeThePopupView)];
    tap.delegate = self;
    [backImage addGestureRecognizer:tap];
    
    UILabel *tishiLabel = [UILabel new];
    tishiLabel.tag = 20;
    [self addSubview:tishiLabel];
    tishiLabel.textAlignment = NSTextAlignmentLeft;
    tishiLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    tishiLabel.numberOfLines = 0;
    tishiLabel.preferredMaxLayoutWidth = ScreenWidth;
    tishiLabel.font = ZD_Fout_Medium(15);
    tishiLabel.textColor = COLORWITHHEXSTRING(@"#666666", 1.0);
}

- (void)re_loadSelectPayMethodUI {
    [self popTableView];
}

- (NSMutableArray *)dataList {
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

- (NSMutableArray *)dataPointList {
    if (!_dataPointList) {
        _dataPointList = [NSMutableArray array];
    }
    return _dataPointList;
}

- (UITableView *)popTableView {
    if (!_popTableView) {
        _popTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [self addSubview:_popTableView];
        _popTableView.delegate = self;
        _popTableView.dataSource = self;
        _popTableView.bounces = NO;
        _popTableView.showsVerticalScrollIndicator = NO;
        _popTableView.separatorStyle = UITableViewCellSelectionStyleNone;
        _popTableView.showsHorizontalScrollIndicator = YES;
        _popTableView.backgroundColor = [UIColor whiteColor];
    }
    return _popTableView;
}

- (void)re_loadCellPhoneAreaCodeUI {
    [self popTableView];
}

- (void)re_loadDocumentTypeUI {
    UIView *bgView = [UIView new];
    [self addSubview:bgView];
    bgView.userInteractionEnabled = YES;
    
    for (int i = 0; i<5; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:btn];
        btn.tag = 10+i;
        btn.titleLabel.textAlignment = NSTextAlignmentLeft;
        [btn setTitleColor:COLORWITHHEXSTRING(@"#333333", 1.0) forState:UIControlStateNormal];
        btn.titleLabel.font = ZD_Fout_Regular(16);
        [btn addTarget:self action:@selector(documentTypeAction:) forControlEvents:UIControlEventTouchUpInside];
       
        UIView *lineView = [UIView new];
        lineView.backgroundColor = COLORWITHHEXSTRING(@"#E9EBEE", 1.0);
        lineView.tag = 100 + i;
        [self addSubview:lineView];
        
    }
}

- (void)re_loadSetPaymentPasswordUI {
    //1.
    UILabel *titleLabel = [UILabel new];
    titleLabel.tag = 10;
    titleLabel.textColor = COLORWITHHEXSTRING(@"#666666;", 1.0);
    [self addSubview:titleLabel];
    
    //2.
    UILabel *moneyNumberLab = [UILabel new];
    moneyNumberLab.textColor = COLORWITHHEXSTRING(@"#333333", 1.0);
    moneyNumberLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:moneyNumberLab];
    moneyNumberLab.tag = 20;
    
    //线条
    UIView *lineView = [UIView new];
    [self addSubview:lineView];
    lineView.tag = 60;
    lineView.backgroundColor = COLORWITHHEXSTRING(@"#DDDDDD", 1.0);
    
    //支付银行
    UIImageView *bankImageView = [UIImageView new];
    [self addSubview:bankImageView];
    bankImageView.tag = 70;
    
    UILabel *bankLabel = [UILabel new];
    [self addSubview:bankLabel];
    bankLabel.textColor = COLORWITHHEXSTRING(@"#333333", 1.0);
    bankLabel.textAlignment = NSTextAlignmentLeft;
    bankLabel.tag = 80;

    //4.
    UIButton *forgetPassBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.certainButton = forgetPassBtn;
    forgetPassBtn.titleLabel.font = ZD_Fout_Regular(14);
    forgetPassBtn.tag = 40;
    forgetPassBtn.layer.cornerRadius = 17.5;
    [forgetPassBtn setTitle:[[ZDPayInternationalizationModel sharedSingleten] getModelData].FORGOT_PASSWORD forState:UIControlStateNormal];
    [forgetPassBtn addTarget:self action:@selector(forgetPassBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [forgetPassBtn setTitleColor:COLORWITHHEXSTRING(@"#FFB300", 1.0) forState:UIControlStateNormal];
    [self addSubview:forgetPassBtn];
    
    //3.
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    closeButton.tag = 50;
    [closeButton addTarget:self action:@selector(closeThePopupView) forControlEvents:UIControlEventTouchUpInside];
    [closeButton setImage:REImageName(@"icon_close") forState:UIControlStateNormal];
    [self addSubview:closeButton];
}

- (void)layoutAndLoadDataCreditCardInputdemonstration:(NSString *)imageStr labStr:(NSString *)labStr {
    UIImageView *backImage = [self viewWithTag:10];
    backImage.frame = CGRectMake(0, 0, self.width, self.height);
    backImage.image = [UIImage imageNamed:imageStr];
    
    UILabel *tishiLabel = [self viewWithTag:20];
    tishiLabel.text = labStr;
    CGSize maximumLabelSize = CGSizeMake(self.width-40, 9999);
    CGSize expectSize = [tishiLabel sizeThatFits:maximumLabelSize];
    if (expectSize.width<self.width-40) {
        expectSize.width = self.width - 40;
    }
    
    tishiLabel.frame = CGRectMake(20, (self.height-expectSize.height-20.5), expectSize.width, expectSize.height);
    [ZDPayFuncTool LabelAttributedString:tishiLabel FontNumber:ZD_Fout_Medium(13) AndRange:NSMakeRange(15, 6) AndColor:COLORWITHHEXSTRING(@"#FFB300", 1.0)];
}

- (void)layoutAndLoadDataPaymentPassword {
    //1.
    CGRect titleRect = [ZDPayFuncTool getStringWidthAndHeightWithStr:[[ZDPayInternationalizationModel sharedSingleten] getModelData].PASSWORD withFont:ZD_Fout_Regular(16)];
    UILabel *titleLabel = [self viewWithTag:10];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    NSMutableAttributedString *titleLabelstring = [[NSMutableAttributedString alloc] initWithString:[[ZDPayInternationalizationModel sharedSingleten] getModelData].PASSWORD attributes:@{NSFontAttributeName: ZD_Fout_Regular(16), NSForegroundColorAttributeName: COLORWITHHEXSTRING(@"#666666", 1.0)}];
    titleLabel.attributedText = titleLabelstring;
    titleLabel.frame = CGRectMake((self.width-titleRect.size.width)/2, 24, titleRect.size.width, 25);
    
    //2.
    UILabel *moneyNumberLab = [self viewWithTag:20];
    NSString *amountMoneyStr = [ZDPayFuncTool formatToTwoDecimal:[[ZDPay_OrderSureModel sharedSingleten] getModelData].txnAmt];
    moneyNumberLab.frame = CGRectMake(0, titleLabel.bottom+20, self.width, 24);
    moneyNumberLab.text = [NSString stringWithFormat:@"HK$ %@",amountMoneyStr];
    [ZDPayFuncTool LabelAttributedString:moneyNumberLab FontNumber:ZD_Fout_Medium(30) AndRange:NSMakeRange(4, amountMoneyStr.length-2) AndColor:nil];
        
    //线条
    UIView *lineview = [self viewWithTag:60];
    lineview.frame = CGRectMake(0, 121, self.width, .5);
    
    //支付银行
    UIImageView *banImageview = [self viewWithTag:70];
    banImageview.frame = CGRectMake(21, lineview.bottom + 23, 17, 17);
    
    
    UILabel *bankLabel = [self viewWithTag:80];
    bankLabel.frame = CGRectMake(banImageview.right + 10, lineview.bottom + 24, self.width-58, 16);
    
    if (![self.pay_OrderSurePayListRespModel.channelCode isEqualToString:@""]) {
        if (self.pay_OrderSurePayListRespModel.imgUrl) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSData * data = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:self.pay_OrderSurePayListRespModel.imgUrl]];
                UIImage *image = [[UIImage alloc]initWithData:data];
                if (data != nil) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        banImageview.image = image;
                    });
                }
            });
        } else {
            banImageview.image = DEFAULT_IMAGE;
        }
        
        bankLabel.text = self.pay_OrderSurePayListRespModel.name;
    } else {
        if (self.pay_OrderSurePayListRespModel.cardBgImage) {
            banImageview.image = [UIImage imageWithData:[[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:self.pay_OrderSurePayListRespModel.cardMsg]]];
        } else {
            banImageview.image = DEFAULT_IMAGE;
        }
        bankLabel.text = self.pay_OrderSurePayListRespModel.bankName;
    }

    CGFloat spacing = (self.width-42-44*6)/6;
    NNValidationCodeView *view = [[NNValidationCodeView alloc] initWithFrame:CGRectMake(21, lineview.bottom + 64, self.width-42, 44) andLabelCount:6 andLabelDistance:spacing];
    [self addSubview:view];
    @WeakObj(self)
    view.codeBlock = ^(NSString *codeString) {
        @StrongObj(self)
        BOOL isFinished = NO;
        if (codeString.length == 6) {
            isFinished = YES;
            self.boxInputViewstr = codeString;
            if (self.setPaymentPassword) {
                self.setPaymentPassword(codeString, isFinished);
            }
        }
    };

    //4.
    UIButton *certainButton = [self viewWithTag:40];
    CGRect forgetPassBtnRect = [ZDPayFuncTool getStringWidthAndHeightWithStr:[[ZDPayInternationalizationModel sharedSingleten] getModelData].FORGOT_PASSWORD withFont:ZD_Fout_Regular(14)];
    certainButton.frame = CGRectMake(self.width-19-forgetPassBtnRect.size.width, lineview.bottom + 128, forgetPassBtnRect.size.width, 14);
    
    //5.
    UIButton *closeButton = [self viewWithTag:50];
    closeButton.frame = CGRectMake(self.width - 30, 10, 20, 20);
}

- (void)layoutAndLoadDataDocumentType:(NSArray *)array myCell:(UITableViewCell *)myCell {
    
    for (int i=0; i<array.count; i++) {
        UIButton *btn = (UIButton *)[self viewWithTag:10+i];
        [btn setTitle:array[i] forState:UIControlStateNormal];
        btn.frame = CGRectMake(0, 0+i*(self.height/5), self.width, myCell.size.height);
        UIView *lineView = [self viewWithTag:100+i];
        lineView.frame = CGRectMake(10, i*(.5+(self.height/5-.5)), self.width-10, .5);
    }
}

- (void)layoutAndLoadDataCellPhoneAreaCode {
    self.popTableView.frame = CGRectMake(0, 0, self.width, self.height);
    [ZDPayFuncTool setupRoundedCornersWithView:self.popTableView cutCorners:UIRectCornerTopLeft | UIRectCornerTopRight borderColor:nil cutCornerRadii:CGSizeMake(10, 10) borderWidth:0 viewColor:nil];
}

- (void)layoutAndLoadDataSelectPayMethod {
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:closeBtn];
    [closeBtn addTarget:self action:@selector(closeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [closeBtn setImage:[UIImage imageNamed:@"icon_close"] forState:UIControlStateNormal];
    closeBtn.frame = CGRectMake(self.width-20-20, 20, 20, 20);
    
    self.popTableView.frame = CGRectMake(0, 0, self.width, self.height);
}

- (void)closeBtnAction:(UIButton *)sender {
    [self closeThePopupView];
}

- (void)forgetPassBtnAction:(UIButton *)sender {
    if (self.forgetPassword) {
        self.forgetPassword();
    }
}

- (void)documentTypeAction:(UIButton *)sender {
    if (self.documentType) {
        self.documentType(sender);
    }
}

#pragma mark delegate && datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.type == SelectPayMethod) {

        if (self.dataList.count > 5) {
            return self.dataList.count+1;
        } else {
            if (self.dataPointList.count < 5) {
                 return self.dataList.count+1;
            }
            
            if (self.dataPointList.count >= 5){
                return self.dataList.count+2;
            }
        }
    }
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.type == SelectPayMethod) {
        static NSString *cellid = @"cellids";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundView = nil;
            cell.backgroundColor = [UIColor clearColor];
            UIView *lineView = [UIView new];
            lineView.backgroundColor = COLORWITHHEXSTRING(@"#E9EBEE", 1.0);
            [cell.contentView addSubview:lineView];
            lineView.tag = 200;
            
            UIImageView *selImageView = [UIImageView new];
            selImageView.tag = 300;
            [cell.contentView addSubview:selImageView];
        }
        
        UIView *lineView  = [cell.contentView viewWithTag:200];
        lineView.frame = CGRectMake(17, 60.5, self.width-17, .5);

        
        if (indexPath.row>=0 && indexPath.row< self.dataList.count){
            ZDPay_OrderSurePayListRespModel *model = self.dataList[indexPath.row];

            UIImage *image = [UIImage imageWithData:[[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:model.cardMsg]]];
            UIImage *newImage = [ZDPayFuncTool scaleToSize:image size:CGSizeMake(16, 16)];
            cell.imageView.image = newImage;
            
            cell.textLabel.text = [NSString stringWithFormat:@"%@(%@)",model.bankName,model.cardNum];
            cell.textLabel.textColor = COLORWITHHEXSTRING(@"#333333", 1.0);
            cell.textLabel.font = [UIFont systemFontOfSize:16];
            
            
            UIImageView *selImageView = [cell.contentView viewWithTag:300];
            selImageView.frame = CGRectMake(self.width-20-17, 20, 17, 17);
            if ([self.pay_OrderSurePayListRespModel.bankName isEqualToString:model.bankName]) {
                selImageView.image = [UIImage imageNamed:@"btn_choose"];
                self.oldCell = cell;
                self.oldIndexPath = indexPath;
            } else {
                selImageView.image = [UIImage imageNamed:@"btn_unch"];
            }
        }
        if (indexPath.row == self.dataList.count){

            UIImage *image = [UIImage imageNamed:@"icon_card_add"];
            UIImage *newImage = [ZDPayFuncTool scaleToSize:image size:CGSizeMake(19, 16)];
            cell.imageView.image = newImage;
            
            cell.textLabel.text = [[ZDPayInternationalizationModel sharedSingleten] getModelData].ADD_BANK_CARD;
            cell.textLabel.textColor = COLORWITHHEXSTRING(@"#333333", 1.0);
            cell.textLabel.font = [UIFont systemFontOfSize:16];
            
            
            UIImageView *selImageView = [cell.contentView viewWithTag:300];
            selImageView.image = [UIImage imageNamed:@"icon_add"];
            selImageView.frame = CGRectMake(self.width-20-17, 20, 17, 17);
        }
        
        if (self.dataList.count <= 5 && self.dataPointList.count > 5) {
            if (indexPath.row == self.dataList.count+1) {
                UIImage *image = [UIImage imageNamed:@""];
                UIImage *newImage = [ZDPayFuncTool scaleToSize:image size:CGSizeMake(19, 16)];
                cell.imageView.image = newImage;
                
                NSString *AND_MORE_BANK_CARD = [NSString stringWithFormat:@"%@ >",[[ZDPayInternationalizationModel sharedSingleten] getModelData].AND_MORE_BANK_CARD];
                cell.textLabel.text = AND_MORE_BANK_CARD;
                cell.textLabel.textColor = COLORWITHHEXSTRING(@"#999999", 1.0);
                cell.textLabel.font = [UIFont systemFontOfSize:14];
            }
        }

        return cell;
    } else {
        static NSString *cellid = @"cellid";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor whiteColor];
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            UIView *lineView = [UIView new];
            lineView.backgroundColor = COLORWITHHEXSTRING(@"#E9EBEE", 1.0);
            [cell.contentView addSubview:lineView];
            lineView.tag = 200;
        }
        
        UIView *lineView  = [cell.contentView viewWithTag:200];
        lineView.frame = CGRectMake(0, 49.5, self.width, .5);
        cell.textLabel.textColor = COLORWITHHEXSTRING(@"#999999", 1.0);
        cell.textLabel.text = [NSString stringWithFormat:@"%@",self.dataList[indexPath.row]];
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.type == SelectPayMethod) {
        return 61;
    }
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [UIView new];
    if (self.type == SelectPayMethod) {
        view.backgroundColor = [UIColor whiteColor];
        
        CGRect rect = [ZDPayFuncTool getStringWidthAndHeightWithStr:[[ZDPayInternationalizationModel sharedSingleten] getModelData].SELECTE_PAYMENT_METHOD withFont:[UIFont boldSystemFontOfSize:16]];
        UILabel *label = [UILabel new];
        label.frame = CGRectMake((self.width-rect.size.width)/2, 17.5, rect.size.width, 16);
        label.textColor = COLORWITHHEXSTRING(@"#333333", 1.0);
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont boldSystemFontOfSize:16];
        label.text = [[ZDPayInternationalizationModel sharedSingleten] getModelData].SELECTE_PAYMENT_METHOD;
        [view addSubview:label];
        
        UIView *lineView = [UIView new];
        lineView.backgroundColor = COLORWITHHEXSTRING(@"#E9EBEE", 1.0);
        [view addSubview:lineView];
        lineView.frame = CGRectMake(0, 50.5, self.width, .5);
        return view;
    }
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [UIView new];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.type == SelectPayMethod) {
        return 51;
    }
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (self.type == SelectPayMethod) {
        
        if (indexPath.row >=0 && indexPath.row < self.dataList.count) {

            //获取上一个cell，改变选择支付方式图标
            if (self.oldIndexPath) {
                self.oldCell = [tableView cellForRowAtIndexPath:self.oldIndexPath];
                UIImageView *selImageView = [self.oldCell.contentView viewWithTag:300];
                selImageView.image = [UIImage imageNamed:@"btn_unch"];
            }

            UIImageView *selImageView = [cell.contentView viewWithTag:300];
            selImageView.image = [UIImage imageNamed:@"btn_choose"];
            self.oldIndexPath = indexPath;
            
            ZDPay_OrderSurePayListRespModel *model = self.dataList[indexPath.row];
            self.selectPayMethod(tableView, indexPath, model);
        }
        
        if (indexPath.row == self.dataList.count) {
            [self closeThePopupView];
            self.selectPayMethod(tableView, indexPath, @"addBankCard");
        }
        
        if (self.dataList.count <= 5 && self.dataPointList.count > 5) {
            if (indexPath.row == self.dataList.count + 1) {
                [self.dataList removeAllObjects];
                [self.dataList addObjectsFromArray:self.dataPointList];
                [self.popTableView reloadData];
            }
        }
    } else {
        self.cellPhoneAreaCode(tableView, indexPath, cell.textLabel.text);
    }
}

#pragma mark - keyboard Monitor
- (void)keyboardWillShow:(NSNotification *)aNotification {
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    self.frame = CGRectMake(37,(ScreenHeight-286-height - 30), ScreenWidth-74, 286);
}

- (void)keyboardWillHide:(NSNotification *)aNotification {
    self.frame = CGRectMake(37,(ScreenHeight-286)/2, ScreenWidth-74, 286);
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - public
+ (ZDPayPopView *)readingEarnPopupViewWithType:(ZDPayPopViewEnum)type {
    return [[ZDPayPopView alloc] initWithFrame:CGRectZero withType:type];
}

- (void)showPopupMakeViewWithData:(__nullable id)model {
    [self.myWindow addSubview:self];
    NSArray *array = (NSArray *)model;
    if (self.type == CreditCardInputdemonstration) {
        self.layer.cornerRadius = 10;
        self.backgroundColor = [UIColor whiteColor];
        
        float x;
        UIImage *image = [UIImage imageNamed:array[0]];
        x = image.size.height*(ScreenWidth-37)/image.size.width;
        self.frame = CGRectMake(37,(ScreenHeight-x)/2, ScreenWidth-74, x);
        [self layoutAndLoadDataCreditCardInputdemonstration:array[0] labStr:array[1]];
    }
}

- (void)showPopupViewWithData:(__nullable id)model
              SelectPayMethod:(void (^)(UITableView *__nullable tableView,NSIndexPath *__nullable indexPath,id __nullable model))selectPayMethod
         withPayListRespModel:(id __nullable)withPayListRespModel {
    self.pay_OrderSurePayListRespModel = (ZDPay_OrderSurePayListRespModel *)withPayListRespModel;
    self.selectPayMethod = selectPayMethod;
    [self.dataPointList removeAllObjects];
    [self.dataList removeAllObjects];
    [self.dataPointList addObjectsFromArray:(NSArray *)model];
    NSArray *dataList = (NSArray *)model;
    if (dataList.count > 5) {
        [dataList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (idx < 5) {
                [self.dataList addObject:obj];
            }
        }];
    } else {
        [self.dataList addObjectsFromArray:dataList];
    }
    [self.myWindow addSubview:self];
    
    if (self.type == SelectPayMethod) {
        self.backgroundColor = COLORWITHHEXSTRING(@"#FFFFFF", 1.0);
        self.layer.cornerRadius = 6;
        self.layer.masksToBounds = YES;
        if (self.dataPointList.count > 5) {
            self.frame = CGRectMake(30, (ScreenHeight - (162+61*5))/2, ScreenWidth-60, 162+61*5);
        } else {
            
            if (self.dataPointList.count >= 0 && self.dataPointList.count <= 5)  {
                self.frame = CGRectMake(30, (ScreenHeight - (162+61*self.dataList.count))/2, ScreenWidth-60, 112+61*self.dataList.count);
            }
        }

        [self layoutAndLoadDataSelectPayMethod];
    }
}

- (void)showPopupViewWithData:(__nullable id)model
                      payPass:(void (^)(NSString *text, BOOL isFinished))payPass
                   forgetPass:(void (^)(void))forgetPass {
    self.setPaymentPassword = payPass;
    self.forgetPassword = forgetPass;
    
    self.pay_OrderSurePayListRespModel = (ZDPay_OrderSurePayListRespModel *)model;
    [self.myWindow addSubview:self];
    if (self.type == SetPaymentPassword) {
        self.layer.cornerRadius = 10;
        self.backgroundColor = [UIColor whiteColor];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
        selector:@selector(keyboardWillShow:)
        name:UIKeyboardWillShowNotification
        object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
        selector:@selector(keyboardWillHide:)
        name:UIKeyboardWillHideNotification
        object:nil];

        self.frame = CGRectMake(37,(ScreenHeight-286)/2, ScreenWidth-74, 286);
         [self layoutAndLoadDataPaymentPassword];
    }
}

- (void)showPopupViewWithData:(__nullable id)model
                       myCell:(UITableViewCell *)myCell
                 documentType:(void (^)(UIButton *sender))documentType{
    self.documentType = documentType;
    
    [self.myWindow addSubview:self];
    if (self.type == DocumentType) {
        self.backgroundColor = [UIColor whiteColor];
        self.frame = CGRectMake(ScreenWidth-150, myCell.origin.y + mcNavBarAndStatusBarHeight+myCell.size.height, 150, (myCell.size.height-10)*5);
         [self layoutAndLoadDataDocumentType:(NSArray *)model myCell:myCell];
    }
}

- (void)showPopupViewWithData:(__nullable id)model
                 phoneAreaCode:(void (^)(UITableView *__nullable tableView,NSIndexPath *__nullable indexPath,NSString *__nullable text))phoneAreaCode {
    self.cellPhoneAreaCode = phoneAreaCode;
    [self.dataList removeAllObjects];
    [self.dataList addObjectsFromArray:(NSArray *)model];
    [self.myWindow addSubview:self];
    
    if (self.type == CellPhoneAreaCode) {
        self.backgroundColor = [UIColor clearColor];
        self.frame = CGRectMake(0, ScreenHeight - 50*self.dataList.count, ScreenWidth, 50*self.dataList.count);
         [self layoutAndLoadDataCellPhoneAreaCode];
    }
}

- (void)closeThePopupView {
    self.coverView.hidden = YES;
    self.hidden = YES;
    [self removeFromSuperview];
    [self.coverView removeFromSuperview];
}



@end
