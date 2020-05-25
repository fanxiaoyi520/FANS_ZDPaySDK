//
//  ZDPayNetRequestManager.h
//  ReadingEarn
//
//  Created by FANS on 2020/4/14.
//  Copyright © 2020 FANS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZDPayRootViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZDPayNetRequestManager : NSObject

+ (instancetype)sharedSingleton;
- (void)zd_netRequestVC:(ZDPayRootViewController *)requestVC
                 Params:(id)params
             postUrlStr:(NSString *)urlStr
                suscess:(void (^)(id _Nullable responseObject))suscess;
@end

NS_ASSUME_NONNULL_END
