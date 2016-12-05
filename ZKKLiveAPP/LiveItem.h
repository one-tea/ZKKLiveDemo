//
//  LiveItem.h
//  ZKKLiveAPP
//
//  Created by Kevin on 16/12/5.
//  Copyright © 2016年 zhangkk. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Creator;
@interface LiveItem : NSObject

/** 直播流地址 */
@property (nonatomic, copy) NSString *stream_addr;
/** 关注人 */
@property (nonatomic, assign) NSUInteger online_users;
/** 城市 */
@property (nonatomic, copy) NSString *city;
/** 主播 */
@property (nonatomic, strong) Creator *creator;

@end


@interface Creator : NSObject

/** 主播名 */
@property (nonatomic, strong) NSString *nick;
/** 主播头像 */
@property (nonatomic, strong) NSString *portrait;

@end
