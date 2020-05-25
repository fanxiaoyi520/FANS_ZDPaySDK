//
//  ZDPayNetRequestManager.m
//  ReadingEarn
//
//  Created by FANS on 2020/4/14.
//  Copyright © 2020 FANS. All rights reserved.
//

#import "ZDPayNetRequestManager.h"
#import "ZDPayFuncTool.h"
#import "ZDPay_OrderSureViewController.h"
typedef void (^ZDPayCompletioBlock)(NSDictionary *dic, NSURLResponse *response, NSError *error);
typedef void (^ZDPaySuccessBlock)(NSDictionary *data);
typedef void (^ZDPayFailureBlock)(NSError *error);

@implementation ZDPayNetRequestManager
+ (instancetype)sharedSingleton {
    static ZDPayNetRequestManager *_payNetRequestManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _payNetRequestManager = [[ZDPayNetRequestManager alloc] init];
    });
    return _payNetRequestManager;
}

- (void)zd_netRequestVC:(ZDPayRootViewController *)requestVC
                 Params:(id)params
             postUrlStr:(NSString *)urlStr
                suscess:(void (^)(id _Nullable responseObject))suscess {
    NSParameterAssert(params);
    NSParameterAssert(urlStr);
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setDictionary:params];
    NSArray *array = param.allKeys;
    if (![array containsObject:@"languageType"]) {
        [param setValue:[[ZDPay_OrderSureModel sharedSingleten] getModelData].language forKey:@"languageType"];
    }

    NSString *signData = [self encodedSendingBody:param];
    NSString *s = [self encryptSendingBody:param];
    NSString *encryptData = [[EncryptAndDecryptTool sharedSingleton] AESEncryptWithString:s andKey:[[ZDPay_OrderSureModel sharedSingleten] getModelData].AES_Key];
    NSDictionary *paramsDic = @{
        @"signData":signData,
        @"service":[[ZDPay_OrderSureModel sharedSingleten] getModelData].service_d,
        @"encryptData":encryptData,
        @"merId":[[ZDPay_OrderSureModel sharedSingleten] getModelData].merId,
        @"sdkVersion":@"1.0.0",
        @"version":[[ZDPay_OrderSureModel sharedSingleten] getModelData].version
    };
    
    [requestVC.activityIndicator startAnimating];
    requestVC.view.userInteractionEnabled = NO;
    [ZDPayNetRequestManager postWithUrlString:urlStr parameters:paramsDic success:^(NSDictionary *responseObject) {
        if (responseObject != nil) {
            [requestVC.activityIndicator stopAnimating];
            requestVC.view.userInteractionEnabled = YES;
            NSString *code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
            NSString *data = [NSString stringWithFormat:@"%@",responseObject[@"data"]];
            NSString *encryptData = [[EncryptAndDecryptTool sharedSingleton] AESDecryptWithString:data andKey:[[ZDPay_OrderSureModel sharedSingleten] getModelData].AES_Key];
            if ([code isEqualToString:@"200"]) {
                NSDictionary *dics = nil;
                if ([self dictionaryWithJsonString:encryptData]) {
                    dics = [self dictionaryWithJsonString:encryptData];
                } else {
                    dics = @{};
                }
                NSDictionary *dic = @{
                    @"code":code,
                    @"data":dics,
                    @"message":[responseObject objectForKey:@"message"],
                };
                suscess(dic);
            } else {
                NSDictionary *dics = nil;
                if ([self dictionaryWithJsonString:encryptData]) {
                    dics = [self dictionaryWithJsonString:encryptData];
                } else {
                    dics = @{};
                }
                NSDictionary *dic = @{
                    @"code":code,
                    @"data":dics,
                    @"message":[responseObject objectForKey:@"message"],
                };
                suscess(dic);
                if (![[responseObject objectForKey:@"code"] isEqualToString:@"79"] || ![urlStr containsString:@"/pay-gateway/pay/payment"]) {
                    [requestVC showMessage:[responseObject objectForKey:@"message"] target:self];
                }
                if ([urlStr containsString:@"/pay-gateway/pay/payment"]) {
                    NSMutableDictionary *mutableDic = [ZDPayFuncTool getPayResultDicToClientWithCode:@"2000" withData:[responseObject objectForKey:@"data"] withMessage:@"支付失败"];
                    ZDPay_OrderSureViewController *vc = (ZDPay_OrderSureViewController *)requestVC;
                    vc.completionBlock(mutableDic);
                    [requestVC.navigationController popViewControllerAnimated:YES];
                }
            }
        } else {
            NSMutableDictionary *mutableDic = [ZDPayFuncTool getPayResultDicToClientWithCode:@"2000" withData:@"" withMessage:@"支付失败"];
            ZDPay_OrderSureViewController *vc = (ZDPay_OrderSureViewController *)requestVC;
            vc.completionBlock(mutableDic);
            [requestVC.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(NSError *error) {
        [requestVC.activityIndicator stopAnimating];
        requestVC.view.userInteractionEnabled = YES;
        if (error) {
            NSString *responseData = error.userInfo[NSLocalizedDescriptionKey];
            if (![urlStr containsString:@"/pay-gateway/pay/payment"]) {
                [requestVC showMessage:responseData target:nil];
            } else {
                NSMutableDictionary *mutableDic = [ZDPayFuncTool getPayResultDicToClientWithCode:@"2000" withData:responseData withMessage:@"支付失败"];
                ZDPay_OrderSureViewController *vc = (ZDPay_OrderSureViewController *)requestVC;
                vc.completionBlock(mutableDic);
                [requestVC.navigationController popViewControllerAnimated:YES];
            }
        }
    }];
}

//JSON字符串转化为字典
- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }

    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

/**
 对字符串/数组/字典的加密 ----以上修改之后可直接上传返回的字符串
 */
- (NSString*)encryptSendingBody:(id)params{
    NSString * dataStr;
    if ([params isKindOfClass:[NSString class]]) {
        dataStr = params;
    }else{
        NSError*error;
        NSData * data =  [NSJSONSerialization dataWithJSONObject:params
                                                         options:0
                                                           error:&error];
        dataStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    }
    return dataStr;
}

- (NSString*)encodedSendingBody:(id)params{
    NSString * dataStr;
    if ([params isKindOfClass:[NSString class]]) {
        dataStr = params;
    }else{
        NSError*error;
        NSData * data =  [NSJSONSerialization dataWithJSONObject:params
                                                         options:0
                                                           error:&error];
        dataStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    }

    //aes签名
    NSString *encryptStr = [[EncryptAndDecryptTool sharedSingleton] AESEncryptWithString:dataStr andKey:[[ZDPay_OrderSureModel sharedSingleten] getModelData].AES_Key];
    //加签 将所有参与签名的参数名按照字母ASCII码从小到大顺序排序，拼接成”paramName1=value1&paramName2=value2”
    NSDictionary *paramsDic = @{
        @"encryptData":encryptStr,
        @"service":[[ZDPay_OrderSureModel sharedSingleten] getModelData].service_d,
        @"merId":[[ZDPay_OrderSureModel sharedSingleten] getModelData].merId,
        @"sdkVersion":@"1.0.0",
        @"version":[[ZDPay_OrderSureModel sharedSingleten] getModelData].version,
    };
    NSArray *dicAarray = paramsDic.allKeys;
    NSStringCompareOptions comparisonOptions =NSCaseInsensitiveSearch|NSNumericSearch|
    NSWidthInsensitiveSearch|NSForcedOrderingSearch;
    NSComparator sort = ^(NSString *obj1,NSString *obj2){
        NSRange range =NSMakeRange(0,obj1.length);
        return [obj1 compare:obj2 options:comparisonOptions range:range];
    };
    NSArray *resultArray2 = [dicAarray sortedArrayUsingComparator:sort];
    NSString *printStr = @"";
    for(int i = 0; i < [resultArray2 count]; i++){
        printStr = [printStr stringByAppendingFormat:@"%@=%@&",resultArray2[i], [paramsDic objectForKey:[resultArray2 objectAtIndex:i]]];
    }
    
    printStr = [printStr stringByAppendingFormat:@"key=%@",[[ZDPay_OrderSureModel sharedSingleten] getModelData].md5_salt];
    NSString *md532 = [[EncryptAndDecryptTool sharedSingleton] md5_32:printStr upperCase:NO];
    return  md532;
}

#pragma mark - 系统自带请求
//POST请求 使用NSMutableURLRequest可以加入请求头
+ (void)postWithUrlString:(NSString *)url parameters:(id)parameters success:(ZDPaySuccessBlock)successBlock failure:(ZDPayFailureBlock)failureBlock
{
    //NSURL *nsurl = [NSURL URLWithString:url];
    //NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:nsurl];
    //如果想要设置网络超时的时间的话，可以使用下面的方法：
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30];
    
    //设置请求类型
    request.HTTPMethod = @"POST";
    //将需要的信息放入请求头 随便定义了几个
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    //把参数放到请求体内
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:nil];
    //设置请求体
    [request setHTTPBody:jsonData];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) { //请求失败
                failureBlock(error);
            } else {  //请求成功
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                successBlock(dic);
            }
        });
    }];
    [dataTask resume];  //开始请求
}

@end
