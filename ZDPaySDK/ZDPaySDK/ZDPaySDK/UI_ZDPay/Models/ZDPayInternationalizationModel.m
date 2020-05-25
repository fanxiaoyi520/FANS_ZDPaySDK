//
//  ZDPayInternationalizationModel.m
//  ZDPaySDK
//
//  Created by FANS on 2020/4/28.
//  Copyright © 2020 ZhongDaoGroup. All rights reserved.
//

#import "ZDPayInternationalizationModel.h"
#import "ZDPayFuncTool.h"

@interface ZDPayInternationalizationModel()
@property (nonatomic ,strong)ZDPayInternationalizationModel *model;
@end

@implementation ZDPayInternationalizationModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             };
}

+ (instancetype)sharedSingleten {
    static ZDPayInternationalizationModel *_sharedSingleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
          // 要使用self来调用
        _sharedSingleton = [[self alloc] init];
    });
    return _sharedSingleton;
}

- (void)setModelProcessingDic:(NSDictionary *)dic {
     self.model = [ZDPayInternationalizationModel mj_objectWithKeyValues:dic];
}

- (ZDPayInternationalizationModel *)getModelData {
    return self.model;
}
@end
