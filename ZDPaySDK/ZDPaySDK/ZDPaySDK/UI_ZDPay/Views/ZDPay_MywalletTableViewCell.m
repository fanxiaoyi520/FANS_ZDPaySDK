//
//  ZDPay_MywalletTableViewCell.m
//  ReadingEarn
//
//  Created by FANS on 2020/4/16.
//  Copyright © 2020 FANS. All rights reserved.
//

#import "ZDPay_MywalletTableViewCell.h"
#import "ZDPayFuncTool.h"

@interface ZDPay_MywalletTableViewCell ()

@property (nonatomic,strong)UIImageView *backImageView;
@property (nonatomic,strong)UILabel *typeLab;
@property (nonatomic,strong)UILabel *cardNumberLab;
@property (nonatomic,strong)UIButton *isHiddenBtn;
@property (nonatomic,strong)ZDPay_OrderBankListTokenModel *bankModel;
@end
@implementation ZDPay_MywalletTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initialize];
    }
    return self;
}

#pragma mark - private
- (void)setFrame:(CGRect)frame {
    frame.origin.y += 16;
    frame.size.width = ScreenWidth-32;
    [super setFrame:frame];
}

- (void)initialize {
    
    UIImageView *backImageView = [UIImageView new];
    backImageView.userInteractionEnabled = YES;
    [self.contentView addSubview:backImageView];
    self.backImageView = backImageView;
    
    UILabel *typeLab = [UILabel new];
    self.typeLab = typeLab;
    [backImageView addSubview:typeLab];
    typeLab.textColor = COLORWITHHEXSTRING(@"#FFFFFF", .8);
    typeLab.font = ZD_Fout_Medium(12);

    UILabel *cardNumberLab = [UILabel new];
    self.cardNumberLab = cardNumberLab;
    [backImageView addSubview:cardNumberLab];
    cardNumberLab.textColor = COLORWITHHEXSTRING(@"#FFFFFF", 1.0);
    cardNumberLab.font = ZD_Fout_Medium(18);
    
    UIButton *isHiddenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.isHiddenBtn = isHiddenBtn;
    isHiddenBtn.selected = YES;
    [backImageView addSubview:isHiddenBtn];
    
    [isHiddenBtn setImage:REImageName(@"icon_yingcang") forState:UIControlStateNormal];
    [isHiddenBtn addTarget:self action:@selector(isHiddenBtnAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)isHiddenBtnAction:(UIButton *)sender {
    if (sender.selected == YES) {
        sender.selected = NO;
        [self.isHiddenBtn setImage:REImageName(@"icon_zhankai") forState:UIControlStateNormal];
        NSMutableString* str1=[[NSMutableString alloc] initWithString:self.bankModel.cardId];
        for(NSInteger i = str1.length -4; i >0; i -=4) {
            [str1 insertString:@" " atIndex:i];
        }
        self.cardNumberLab.text = [NSString stringWithFormat:@"%@",str1];
    } else {
        sender.selected = YES;
        [self.isHiddenBtn setImage:REImageName(@"icon_yingcang") forState:UIControlStateNormal];
        self.cardNumberLab.text = [NSString stringWithFormat:@"**** **** **** %@",self.bankModel.cardNum];
    }
}

#pragma mark - public
- (void)layoutAndLoadData:(ZDPay_OrderBankListTokenModel * __nullable)model {
    if (!model) {
        return;
    }
    
    float x=0;
    NSString *imageStr = @"";
    UIImage *image;
    if (model.cardBgImage.length < 5) {
        imageStr = @"card_yajincz";
        image = [UIImage imageNamed:@"card_yajincz"];
        x=image.size.height*(ScreenWidth-32)/image.size.width;
    } else {
        imageStr = model.cardBgImage;
        NSData * data = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:imageStr]];
        image = [[UIImage alloc]initWithData:data];
        x=image.size.height*(ScreenWidth-32)/image.size.width;
    }

    self.bankModel = model;
    self.backImageView.frame = CGRectMake(0, 5, self.width, x);
    self.backImageView.image = image;

    CGRect typeRect = [ZDPayFuncTool getStringWidthAndHeightWithStr:model.cardType withFont:ZD_Fout_Medium(12)];
    self.typeLab.frame = CGRectMake(48, 34, typeRect.size.width, 12);
    self.typeLab.text = [NSString stringWithFormat:@"%@",model.cardType];
    
    
    NSMutableString* str1=[[NSMutableString alloc] initWithString:model.cardId];
    for(NSInteger i = str1.length -4; i >0; i -=4) {
        [str1 insertString:@" " atIndex:i];
    }
    CGRect cardNumberRect = [ZDPayFuncTool getStringWidthAndHeightWithStr:str1 withFont:ZD_Fout_Medium(18)];
    self.cardNumberLab.frame = CGRectMake(48, 68, cardNumberRect.size.width, 18);
    self.cardNumberLab.text = [NSString stringWithFormat:@"**** **** **** %@",self.bankModel.cardNum];

    self.isHiddenBtn.frame = CGRectMake(self.width-57, 33, 57, 79);
}
@end
