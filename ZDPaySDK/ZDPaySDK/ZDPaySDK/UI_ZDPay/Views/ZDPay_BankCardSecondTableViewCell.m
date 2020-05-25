//
//  ZDPay_BankCardSecondTableViewCell.m
//  ReadingEarn
//
//  Created by FANS on 2020/4/15.
//  Copyright © 2020 FANS. All rights reserved.
//

#import "ZDPay_BankCardSecondTableViewCell.h"
#import "ZDPayFuncTool.h"

@interface ZDPay_BankCardSecondTableViewCell()

@property (nonatomic ,strong)UILabel *titleLab;
@property (nonatomic ,strong)UILabel *contentLab;

@property (nonatomic ,strong)UIButton *selDocumentTypeBtn;

@end

@implementation ZDPay_BankCardSecondTableViewCell
- (void)setFrame:(CGRect)frame {
    frame.size.width = ScreenWidth;
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
    
    UILabel *titleLab = [UILabel new];
    [self.contentView addSubview:titleLab];
    self.titleLab = titleLab;
    titleLab.textColor = COLORWITHHEXSTRING(@"#333333", 1.0);
    titleLab.font = ZD_Fout_Regular(16);
    titleLab.textAlignment = NSTextAlignmentLeft;
    
    UILabel *contentLab = [UILabel new];
    [self.contentView addSubview:contentLab];
    self.contentLab = contentLab;
    contentLab.textColor = COLORWITHHEXSTRING(@"#333333", 1.0);
    contentLab.font = ZD_Fout_Regular(16);
    contentLab.textAlignment = NSTextAlignmentRight;
    
    UIButton *selDocumentTypeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.selDocumentTypeBtn = selDocumentTypeBtn;
    [self.contentView addSubview:selDocumentTypeBtn];
    [selDocumentTypeBtn addTarget:self action:@selector(selDocumentTypeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [selDocumentTypeBtn setTitleColor:COLORWITHHEXSTRING(@"#333333", 1.0) forState:UIControlStateNormal];
    selDocumentTypeBtn.titleLabel.font = ZD_Fout_Regular(16);
    selDocumentTypeBtn.selected = YES;
    
    UITextField *inputTextField = [[UITextField alloc] init];
    self.inputTextField = inputTextField;
    [self.contentView addSubview:inputTextField];
    [inputTextField addTarget:self action:@selector(inputTextFieldAction:) forControlEvents:UIControlEventEditingChanged];
    inputTextField.font = ZD_Fout_Regular(16);
    inputTextField.textAlignment = NSTextAlignmentRight;
    inputTextField.textColor = COLORWITHHEXSTRING(@"#333333", 1.0);
}

- (void)inputTextFieldAction:(UITextField *)textField {
    if (self.addBankCardTextField) {
        self.addBankCardTextField(textField);
    }
}

- (void)selDocumentTypeBtnAction:(UIButton *)sender {
    if (self.selDocumentTypeClick) {
        self.selDocumentTypeClick(sender);
    }
}

#pragma mark - public
- (void)layoutAndLoadData:(ZDPay_AddBankModel *)model myIndexPath:(NSIndexPath *)myIndexPath array:(NSArray *)array {
    if (!model) {
        return;
    }
    if (myIndexPath.section == 0) {
        self.inputTextField.tag = 100 + myIndexPath.row;
    } else {
        self.inputTextField.tag = 200 + myIndexPath.row;
    }
    
    CGRect titleRect;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *cardTypeStr = [userDefaults objectForKey:@"cardType"];
    if ([cardTypeStr isEqualToString:@"C"]) {
        titleRect = [ZDPayFuncTool getStringWidthAndHeightWithStr:array[myIndexPath.section][myIndexPath.row] withFont:ZD_Fout_Regular(16)];
        self.titleLab.frame = CGRectMake(20, ratioH(20), titleRect.size.width, 16);
        self.titleLab.text = array[myIndexPath.section][myIndexPath.row];
        
        if (myIndexPath.section == 1 && myIndexPath.row == 0) {
            self.inputTextField.frame = CGRectMake(20+titleRect.size.width+20, 0, self.width-40-48-titleRect.size.width, ratioH(56));
            NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:[[ZDPayInternationalizationModel sharedSingleten] getModelData].DATA_FORMAT_enter_0915 attributes:@{
                NSForegroundColorAttributeName:COLORWITHHEXSTRING(@"#999999", 1.0),
                NSFontAttributeName:self.inputTextField.font,
            }];
            self.inputTextField.attributedPlaceholder = attrString;
            self.inputTextField.keyboardType = UIKeyboardTypeNumberPad;
            
            [self.selDocumentTypeBtn setImage:[UIImage imageNamed:@"icon_cvn"] forState:UIControlStateNormal];
            self.selDocumentTypeBtn.frame = CGRectMake(self.width- 22 - 20, ratioH(18), ratioH(20), ratioH(20));
            self.selDocumentTypeBtn.tag = myIndexPath.row;

        } else if (myIndexPath.section == 1 && myIndexPath.row == 1) {
            self.inputTextField.frame = CGRectMake(20+titleRect.size.width+20, 0, self.width-40-48-titleRect.size.width, ratioH(56));
            NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:[[ZDPayInternationalizationModel sharedSingleten] getModelData].SECURITY_CODE attributes:@{
                NSForegroundColorAttributeName:COLORWITHHEXSTRING(@"#999999", 1.0),
                NSFontAttributeName:self.inputTextField.font,
            }];
            self.inputTextField.attributedPlaceholder = attrString;
            self.inputTextField.keyboardType = UIKeyboardTypeNumberPad;
            
            [self.selDocumentTypeBtn setImage:[UIImage imageNamed:@"icon_cvn"] forState:UIControlStateNormal];
            self.selDocumentTypeBtn.frame = CGRectMake(self.width- 22 - 20, ratioH(18), ratioH(20), ratioH(20));
            self.selDocumentTypeBtn.tag = myIndexPath.row;
        }
    } else {
        titleRect = [ZDPayFuncTool getStringWidthAndHeightWithStr:array[myIndexPath.row] withFont:ZD_Fout_Regular(16)];
        self.titleLab.frame = CGRectMake(20, ratioH(20), titleRect.size.width, 16);
        self.titleLab.text = array[myIndexPath.row];
    }
    
    if (myIndexPath.section == 0 && myIndexPath.row == 0) {
        NSMutableString* str1=[[NSMutableString alloc] initWithString:model.cardNum];
        for(NSInteger i = str1.length -4; i >0; i -=4) {
            [str1 insertString:@" " atIndex:i];
        }
        CGRect contentRect = [ZDPayFuncTool getStringWidthAndHeightWithStr:str1 withFont:ZD_Fout_Regular(16)];
        self.contentLab.frame = CGRectMake(self.width-20-contentRect.size.width, ratioH(20), contentRect.size.width, 16);
        self.contentLab.text = str1;
    } else if (myIndexPath.section == 0 && myIndexPath.row == 1) {
        if (![model.cardName isEqualToString:@""]) {
            CGRect contentRect = [ZDPayFuncTool getStringWidthAndHeightWithStr:model.cardName withFont:ZD_Fout_Regular(16)];
            self.contentLab.frame = CGRectMake(self.width-20-contentRect.size.width, ratioH(20), contentRect.size.width, 16);
            self.contentLab.text = model.cardName;
            self.inputTextField.userInteractionEnabled = NO;
        } else {
            self.inputTextField.userInteractionEnabled = YES;
            self.inputTextField.frame = CGRectMake(20+titleRect.size.width+20, 0, self.width-60-titleRect.size.width, ratioH(56));
            NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:[[ZDPayInternationalizationModel sharedSingleten] getModelData].PLEASE_ENTER_YOUR_NAME attributes:@{
                NSForegroundColorAttributeName:COLORWITHHEXSTRING(@"#999999", 1.0),
                NSFontAttributeName:self.inputTextField.font,
            }];
            self.inputTextField.attributedPlaceholder = attrString;
        }
    }
    
    if (myIndexPath.section == 0 && myIndexPath.row == 2) {
        if (![model.cardflag isEqualToString:@""]) {
            self.selDocumentTypeBtn.userInteractionEnabled = NO;
            NSArray *array = @[[[ZDPayInternationalizationModel sharedSingleten] getModelData].ID_CARD,[[ZDPayInternationalizationModel sharedSingleten] getModelData].PASSPORT,[[ZDPayInternationalizationModel sharedSingleten] getModelData].HOME_REENTRY_PERMIT,[[ZDPayInternationalizationModel sharedSingleten] getModelData].ARMY_ID_CARD,[[ZDPayInternationalizationModel sharedSingleten] getModelData].POLICE_OFFICER_ID_CARD];
            
            CGRect contentRect = [ZDPayFuncTool getStringWidthAndHeightWithStr:array[[model.cardflag intValue]] withFont:ZD_Fout_Regular(16)];
            [self.selDocumentTypeBtn setTitle:array[[model.cardflag intValue]] forState:UIControlStateNormal];
            [self.selDocumentTypeBtn setImage:[UIImage imageNamed:@"icon_zjlx"] forState:UIControlStateNormal];
            self.selDocumentTypeBtn.frame = CGRectMake(self.width-contentRect.size.width-self.selDocumentTypeBtn.imageView.image.size.width-ratioW(38), ratioH(20), contentRect.size.width+self.selDocumentTypeBtn.imageView.image.size.width, 16);
            [self.selDocumentTypeBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, - self.selDocumentTypeBtn.imageView.image.size.width, 0, self.selDocumentTypeBtn.imageView.image.size.width)];
            [self.selDocumentTypeBtn setImageEdgeInsets:UIEdgeInsetsMake(0, self.selDocumentTypeBtn.titleLabel.bounds.size.width, 0, -self.selDocumentTypeBtn.titleLabel.bounds.size.width)];

            self.selDocumentTypeBtn.tag = myIndexPath.row;
        } else {
            self.selDocumentTypeBtn.userInteractionEnabled = YES;
            CGRect contentRect = [ZDPayFuncTool getStringWidthAndHeightWithStr:[[ZDPayInternationalizationModel sharedSingleten] getModelData].ID_CARD withFont:ZD_Fout_Regular(16)];
            [self.selDocumentTypeBtn setTitle:[[ZDPayInternationalizationModel sharedSingleten] getModelData].ID_CARD forState:UIControlStateNormal];
            [self.selDocumentTypeBtn setImage:[UIImage imageNamed:@"icon_zjlx"] forState:UIControlStateNormal];
            self.selDocumentTypeBtn.frame = CGRectMake(self.width-contentRect.size.width-self.selDocumentTypeBtn.imageView.image.size.width-ratioW(38), ratioH(20), contentRect.size.width+self.selDocumentTypeBtn.imageView.image.size.width, 16);
            [self.selDocumentTypeBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, - self.selDocumentTypeBtn.imageView.image.size.width, 0, self.selDocumentTypeBtn.imageView.image.size.width)];
            [self.selDocumentTypeBtn setImageEdgeInsets:UIEdgeInsetsMake(0, self.selDocumentTypeBtn.titleLabel.bounds.size.width, 0, -self.selDocumentTypeBtn.titleLabel.bounds.size.width)];

            self.selDocumentTypeBtn.tag = myIndexPath.row;
        }
    }
    
    if (myIndexPath.section == 0 && myIndexPath.row == 3) {
        if (![model.cardNo isEqualToString:@""]) {
            CGRect contentRect = [ZDPayFuncTool getStringWidthAndHeightWithStr:model.cardNo withFont:ZD_Fout_Regular(16)];
            self.contentLab.frame = CGRectMake(self.width-20-contentRect.size.width, ratioH(20), contentRect.size.width, 16);
            self.contentLab.text = model.cardNo;
            self.inputTextField.userInteractionEnabled = NO;
        } else {
            self.inputTextField.userInteractionEnabled = YES;
            self.inputTextField.frame = CGRectMake(20+titleRect.size.width+20, 0, self.width-60-titleRect.size.width, ratioH(56));
            
            NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:[[ZDPayInternationalizationModel sharedSingleten] getModelData].PLEASE_ENTER_YOUR_ID_NUMBER attributes:@{
                NSForegroundColorAttributeName:COLORWITHHEXSTRING(@"#999999", 1.0),
                NSFontAttributeName:self.inputTextField.font,
            }];
            self.inputTextField.attributedPlaceholder = attrString;
        }
    }
    
    if (myIndexPath.section == 0 && myIndexPath.row == 4) {
        CGRect contentRect = [ZDPayFuncTool getStringWidthAndHeightWithStr:@"+852" withFont:ZD_Fout_Regular(16)];
        self.selDocumentTypeBtn.frame = CGRectMake(self.width-contentRect.size.width-ratioW(38), ratioH(20), contentRect.size.width, 16);
        self.selDocumentTypeBtn.tag = myIndexPath.row;
        [self.selDocumentTypeBtn setTitle:@"+852" forState:UIControlStateNormal];
        
        self.inputTextField.frame = CGRectMake(20+titleRect.size.width+20, 0, self.width-40-48-titleRect.size.width-contentRect.size.width, ratioH(56));
        NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:[[ZDPayInternationalizationModel sharedSingleten] getModelData].PLEASE_ENTER_BANK_ACCOUNT_RESERVATION_PHONE_NO attributes:@{
            NSForegroundColorAttributeName:COLORWITHHEXSTRING(@"#999999", 1.0),
            NSFontAttributeName:self.inputTextField.font,
        }];
        self.inputTextField.attributedPlaceholder = attrString;
        self.inputTextField.keyboardType = UIKeyboardTypeNumberPad;
    }
}

@end
