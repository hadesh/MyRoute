//
//  AMapSearchAPI.h
//  searchKitV3
//
//  Created by yin cai on 13-7-4.
//  Copyright (c) 2013年 Autonavi. All rights reserved.
//
#import <Foundation/Foundation.h>

#import "AMapSearchObj.h"
#import "AMapCommonObj.h"

@protocol AMapSearchDelegate;

#pragma mark - AMapSearchAPI Interface

@interface AMapSearchAPI : NSObject

/*!
 @brief 实现了AMapSearchDelegate协议的类指针
 */
@property (nonatomic, assign) id<AMapSearchDelegate> delegate;

/*!
 @brief 查询超时时间 默认超时时间20秒
 */
@property (nonatomic, assign) NSInteger timeOut;

/*!
 @brief AMapSearch类对象的初始化函数
 @param key 搜索模块鉴权Key(详情请访问 http://api.amap.com/ )
 @param delegate 实现AMapSearchDelegate协议的对象id
 @return AMapSearch类对象id
 */
- (id)initWithSearchKey:(NSString *)key Delegate:(id<AMapSearchDelegate>)delegate;

/*!
 @brief  POI 查询接口函数，即根据 POI 参数选项进行 POI 查询。
 @param request 查询选项。具体属性字段请参考 AMapPlaceSearchRequest 类。
 */
- (void)AMapPlaceSearch:(AMapPlaceSearchRequest *)request;

/*!
 @brief  导航 查询接口函数。
 @param request  查询选项。具体属性字段请参考 AMapNavigationSearchRequest 类。
 */
- (void)AMapNavigationSearch:(AMapNavigationSearchRequest *)request;

/*!
 @brief  输入提示 查询接口函数。
 @param request 查询选项。具体属性字段请参考 AMapInputTipsSearchRequest 类。
 */
- (void)AMapInputTipsSearch:(AMapInputTipsSearchRequest *)request;

/*!
 @brief  地址编码 查询接口函数。
 @param request 查询选项。具体属性字段请参考 AMapGeocodeSearchRequest 类。
 */
- (void)AMapGeocodeSearch:(AMapGeocodeSearchRequest *)request;

/*!
 @brief  逆地址编码 查询接口函数。
 @param request 查询选项。具体属性字段请参考 AMapReGeocodeSearchRequest 类。
 */
- (void)AMapReGoecodeSearch:(AMapReGeocodeSearchRequest *)request;

/*!
 @brief  公交线路 查询接口函数。
 @param request 查询选项。具体属性字段请参考 AMapBusLineSearchRequest 类。
 */
- (void)AMapBusLineSearch:(AMapBusLineSearchRequest *)request;

/*!
 @brief  公交车站 查询接口函数。
 @param request 查询选项。具体属性字段请参考 AMapBusStopSearchRequest 类。
 */
- (void)AMapBusStopSearch:(AMapBusStopSearchRequest *)request;

@end


#pragma mark - AMapSearchDelegate

/*!
 @brief AMapSearchDelegate协议类，从NSObject类继承。
 */
@protocol AMapSearchDelegate<NSObject>

@optional

/*!
 @brief 通知查询成功或失败的回调函数
 @param searchRequest 发起的查询
 @param errInfo 错误信息
 ￼
 OK                         正常
 INVALID_USER_SCODE         安全码验证错误
 INVALID_USER_KEY           用户 key 非法或过期
 SERVICE_NOT_EXIST          请求服务不存在
 SERVICE_RESPONSE_ERROR     请求服务响应错误
 INSUFFICIENT_PRIVILEGES    无权限访问此服务
 OVER_QUOTA                 请求超出配额
 INVALID_PARAMS             请求参数非法
 ￼UNKNOWN_ERROR              ￼未知错误
 */
- (void)search:(id)searchRequest error:(NSString*)errInfo;

/*!
 @brief POI 查询回调函数
 @param request 发起查询的查询选项(具体字段参考AMapPlaceSearchRequest类中的定义)
 @param response 查询结果(具体字段参考AMapPlaceSearchResponse类中的定义)
 */
- (void)onPlaceSearchDone:(AMapPlaceSearchRequest *)request response:(AMapPlaceSearchResponse *)response;

/*!
 @brief 导航 查询回调函数
 @param request 发起查询的查询选项(具体字段参考AMapNavigationSearchRequest类中的定义)
 @param response 查询结果(具体字段参考AMapNavigationSearchResponse类中的定义)
 */
- (void)onNavigationSearchDone:(AMapNavigationSearchRequest *)request response:(AMapNavigationSearchResponse *)response;

/*!
 @brief 输入提示 查询回调函数
 @param request 发起查询的查询选项(具体字段参考AMapInputTipsSearchRequest类中的定义)
 @param response 查询结果(具体字段参考AMapInputTipsSearchResponse类中的定义)
 */
- (void)onInputTipsSearchDone:(AMapInputTipsSearchRequest *)request response:(AMapInputTipsSearchResponse *)response;

/*!
 @brief 地理编码 查询回调函数
 @param request 发起查询的查询选项(具体字段参考AMapGeocodeSearchRequest类中的定义)
 @param response 查询结果(具体字段参考AMapGeocodeSearchResponse类中的定义)
 */
- (void)onGeocodeSearchDone:(AMapGeocodeSearchRequest *)request response:(AMapGeocodeSearchResponse *)response;

/*!
 @brief 逆地理编码 查询回调函数
 @param request 发起查询的查询选项(具体字段参考AMapReGeocodeSearchRequest类中的定义)
 @param response 查询结果(具体字段参考AMapReGeocodeSearchResponse类中的定义)
 */
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response;

/*!
 @brief 公交线路 查询回调函数
 @param request 发起查询的查询选项(具体字段参考AMapBusLineSearchRequest类中的定义)
 @param response 查询结果(具体字段参考AMapBusLineSearchResponse类中的定义)
 */
- (void)onBusLineSearchDone:(AMapBusLineSearchRequest *)request response:(AMapBusLineSearchResponse *)response;

/*!
 @brief 公交站 查询回调函数
 @param request 发起查询的查询选项(具体字段参考AMapBusStopSearchRequest类中的定义)
 @param response 查询结果(具体字段参考AMapBusStopSearchResponse类中的定义)
 */
- (void)onBusStopSearchDone:(AMapBusStopSearchRequest *)request response:(AMapBusStopSearchResponse *)response;

@end


