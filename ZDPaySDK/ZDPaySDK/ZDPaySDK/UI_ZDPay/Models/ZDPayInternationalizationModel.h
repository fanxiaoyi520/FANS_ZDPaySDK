//
//  ZDPayInternationalizationModel.h
//  ZDPaySDK
//
//  Created by FANS on 2020/4/28.
//  Copyright © 2020 ZhongDaoGroup. All rights reserved.
//

#import "ZDPayRootModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZDPayInternationalizationModel : ZDPayRootModel
+ (instancetype)sharedSingleten;
- (void)setModelProcessingDic:(NSDictionary *)dic;
- (instancetype)getModelData;

@property (nonatomic ,copy)NSString *ADD_BANK_CARD;
@property (nonatomic ,copy)NSString *ARMY_ID_CARD;
@property (nonatomic ,copy)NSString *CARD_NO;
@property (nonatomic ,copy)NSString *CLICK_HERE_TO_INDICATE_THAT_YOU_HAVE_READ_AND_AGREE_TO_THE_PAYMENT_AGREEMENT;
@property (nonatomic ,copy)NSString *CONFIRM_AND_PAY;
@property (nonatomic ,copy)NSString *ENTER_BANK_CARD_NO;
@property (nonatomic ,copy)NSString *ENTER_THE_CODE;
@property (nonatomic ,copy)NSString *FORGOT_PASSWORD;
@property (nonatomic ,copy)NSString *FOR_EXAMPLE;
@property (nonatomic ,copy)NSString *HOME_REENTRY_PERMIT;
@property (nonatomic ,copy)NSString *HONG_KONG;
@property (nonatomic ,copy)NSString *ID_CARD;
@property (nonatomic ,copy)NSString *ID_NO;
@property (nonatomic ,copy)NSString *ID_TYPE;
@property (nonatomic ,copy)NSString *MACAO;
@property (nonatomic ,copy)NSString *MAINLAND_CHINA;
@property (nonatomic ,copy)NSString *MALAYSIA;
@property (nonatomic ,copy)NSString *MY_WALLET;
@property (nonatomic ,copy)NSString *NAME;
@property (nonatomic ,copy)NSString *NEXT;
@property (nonatomic ,copy)NSString *ORDER_NO;
@property (nonatomic ,copy)NSString *PASSPORT;
@property (nonatomic ,copy)NSString *PASSWORD;//请输入支付密码
@property (nonatomic ,copy)NSString *PAYMENT;//订单支付
@property (nonatomic ,copy)NSString *PLEASE_CONFIRM_PASSWORD;
@property (nonatomic ,copy)NSString *PLEASE_ENTER_BANK_ACCOUNT_RESERVATION_PHONE_NO;
@property (nonatomic ,copy)NSString *PLEASE_ENTER_ONE_TIME_PIN;
@property (nonatomic ,copy)NSString *PLEASE_SET_NEW_PASSWORD;
@property (nonatomic ,copy)NSString *POLICE_OFFICER_ID_CARD;
@property (nonatomic ,copy)NSString *PROCESSING;//支付中
@property (nonatomic ,copy)NSString *REQUEST_OTP;
@property (nonatomic ,copy)NSString *SECURITY_CODE;
@property (nonatomic ,copy)NSString *SINGAPORE;
@property (nonatomic ,copy)NSString *TIME_REMAINING;
@property (nonatomic ,copy)NSString *UNBIND;
@property (nonatomic ,copy)NSString *ORDER_CONFIRMATION;//订单确认
@property (nonatomic ,copy)NSString *PLEASE_ADD_PAYMENT_METHOD;//添加支付方式
@property (nonatomic ,copy)NSString *EXPIRATION_DATE;//有效期
@property (nonatomic ,copy)NSString *PLEASE_INDICATE_THAT_YOU_HAVE_READ_AND_AGREE_TO_THE_PAYMENT_AGREEMENT_BEFORE_INITIATING_PAYMENT;//点击确认，表示您已经阅读并同意《支付协议》
@property (nonatomic ,copy)NSString *IDENTITY_VERIFICATION_VERIFY_YOUR_IDENTITY_BY_ENTERING_PAYMENT_PASSWORD;//请输入支付密码，以验证身份
@property (nonatomic ,copy)NSString *SECURITY_VERIFICATION;//安全认证
@property (nonatomic ,copy)NSString *PASSWORD_WAS_SUCCESSFULLY_CREATED;//设置密码成功
@property (nonatomic ,copy)NSString *BIND_SUCCESSFULLY;//绑定银行卡成功
@property (nonatomic ,copy)NSString *PLS_READ_AND_AGREE_TO_THE_PAYMENT_AGREEMENT_BEFORE_INITIATING_PAYMENT;//请同意支付协议再发起支付
@property (nonatomic ,copy)NSString *PLEASE_SELECT_PAYMENT_METHOD;//请选择支付方式
@property (nonatomic ,copy)NSString *PLEASE_ENTER_YOUR_NAME;//请输入姓名
@property (nonatomic ,copy)NSString *PLEASE_ENTER_YOUR_ID_NUMBER;//请输入证件号码
@property (nonatomic ,copy)NSString *PLEASE_ENTER_AN_11DIGIT_PHONE_NUMBER;//请输入11位的手机号码
@property (nonatomic ,copy)NSString *PLEASE_ENTER_AN_8DIGIT_PHONE_NUMBER;//请输入8位的手机号码
@property (nonatomic ,copy)NSString *PLEASE_ENTER_EXPIRY_DAY;//请输入有效期
@property (nonatomic ,copy)NSString *PLEASE_ENTER_CVN;//请输入正确的CVN
@property (nonatomic ,copy)NSString *PLEASE_SELECT_ID_TYPE;//请选择证件类型
@property (nonatomic ,copy)NSString *RESET_OTP;//重新获取验证码
@property (nonatomic ,copy)NSString *OTP_EXPIRATION;//验证码过期
@property (nonatomic ,copy)NSString *INCORRECT_OTP;//请输入正确的验证码
@property (nonatomic ,copy)NSString *PLEASE_ENTER_YOUR_CARD_NUMBER;//请输入银行卡号
@property (nonatomic ,copy)NSString *PLEASE_ENTER_OTP;//请输入验证码
@property (nonatomic ,copy)NSString *PLEASE_ADD_A_BANK_CARD;//暂未绑卡
@property (nonatomic ,copy)NSString *User_cancels_payment_midway;//用户中途取消付款
@property (nonatomic ,copy)NSString *Network_Connection_Error;//网络连接出错
@property (nonatomic ,copy)NSString *The_correct_payment_method_is_not_passed_in_please_refer_to_the_document;//没有传入正确的支付方式，请参考文档传参
@property (nonatomic ,copy)NSString *Please_enter_the_correct_CVN;//请输入正确的CVN
@property (nonatomic ,copy)NSString *Please_enter_the_correct_expiry_date;//请输入正确的有效期
@property (nonatomic ,copy)NSString *Processing_please_check_the_results_later;//正在处理中，请稍候查看结果
@property (nonatomic ,copy)NSString *PHONE_NO;//手机号





@property (nonatomic ,copy)NSString *CANCEL_PAYMENT;//用户中途取消付款
@property (nonatomic ,copy)NSString *NETWORK_CONNECTION_ERROR;//网络连接出错
@property (nonatomic ,copy)NSString *YOUR_PAYMENT_METHOD_HAS_BEEN_DECLINED__PLEASE_CLICK_BILLING_INFO_AND_UPDATE_YOUR_PAYMENT_INFORMATION;//没有传入正确的支付方式，请参考文档传参
@property (nonatomic ,copy)NSString *PLEASE_ENTER_THE_VALID_CVN;//请输入正确的CVN
@property (nonatomic ,copy)NSString *PLEASE_ENTER_THE_VALID_EXPIRATION_DATE;//请输入正确的有效期
@property (nonatomic ,copy)NSString *PROCESSINGPLEASE_WAIT_;//正在处理中，请稍候查看结果！

@property (nonatomic ,copy)NSString *PAY_BY_UNIONPAY_CARD;//银联卡支付
@property (nonatomic ,copy)NSString *SWITCH_UNIONPAY_CARD;//切换银联卡
@property (nonatomic ,copy)NSString *AND_MORE_PAYMENT_METHODS;//展开更多支付方式
@property (nonatomic ,copy)NSString *PLEASE_READ_AND_AGREE_TO_THE_PAYMENT_AGREEMENT_BEFORE_INITIATING_PAYMENT;//请同意支付协议再发起支付
@property (nonatomic ,copy)NSString *AND_MORE_BANK_CARD;//展开更多银行卡
//@property (nonatomic ,copy)NSString *ADD_BANK_CARD;//添加银行卡支付
@property (nonatomic ,copy)NSString *SELECTE_PAYMENT_METHOD;//选择支付方式
@property (nonatomic ,copy)NSString *NO_MORE_BANK_CARD;//没有更多的银行卡
@property (nonatomic ,copy)NSString *You_haven_added_your_card_yet;
@property (nonatomic ,copy)NSString *Loading;//加载中...
@property (nonatomic ,copy)NSString *Mobile_Phone_No;//手机号码
@property (nonatomic ,copy)NSString *Verification_code_has_been_sent;//验证码已发送
@property (nonatomic ,copy)NSString *Card_binding_successful;//绑卡成功
@property (nonatomic ,copy)NSString *Security_Central;//安全中心
@property (nonatomic ,copy)NSString *Password_inconsistent;//密码输入不一致
@property (nonatomic ,copy)NSString *My_wallet;//我的钱包
@property (nonatomic ,copy)NSString *Unbind_successful;//解绑成功
@property (nonatomic ,copy)NSString *Please_get_verification_code_first;//请先获取验证码
@property (nonatomic ,copy)NSString *Card_not_added;//您尚为添加银行卡
@property (nonatomic ,copy)NSString *Three_digits_on_the_back_of_the_card_such_as_888;
@property (nonatomic ,copy)NSString *DATA_FORMAT_enter_0915;//示例: 09/15,输入0915
@end

NS_ASSUME_NONNULL_END
