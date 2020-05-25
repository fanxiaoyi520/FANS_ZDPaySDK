//
//  ZDPayFuncTool.m
//  ReadingEarn
//
//  Created by FANS on 2020/4/14.
//  Copyright © 2020 FANS. All rights reserved.
//

#import "ZDPayFuncTool.h"
@implementation ZDPayFuncTool
#pragma mark - 倒计时

#pragma mark - 宏的作用

//NSString *const DOMAINNAME = @"http://192.168.37.227:8762";//域名
//NSString *const DOMAINNAME = @"http://192.168.37.226:8762";//域名
//NSString *const DOMAINNAME_ONE = @"http://192.168.17.239:9001";//域名
//NSString *const DOMAINNAME = @"http://testhk.qtopay.cn";//测试环境
NSString *const DOMAINNAME = @"https://common.sinopayonline.com";//正式环境

NSString *const GETALLLANGUAGES = @"/pay-gateway/getAllLanguage";//获取所有语言
NSString *const QUERYPAYMETHOD = @"/pay-gateway/pay/queryBindCard";//查询银行卡信息列表
NSString *const CHECKCARDTYPE = @"/pay-gateway/bangding/card/checkCardType";//快捷支付查询银行卡号信息
NSString *const SENDBINDCARDSMS = @"/pay-gateway/bangding/card/sendBindCardSms";//快捷支付绑卡获取短信
NSString *const CHECKBINDCARDSMS = @"/pay-gateway/bangding/card/checkBindCardSms";//快捷支付绑卡短信验证
NSString *const SETPAYPWD = @"/pay-gateway/bangding/card/setPayPwd";//快捷支付设置支付密码
NSString *const CHECKPAYPWD = @"/pay-gateway/bangding/card/checkPayPwd";//快捷支付验证支付密码
NSString *const UNBINDBANKCARD = @"/pay-gateway/bangding/card/unbindBankCard";//快捷支付解绑银行卡
NSString *const SENDFORGETPWDSMS = @"/pay-gateway/bangding/card/sendForgetPwdSms";//快捷支付忘记密码获取短信
NSString *const CHECKFORGETPWDSMS = @"/pay-gateway/bangding/card/checkForgetPwdSms";//验证忘记密码短信
NSString *const CHANGEACCOUNTPWD = @"/pay-gateway/bangding/card/changeAccountPwd";//快捷支付修改密码
NSString *const PAY = @"pay";//消费类交易(支付)
NSString *const REFUND = @"refund";//快捷支付消费撤销、退货、预授权完成或预授权撤销
NSString *const QUERYPAYRESULT = @"queryPayResult";//交易查询状态

NSString *const PAYMENT = @"/pay-gateway/pay/payment";//支付的接口

UIColor *COLORWITHHEXSTRING(NSString * hexString,CGFloat alpha) {
    hexString = [hexString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    hexString = [hexString stringByReplacingOccurrencesOfString:@"#" withString:@""];
    hexString = [hexString stringByReplacingOccurrencesOfString:@"0x" withString:@""];
    NSRegularExpression *RegEx = [NSRegularExpression regularExpressionWithPattern:@"^[a-fA-F|0-9]{6}$" options:0 error:nil];
    NSUInteger match = [RegEx numberOfMatchesInString:hexString options:NSMatchingReportCompletion range:NSMakeRange(0, hexString.length)];

    if (match == 0) {return [UIColor clearColor];}

    NSString *rString = [hexString substringWithRange:NSMakeRange(0, 2)];
    NSString *gString = [hexString substringWithRange:NSMakeRange(2, 2)];
    NSString *bString = [hexString substringWithRange:NSMakeRange(4, 2)];
    unsigned int r, g, b;
    BOOL rValue = [[NSScanner scannerWithString:rString] scanHexInt:&r];
    BOOL gValue = [[NSScanner scannerWithString:gString] scanHexInt:&g];
    BOOL bValue = [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    if (rValue && gValue && bValue) {
        return [UIColor colorWithRed:((float)r/255.0f) green:((float)g/255.0f) blue:((float)b/255.0f) alpha:alpha];
    } else {
        return [UIColor clearColor];
    }
}

#pragma 获取字符串的宽高
+ (CGRect)getStringWidthAndHeightWithStr:(NSString *)str withFont:(UIFont *)font {
    if (![str isKindOfClass:[NSString class]]) {
        return CGRectZero;
    }
    CGRect contentRect = [str boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 40, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil];
    return contentRect;
}

+(float) widthForString:(NSString *)value fontSize:(float)fontSize andHeight:(float)height {
    CGSize sizeToFit = [value sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(CGFLOAT_MAX, height) lineBreakMode:NSLineBreakByWordWrapping];//此处的换行类型（lineBreakMode）可根据自己的实际情况进行设置
    return sizeToFit.width;
}

//获得字符串的高度
+(float) heightForString:(NSString *)value fontSize:(float)fontSize andWidth:(float)width {
    CGSize sizeToFit = [value sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(width, CGFLOAT_MAX) lineBreakMode:NSLineBreakByCharWrapping];//此处的换行类型（lineBreakMode）可根据自己的实际情况进行设置

    return sizeToFit.height;
}

#pragma mark - 保留小数点位数
+ (NSString *)getRoundFloat:(double)number withPrecisionNum:(NSInteger)position {
    NSNumber *priceNum = [NSNumber numberWithDouble:number];
    NSString *string = [NSString stringWithFormat:@"%.10f",number];
    NSRange range = [string rangeOfString:@"."];
    if (range.location!=NSNotFound) {
        
        NSInteger loc = range.location+position+1;
        NSRange rangeS;
        if (string.length>loc) {
            rangeS = NSMakeRange(loc, 1);
            NSString *str = [string substringWithRange:rangeS];
            if (str!=nil&&[str floatValue]>=5.0f) {
                priceNum = [NSNumber numberWithDouble:[[string stringByReplacingCharactersInRange:rangeS withString:@"9"] floatValue]];
            }
        }
        
    }
    if (position>4) {
        return @"";
    }
    
    if (position==1) {//保留1位
        return [NSString stringWithFormat:@"%.1f",round([priceNum floatValue]*1000000000000)/1000000000000];
    }else if(position==2){//保留2位
        return [NSString stringWithFormat:@"%.2f",round([priceNum floatValue]*1000000000000)/1000000000000];
    }else if(position==3){//保留3位
        return [NSString stringWithFormat:@"%.3f",round([priceNum floatValue]*1000000000000)/1000000000000];
    }else if(position==4){//保留4位
        return [NSString stringWithFormat:@"%.4f",round([priceNum floatValue]*1000000000000)/1000000000000];
    }
    //默认保留2位
    return [NSString stringWithFormat:@"%.2f",round([priceNum floatValue]*1000000000000)/1000000000000];}

#pragma mark - 设置不同字体颜色和大小
+ (void)LabelAttributedString:(UILabel *)labell FontNumber:(id)font AndRange:(NSRange)range AndColor:(UIColor * __nullable)vaColor {
//    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:labell.text];
//    [str addAttribute:NSFontAttributeName value:font range:range];
//    if (vaColor) {
//        [str addAttribute:NSForegroundColorAttributeName value:vaColor range:range];
//    }
//    labell.attributedText = str;
}

#pragma mark - 切圆角
/**
 按钮的圆角设置

 @param view view类控件
 @param rectCorner UIRectCorner要切除的圆角
 @param borderColor 边框颜色
 @param borderWidth 边框宽度
 @param viewColor view类控件颜色
 */
+ (void)setupRoundedCornersWithView:(UIView *)view cutCorners:(UIRectCorner)rectCorner borderColor:(UIColor *__nullable)borderColor cutCornerRadii:(CGSize)radiiSize borderWidth:(CGFloat)borderWidth viewColor:(UIColor *__nullable)viewColor {

    CAShapeLayer *mask=[CAShapeLayer layer];
    UIBezierPath * path= [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:rectCorner cornerRadii:radiiSize];
    mask.path=path.CGPath;
    mask.frame=view.bounds;

    CAShapeLayer *borderLayer=[CAShapeLayer layer];
    borderLayer.path=path.CGPath;
    borderLayer.fillColor = [UIColor clearColor].CGColor;
    borderLayer.strokeColor = borderColor.CGColor;
    borderLayer.lineWidth = borderWidth;
    borderLayer.frame = view.bounds;
    view.layer.mask = mask;
    [view.layer addSublayer:borderLayer];
}

#pragma mark - 修改 uiimage的大小
+ (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)newsize {
    UIGraphicsBeginImageContext(newsize);
    [img drawInRect:CGRectMake(0, 0, newsize.width, newsize.height)];
    UIImage *scaleImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaleImage;;
}

/**
    金额分转元
 */
+ (NSString *)formatToTwoDecimal:(id)count {
    NSString *originNumber;
    if ([count isKindOfClass:[NSString class]] || [count isKindOfClass:[NSNumber class]]) {
        NSInteger i = [count integerValue];
        originNumber = [NSString stringWithFormat:@"%ld",(long)i];
    } else {
        return @"0.00";
    }
    NSDecimalNumber *one = [NSDecimalNumber decimalNumberWithString:originNumber];
    NSDecimalNumber *two = [NSDecimalNumber decimalNumberWithString:@"100"];
    NSDecimalNumber *thr = [one decimalNumberByDividingBy:two];
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
    formatter.positiveFormat = @",###.##";
    NSString *money = [formatter stringFromNumber:[NSNumber numberWithDouble:[thr doubleValue]]];
    
    NSString *result = [NSString stringWithFormat:@"%@",money];
    
    if (![result containsString:@"."]) {  //被整除的情况
        result = [NSString stringWithFormat:@"%@.00",result];
    } else {                              //小数不足两位
        NSArray *array = [result componentsSeparatedByString:@"."];
        NSString *subNumber = array.lastObject;
        if (subNumber.length == 1) {
            result = [NSString stringWithFormat:@"%@.%@0",array.firstObject, array.lastObject];
        }
    }
    return result;
}

/**
 校验身份证号码是否正确 返回BOOL值

 @param idCardString 身份证号码
 @return 返回BOOL值 YES or NO
 */
+ (BOOL)cly_verifyIDCardString:(NSString *)idCardString {
    NSString *regex = @"^[1-9]\\d{5}(18|19|([23]\\d))\\d{2}((0[1-9])|(10|11|12))(([0-2][1-9])|10|20|30|31)\\d{3}[0-9Xx]$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    BOOL isRe = [predicate evaluateWithObject:idCardString];
    if (!isRe) {
         //身份证号码格式不对
        return NO;
    }
    //加权因子 7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2
    NSArray *weightingArray = @[@"7", @"9", @"10", @"5", @"8", @"4", @"2", @"1", @"6", @"3", @"7", @"9", @"10", @"5", @"8", @"4", @"2"];
    //校验码 1, 0, 10, 9, 8, 7, 6, 5, 4, 3, 2
    NSArray *verificationArray = @[@"1", @"0", @"10", @"9", @"8", @"7", @"6", @"5", @"4", @"3", @"2"];
    
    NSInteger sum = 0;//保存前17位各自乖以加权因子后的总和
    for (int i = 0; i < weightingArray.count; i++) {//将前17位数字和加权因子相乘的结果相加
        NSString *subStr = [idCardString substringWithRange:NSMakeRange(i, 1)];
        sum += [subStr integerValue] * [weightingArray[i] integerValue];
    }
    
    NSInteger modNum = sum % 11;//总和除以11取余
    NSString *idCardMod = verificationArray[modNum]; //根据余数取出校验码
    NSString *idCardLast = [idCardString.uppercaseString substringFromIndex:17]; //获取身份证最后一位
    
    if (modNum == 2) {//等于2时 idCardMod为10  身份证最后一位用X表示10
        idCardMod = @"X";
    }
    if ([idCardLast isEqualToString:idCardMod]) { //身份证号码验证成功
        return YES;
    } else { //身份证号码验证失败
        return NO;
    }
}

+ (NSMutableDictionary *)getPayResultDicToClientWithCode:(NSString *_Nonnull)code
                                                withData:(id _Nonnull)data
                                             withMessage:(NSString *_Nonnull)message {
    NSMutableDictionary *mutableDic = [NSMutableDictionary dictionary];
    if (code) {
        [mutableDic setValue:code forKey:@"code"];
    }
    if (data) {
        [mutableDic setValue:data forKey:@"data"];
    }
    if (message) {
        [mutableDic setValue:message forKey:@"message"];
    }
    return mutableDic;
}

#pragma mark - 单利
+ (instancetype)sharedSingleton {
    static ZDPayFuncTool *_encryptAndDecryptTool = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //不能再使用alloc方法
        //因为已经重写了allocWithZone方法，所以这里要调用父类的分配空间的方法
        _encryptAndDecryptTool = [[ZDPayFuncTool alloc] init];
    });
    return _encryptAndDecryptTool;
}

- (NSDictionary *)getGetSmsCodeDictionary {
    ZDPay_OrderSureModel *model = [[ZDPay_OrderSureModel sharedSingleten] getModelData];
    ZDPay_AddBankModel *addModel = [[ZDPay_AddBankModel sharedSingleten] getModelData];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *cardType = [userDefaults objectForKey:@"cardType"];
    NSDictionary *dic;
    if ([cardType isEqualToString:@"C"]) {
        dic = @{
            @"language":model.language,
            @"registerCountryCode":model.registerCountryCode,
            @"registerMobile":model.registerMobile,
            @"bankCountryCode":addModel.registerCountryCode,
            @"merId":model.merId,
            @"cardNo":addModel.cardNo,
            @"cardNum":addModel.cardNum,
            @"cardName":addModel.cardName,
            @"bankMobile":addModel.registerMobile,
            @"cvn":addModel.CVN,
            @"expired":addModel.termValidity,
            @"cardflag":addModel.documentType,//证件类型
            @"orderNo":model.orderNo,//订单号
        };
    } else {
        dic = @{
            @"language":model.language,
            @"registerCountryCode":model.registerCountryCode,
            @"registerMobile":model.registerMobile,
            @"bankCountryCode":addModel.registerCountryCode,
            @"merId":model.merId,
            @"cardNo":addModel.cardNo,
            @"cardNum":addModel.cardNum,
            @"cardName":addModel.cardName,
            @"bankMobile":addModel.registerMobile,
            @"cardflag":addModel.documentType,//证件类型
            @"orderNo":model.orderNo,//订单号
        };
    }

    return dic;
}

- (NSDictionary *)getChecksmsCodeDictionary {
    
    ZDPay_OrderSureModel *model = [[ZDPay_OrderSureModel sharedSingleten] getModelData];
    ZDPay_AddBankModel *addModel = [[ZDPay_AddBankModel sharedSingleten] getModelData];
    ZDPay_OrderSureRespModel *orderModel = [[ZDPay_OrderSureRespModel sharedSingleten] getModelData];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *cardType = [userDefaults objectForKey:@"cardType"];
    NSDictionary *dic;
    if ([cardType isEqualToString:@"C"]) {
        dic = @{
            @"language":model.language,
            @"cardNo":addModel.cardNo,
            @"registerCountryCode":model.registerCountryCode,
            @"registerMobile":model.registerMobile,
            @"cardNum":addModel.cardNum,
            @"isUser":orderModel.isUser,
            @"cardName":addModel.cardName,
            @"bankCountryCode":addModel.registerCountryCode,
            @"bankMobile":addModel.registerMobile,
            @"merId":model.merId,
            @"cvn":addModel.CVN,
            @"expired":addModel.termValidity,
            @"cardflag":addModel.documentType,//证件类型
            @"orderId":model.orderNo,
            @"isSendPurchase":model.isSendPurchase,//是否发起消费
        };
    } else {
        dic = @{
            @"language":model.language,
            @"cardNo":addModel.cardNo,
            @"registerCountryCode":model.registerCountryCode,
            @"registerMobile":model.registerMobile,
            @"cardNum":addModel.cardNum,
            @"isUser":orderModel.isUser,
            @"cardName":addModel.cardName,
            @"bankCountryCode":addModel.registerCountryCode,
            @"bankMobile":addModel.registerMobile,
            @"merId":model.merId,
            @"cardflag":addModel.documentType,//证件类型
            @"orderId":model.orderNo,
            @"isSendPurchase":model.isSendPurchase,//是否发起消费
        };
    }

    return dic;
}

- (NSDictionary *)getWechatDictionary {
    ZDPay_OrderSureModel *model = [[ZDPay_OrderSureModel sharedSingleten] getModelData];
    ZDPay_OrderSurePayListRespModel *payModel = [[ZDPay_OrderSurePayListRespModel sharedSingleten] getModelData];
    int txnAmt;
    txnAmt = ceil([model.txnAmt floatValue]);
    NSDictionary *dic = @{
        @"payPwd": @"123456",
        @"customerNo": @"868000544470638",
        @"merId": model.merId,
        @"desc": model.desc,
        @"mcc": model.mcc,
        @"orderNo": model.orderNo,
        @"notifyUrl": model.notifyUrl,
        @"payType": payModel.channelCode,
        @"realIp": model.realIp,
        @"referUrl": model.referUrl,
        @"service": model.service_d,
        @"subAppid": model.subAppid,
        @"subject": model.subject,
        @"timeExpire": model.timeExpire,
        @"version": model.version,
        @"txnAmt":  [NSString stringWithFormat:@"%d",txnAmt],
        @"language": model.language,
        @"registerCountryCode": model.registerCountryCode,
        @"registerMobile": model.registerMobile,
        @"txnCurr": model.txnCurr,
        @"cardNum": @"6214836553767597",
    };
    return dic;
}

//支付宝参数
- (NSDictionary *)getPutPayDictionary {
    ZDPay_OrderSureModel *model = [[ZDPay_OrderSureModel sharedSingleten] getModelData];
    int txnAmt;
    txnAmt = ceil([model.txnAmt floatValue]);
    NSDictionary *dic = @{
        @"merId": model.merId,
        @"customerNo": @"868000544470638",
        @"desc": model.desc,
        @"mcc": model.mcc,
        @"orderNo": model.orderNo,
        @"notifyUrl": model.notifyUrl,
        @"payType": @"ALIPAY",
        @"realIp": model.realIp,
        @"referUrl": model.referUrl,
        @"service": model.service_d,
        @"subAppid": model.subAppid,
        @"subject": model.subject,
        @"timeExpire": model.timeExpire,
        @"userId": model.userId,
        @"version": model.version,
        @"txnAmt": [NSString stringWithFormat:@"%d",txnAmt],
        @"language": model.language,
        @"registerCountryCode": model.registerCountryCode,
        @"registerMobile": model.registerMobile,
        @"txnCurr": model.txnCurr,
        @"payPwd": @"123456",
        @"cardNum": @"6214836553767597",
    };
    return dic;
}

//银联支付参数
- (NSDictionary *)getSurePayPasswordDictionary {
    ZDPay_OrderSureModel *model = [[ZDPay_OrderSureModel sharedSingleten] getModelData];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *password = [userDefaults objectForKey:@"password"];
    int txnAmt;
    txnAmt = ceil([model.txnAmt floatValue]);
    NSDictionary *dic = @{
        @"merId": model.merId,
        @"desc": model.desc,
        @"mcc": model.mcc,
        @"orderNo": model.orderNo,
        @"notifyUrl": model.notifyUrl,
        @"payType": @"UNIONPAY",
        @"realIp": model.realIp,
        @"referUrl": model.referUrl,
        @"service": model.service_d,
        @"subAppid": model.subAppid,
        @"subject": model.subject,
        @"timeExpire": model.timeExpire,
        @"userId": model.userId,
        @"version": model.version,
        @"txnAmt": [NSString stringWithFormat:@"%d",txnAmt],
        @"language": model.language,
        @"registerCountryCode": model.registerCountryCode,
        @"registerMobile": model.registerMobile,
        @"txnCurr": model.txnCurr,
        @"payPwd": password,
        @"purchaseType":model.purchaseType
    };
    return dic;
}

//applePay支付参数
- (NSDictionary *)getApplePayDictionary {
    ZDPay_OrderSureModel *model = [[ZDPay_OrderSureModel sharedSingleten] getModelData];
    int txnAmt;
    txnAmt = ceil([model.txnAmt floatValue]);
    NSDictionary *dic = @{
//持卡人姓名    customerNm
//银行卡密码    pin
//IC卡数据    ICCardData
        @"ICCardData": @"",
        @"customerNm": @"",
        @"pin": @"",
        @"accNo": @"6214836553767597",
        @"bizType": @"000201",
        @"channelType": @"08",
        @"reqReserved": @"",
        @"txnSubType": @"01",
        @"payType": @"APPLEPAY",
        @"payPwd": @"123456",
        @"txnType": @"01",
        @"notifyUrl": model.notifyUrl,
        @"merId": model.merId,
        @"orderNo": model.orderNo,
        @"txnAmt": [NSString stringWithFormat:@"%d",txnAmt],
        @"txnTime": model.txnTime,
        @"registerCountryCode": model.registerCountryCode,
        @"registerMobile": model.registerMobile,
        @"language": model.language,
        @"txnCurr": model.txnCurr,
        @"cardNum": @"6214836553767597",
        @"merchantid":model.merchantid,
        @"countryCode":model.countryCode,
        @"currencyCode":model.currencyCode,
        };
    return dic;
}

//云闪付支付
- (NSDictionary *)getUnionCloudPayDictionary {
    ZDPay_OrderSureModel *model = [[ZDPay_OrderSureModel sharedSingleten] getModelData];
    ZDPay_OrderSurePayListRespModel *payModel = [[ZDPay_OrderSurePayListRespModel sharedSingleten] getModelData];
    int txnAmt;
    txnAmt = ceil([model.txnAmt floatValue]);
    NSDictionary *dic = @{
        @"accNo": @"6214836553767597",
        @"bizType": @"000201",
        @"channelType": @"08",
        @"reqReserved": @"",
        @"txnSubType": @"01",
        @"notifyUrl": model.notifyUrl,
        @"merId": model.merId,
        @"orderNo": model.orderNo,
        @"payTimeout": model.payTimeout,
        @"txnAmt": [NSString stringWithFormat:@"%d",txnAmt],
        @"txnTime": model.txnTime,
        @"payType": payModel.channelCode,
        @"registerCountryCode": model.registerCountryCode,
        @"registerMobile": model.registerMobile,
        @"language": model.language,
        @"txnCurr": model.txnCurr,
        @"payPwd": @"123456",
        @"cardNum": @"6214836553767597",
    };
    return dic;
}

- (NSDictionary *)getAppInternationalizationDictionary {
    ZDPay_OrderSureModel *model = [[ZDPay_OrderSureModel sharedSingleten] getModelData];
    NSDictionary *dic = @{
        @"languageType": model.language,
    };
    return dic;
}
@end

