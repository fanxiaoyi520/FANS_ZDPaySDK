//
//  ZDPay_OrderSureFooterView.m
//  ReadingEarn
//
//  Created by FANS on 2020/4/14.
//  Copyright © 2020 FANS. All rights reserved.
//

#import "ZDPay_OrderSureFooterView.h"
#import "ZDPayFuncTool.h"

@interface ZDPay_OrderSureFooterView ()

@property (nonatomic ,strong)UIButton *proxyBtn;
@property (nonatomic ,strong)UILabel *proxyLabel;
@property (nonatomic ,strong)UIButton *surePayBtn;

@end

@implementation ZDPay_OrderSureFooterView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

#pragma mark - private
- (void)initialize {
    
    [self creatSureProxyBtnWithSel:@selector(proxyBtn:)];
    [self creatSurePayBtnWithSel:@selector(surePayBtn:)];
    
    UILabel *proxyLabel = [UILabel new];
    //[self.contentView addSubview:proxyLabel];
    proxyLabel.textAlignment = NSTextAlignmentLeft;
    proxyLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    proxyLabel.numberOfLines = 0;
    proxyLabel.preferredMaxLayoutWidth = ScreenWidth;
    proxyLabel.font = ZD_Fout_Medium(13);
    proxyLabel.textColor = COLORWITHHEXSTRING(@"#999999", 1.0);
    self.proxyLabel = proxyLabel;
    
}

- (void)creatSureProxyBtnWithSel:(SEL)sel {
    UIButton *proxyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [proxyBtn addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
    self.proxyBtn = proxyBtn;
    self.proxyBtn.selected = YES;
    //[self.contentView addSubview:proxyBtn];
}

- (void)creatSurePayBtnWithSel:(SEL)sel {
    UIButton *surePayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.surePayBtn = surePayBtn;
    [surePayBtn addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
    surePayBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    [self.contentView addSubview:surePayBtn];
    surePayBtn.backgroundColor = COLORWITHHEXSTRING(@"#333333", 1.0);
    surePayBtn.layer.cornerRadius = 22;
    surePayBtn.layer.masksToBounds = YES;
    [surePayBtn setTitleColor:COLORWITHHEXSTRING(@"#FFFFFF", 1.0) forState:UIControlStateNormal];
    surePayBtn.titleLabel.font = ZD_Fout_Medium(18);
    surePayBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
}

- (void)proxyBtn:(UIButton *)sender {
    if (self.selProxy) {
        self.selProxy(sender);
    }
    if (sender.selected == NO) {
        sender.selected = YES;
        [self.proxyBtn setImage:[UIImage imageNamed:@"btn_xieyi_selete"] forState:UIControlStateNormal];
    } else {
        sender.selected = NO;
        [self.proxyBtn setImage:[UIImage imageNamed:@"btn_xieyi_unsel"] forState:UIControlStateNormal];
    }
}

- (void)surePayBtn:(UIButton *)sender {
    if (self.surePay) {
        self.surePay(sender);
    }
}

#pragma mark - public
- (void)layoutAndLoadData:(ZDPay_OrderSureModel *)model
                  surePay:(void(^)(UIButton *sender))surePay
                 selProxy:(void(^)(UIButton *sender))selProxy {
    self.surePay = surePay;
    self.selProxy = selProxy;
    if (!model) {
        return;
    }


    self.proxyLabel.text = [[ZDPayInternationalizationModel sharedSingleten] getModelData].CLICK_HERE_TO_INDICATE_THAT_YOU_HAVE_READ_AND_AGREE_TO_THE_PAYMENT_AGREEMENT;
    CGSize maximumLabelSize = CGSizeMake(ScreenWidth-102, 9999);
    CGSize expectSize = [self.proxyLabel sizeThatFits:maximumLabelSize];
    if (expectSize.width<ScreenWidth-102) {
        expectSize.width = ScreenWidth - 102;
    }
    
    CGFloat x = 0;
    if (self.height-expectSize.height-92 < 0) {
        x = 0;
    } else {
        x = self.height-expectSize.height-92;
    }
    self.proxyBtn.frame = CGRectMake(33, x+2, 13, 13);
    [self.proxyBtn setImage:[UIImage imageNamed:@"btn_xieyi_selete"] forState:UIControlStateNormal];
    
    self.proxyLabel.frame = CGRectMake(self.proxyBtn.right+5, x, expectSize.width, expectSize.height);
    [ZDPayFuncTool LabelAttributedString:self.proxyLabel FontNumber:ZD_Fout_Medium(13) AndRange:NSMakeRange(15, 6) AndColor:COLORWITHHEXSTRING(@"#FFB300", 1.0)];
    
    NSString *amountMoneyStr = [ZDPayFuncTool formatToTwoDecimal:model.txnAmt];
    self.surePayBtn.frame = CGRectMake(20, self.proxyLabel.bottom + 11, self.width-40, 44);
    [self.surePayBtn setTitle:[NSString stringWithFormat:@"%@ %@ %@",[[ZDPayInternationalizationModel sharedSingleten] getModelData].CONFIRM_AND_PAY,[[ZDPay_OrderSureModel sharedSingleten] getModelData].currencyCode,amountMoneyStr] forState:UIControlStateNormal];
}

@end
