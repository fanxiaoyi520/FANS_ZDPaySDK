//
//  ZDPay_OrderSureTableViewCell.m
//  ReadingEarn
//
//  Created by FANS on 2020/4/14.
//  Copyright © 2020 FANS. All rights reserved.
//

#import "ZDPay_OrderSureTableViewCell.h"
#import "ZDPayFuncTool.h"

@interface ZDPay_OrderSureTableViewCell()

@property (nonatomic ,strong)UIImageView *headImageView;
@property (nonatomic ,strong)UILabel *nameLab;
@end

@implementation ZDPay_OrderSureTableViewCell
- (void)setFrame:(CGRect)frame {
    frame.size.width = ScreenWidth-ratioW(20);
    [super setFrame:frame];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initialize];
    }
    return self;
}

#pragma mark - private
- (void)initialize {
    
    UIImageView *headImageView = [UIImageView new];
    [self.contentView addSubview:headImageView];
    self.headImageView = headImageView;
    
    UILabel *nameLab = [UILabel new];
    self.nameLab = nameLab;
    [self.contentView addSubview:nameLab];
    nameLab.textAlignment = NSTextAlignmentLeft;
    //nameLab.font = ZD_Fout_Medium(ratioH(16));
    nameLab.font = [UIFont systemFontOfSize:16];
    nameLab.textColor = COLORWITHHEXSTRING(@"#333333", 1.0);
    UIImageView *selectImageView = [UIImageView new];
    self.selectImageView = selectImageView;
    [self.contentView addSubview:selectImageView];
}

#pragma mark - public
- (void)layoutAndLoadData:(ZDPay_OrderSurePayListRespModel *)model isImageSel:(BOOL)isImageSel {
    if (!model) {
        return;
    }
    
    CGRect contentRect;
    if (![model.channelCode isEqualToString:@""]) {
        if (model.imgUrl) {
            self.headImageView.image = [UIImage imageWithData:[[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:model.imgUrl]]];
        } else {
            self.headImageView.image = DEFAULT_IMAGE;
        }

        contentRect = [ZDPayFuncTool getStringWidthAndHeightWithStr:model.name withFont:[UIFont systemFontOfSize:16]];
        self.nameLab.text = [NSString stringWithFormat:@"%@",model.name];
    } else {
        if (model.cardBgImage) {
            self.headImageView.image = [UIImage imageWithData:[[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:model.cardMsg]]];
        } else {
            self.headImageView.image = DEFAULT_IMAGE;
        }

            contentRect = [ZDPayFuncTool getStringWidthAndHeightWithStr:[NSString stringWithFormat:@"%@(%@)",model.bankName,model.cardNum] withFont:[UIFont systemFontOfSize:16]];
        self.nameLab.text = [NSString stringWithFormat:@"%@(%@)",model.bankName,model.cardNum];
    }

    self.headImageView.frame = CGRectMake(21, 17, 17, 17);
    self.nameLab.frame = CGRectMake(self.headImageView.right + 10, 18, contentRect.size.width, 16);
    if (isImageSel) {
        
    }
    /**选择银联卡支付后 ，判断银联卡支付是选中还是不选中*/
    self.selectImageView.image = !isImageSel ? [UIImage imageNamed:@"btn_unch"]:[UIImage imageNamed:@"btn_choose"];
    self.selectImageView.frame = CGRectMake(self.right-28, 17, 17, 17);
}
@end
