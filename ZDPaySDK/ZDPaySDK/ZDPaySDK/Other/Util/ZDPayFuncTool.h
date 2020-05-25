//
//  ZDPayFuncTool.h
//  ReadingEarn
//
//  Created by FANS on 2020/4/14.
//  Copyright © 2020 FANS. All rights reserved.
//


#define ZDScreen_Width ([UIScreen mainScreen].bounds.size.width)
#define ZDScreen_Height ([UIScreen mainScreen].bounds.size.height)

#define mc_Is_iphone (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define mc_Is_iphoneX ZDScreen_Width >=375.0f && ZDScreen_Height >=812.0f&& mc_Is_iphone
    
/*状态栏高度*/
#define mcStatusBarHeight (CGFloat)(mc_Is_iphoneX?(44.0):(20.0))
/*导航栏高度*/
#define mcNavBarHeight (44)
/*状态栏和导航栏总高度*/
#define mcNavBarAndStatusBarHeight (CGFloat)(mc_Is_iphoneX?(88.0):(64.0))
#define DEFAULT_IMAGE [UIImage imageNamed:@"alipay-hk"]

#define StatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height
#define NavBarHeight 44.f
#define NavHeight (StatusBarHeight + NavBarHeight)
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define REImageName(imageName) [UIImage imageNamed:imageName]
#define TagBackBtn 5555;
//#define ZD_Fout_Medium(x) [UIFont fontWithName:@"PingFangSC-Medium" size:x]
#define ZD_Fout_Medium(x) [UIFont systemFontOfSize:x]
#define ZD_Fout_Regular(x) [UIFont fontWithName:@"PingFangSC-Regular" size:x]
#define ZD_Fount_System(x) [UIFont systemFontOfSize:x]
//默认图片
#define PlaceholderImage [UIImage imageNamed:@""]
#define PlaceholderHead_Image [UIImage imageNamed:@"re_default_head"]
#define WeakObj(o) try{}@finally{} __weak typeof(o) o##Weak = o;
#define StrongObj(o) autoreleasepool{} __strong typeof(o) o = o##Weak;
#define ratioH(H)   H
#define ratioW(W)   W
#define SETUPPAYMENTFEED @"Set up payment feed"
#define BINDBANKCARDSUCCEEDED @"Bind bank card succeeded"

#import <Foundation/Foundation.h>
#import "EncryptAndDecryptTool.h"
#import "ZDPayPopView.h"
#import "CountDown.h"
#import "UIView+Frame.h"
#import "UIView+Toast.h"
#import "MJExtension.h"
#import <UIKit/UIKit.h>

#import "ZDPayNetRequestManager.h"
#import "ZDPay_OrderSureModel.h"
#import "ZDPay_AddBankModel.h"
#import "ZDPay_OrderSureRespModel.h"
#import <PassKit/PassKit.h>
#import "ZDPayInternationalizationModel.h"
#import "NNValidationCodeView.h"

NS_ASSUME_NONNULL_BEGIN
//域名
FOUNDATION_EXPORT NSString *_Nullable const DOMAINNAME;//域名
FOUNDATION_EXPORT NSString *_Nullable const DOMAINNAME_ONE;//域名


//接口
FOUNDATION_EXPORT NSString * _Nullable const GETALLLANGUAGES;//获取所有语言
FOUNDATION_EXPORT NSString * _Nullable const QUERYPAYMETHOD;//查询银行卡信息列表
FOUNDATION_EXPORT NSString * _Nullable const CHECKCARDTYPE;//快捷支付查询银行卡号信息
FOUNDATION_EXPORT NSString * _Nullable const SENDBINDCARDSMS;//快捷支付绑卡获取短信
FOUNDATION_EXPORT NSString * _Nullable const CHECKBINDCARDSMS;//快捷支付绑卡短信验证
FOUNDATION_EXPORT NSString * _Nullable const SETPAYPWD;//快捷支付设置支付密码
FOUNDATION_EXPORT NSString * _Nullable const  CHECKPAYPWD;//快捷支付验证支付密码
FOUNDATION_EXPORT NSString * _Nullable const UNBINDBANKCARD;//快捷支付解绑银行卡
FOUNDATION_EXPORT NSString * _Nullable const  SENDFORGETPWDSMS;//快捷支付忘记密码获取短信
FOUNDATION_EXPORT NSString * _Nullable const  CHECKFORGETPWDSMS;//验证忘记密码短信
FOUNDATION_EXPORT NSString * _Nullable const  CHANGEACCOUNTPWD;//快捷支付修改密码
FOUNDATION_EXPORT NSString * _Nullable const  PAY;//消费类交易(支付)
FOUNDATION_EXPORT NSString * _Nullable const  REFUND;//快捷支付消费撤销、退货、预授权完成或预授权撤销
FOUNDATION_EXPORT NSString * _Nullable const  QUERYPAYRESULT;//交易查询状态
FOUNDATION_EXPORT NSString * _Nullable const PAYMENT;//支付宝支付的接口

FOUNDATION_EXPORT UIColor * _Nullable COLORWITHHEXSTRING(NSString * _Nullable hexString,CGFloat alpha);


@interface ZDPayFuncTool : NSObject
#pragma mark - 定时器相关

#pragma mark - public method
//获取字符串宽高-------推荐
+ (CGRect)getStringWidthAndHeightWithStr:(NSString *)str withFont:(UIFont *)font;
//获取字符串的宽度
+(float) widthForString:(NSString *)value fontSize:(float)fontSize andHeight:(float)height;
//获得字符串的高度
+(float) heightForString:(NSString *)value fontSize:(float)fontSize andWidth:(float)width;
//保留小数点位数
+(NSString *)getRoundFloat:(double)number withPrecisionNum:(NSInteger)position;
//设置不同字体颜色和大小
+(void)LabelAttributedString:(UILabel *)labell FontNumber:(id)font AndRange:(NSRange)range AndColor:(UIColor * __nullable)vaColor;
//切圆角
+ (void)setupRoundedCornersWithView:(UIView *)view cutCorners:(UIRectCorner)rectCorner borderColor:(UIColor *__nullable)borderColor cutCornerRadii:(CGSize)radiiSize borderWidth:(CGFloat)borderWidth viewColor:(UIColor *__nullable)viewColor;
//修改UIImage的大小
+ (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)newsize;
/**
    金额分转元
 */
+ (NSString *)formatToTwoDecimal:(id)count;
/**
 校验身份证号码是否正确 返回BOOL值

 @param idCardString 身份证号码
 @return 返回BOOL值 YES or NO
 */
+ (BOOL)cly_verifyIDCardString:(NSString *)idCardString;

/**
    支付结果信息字典
 */
+ (NSMutableDictionary *)getPayResultDicToClientWithCode:(NSString *_Nonnull)code
                                                withData:(id _Nonnull)data
                                             withMessage:(NSString *_Nonnull)message;
#pragma mark - 单利
+ (instancetype)sharedSingleton;
//国际化参数
- (NSDictionary *)getAppInternationalizationDictionary;
//支付宝参数
- (NSDictionary *)getPutPayDictionary;
//银联支付参数
- (NSDictionary *)getSurePayPasswordDictionary;
//applePay支付参数
- (NSDictionary *)getApplePayDictionary;
//云闪付参数
- (NSDictionary *)getUnionCloudPayDictionary;
//微信支付参数
- (NSDictionary *)getWechatDictionary;
//获取验证码参数
- (NSDictionary *)getGetSmsCodeDictionary;
//获取校验验证码参数
- (NSDictionary *)getChecksmsCodeDictionary;
@end

NS_ASSUME_NONNULL_END
