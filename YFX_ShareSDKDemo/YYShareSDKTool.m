//  
//  YYShareSDKTool.m
//  YYShareSDKTool
//
//  Created by fangxue on 16/7/31.
//  Copyright © 2016年 fangxue. All rights reserved.

#import "YYShareSDKTool.h"
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>

/*****ShareSDK********/
#define K_ShareSDK_AppKey      @""
#define K_ShareSDK_AppSecret   @""
//QQAppId16进制 41e2c9d5   QQ41E2C9D5
//新浪
#define K_Sina_AppKey    @""
#define K_Sina_AppSecret @""
//QQ
#define K_QQ_AppId       @""
#define K_QQ_AppKey      @""
//微信
#define K_WX_AppID       @""
#define K_WX_AppSecret   @""
#define K_Share_Url      @""

@implementation YYShareSDKTool

#pragma mark - ShareSDK 注册

+(void)registerShare
{   //registerApp 初始化SDK并且初始化第三方平台
    [ShareSDK registerApp:K_ShareSDK_AppKey
          activePlatforms:@[
                            @(SSDKPlatformTypeSinaWeibo),
                            @(SSDKPlatformTypeWechat),
                            @(SSDKPlatformTypeQQ),
                            ]
                 onImport:^(SSDKPlatformType platformType) {
                     switch (platformType)
                     {
                         case SSDKPlatformTypeWechat:{
                             [ShareSDKConnector connectWeChat:[WXApi class]];
                             break;
                         }
                         case SSDKPlatformTypeSinaWeibo:
                             [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                             break;
                         case SSDKPlatformTypeQQ:
                             [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                             break;
                         default:
                             break;
                     }
                     
                 } onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
                     switch (platformType)
                     {
                         case SSDKPlatformTypeWechat:
                             
                             [appInfo SSDKSetupWeChatByAppId:K_WX_AppID
                                                   appSecret:K_WX_AppSecret];
                             
                             break;
                         case SSDKPlatformTypeSinaWeibo:
                
                             [appInfo SSDKSetupSinaWeiboByAppKey:K_Sina_AppKey
                                                       appSecret:K_Sina_AppSecret
                                                     redirectUri:K_Share_Url
                                                        authType:SSDKAuthTypeBoth];
                             break;
                         case SSDKPlatformTypeQQ:
                             [appInfo SSDKSetupQQByAppId:K_QQ_AppId
                                                  appKey:K_QQ_AppKey
                                                authType:SSDKAuthTypeBoth];
                             break;
                         default:
                             break;
                     }
                 }
     ];
}
#pragma mark- 分享
+(void)shareContentWithShareContentType:(SSDKContentType)shareContentType
                           contentTitle:(NSString *)contentTitle
                     contentDescription:(NSString *)contentDescription
                           contentImage:(id)contentImage
                             contentURL:(NSString *)contentURL
                             showInView:(UIView *)showInView
                                success:(void (^)())success
                                failure:(void (^)(NSString *failureInfo))failure
                    OtherResponseStatus:(void (^)(SSDKResponseState state))otherResponseStatus{
    //1. 创建分享参数
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    
    [shareParams SSDKEnableUseClientShare];
    
    [shareParams SSDKSetupShareParamsByText:contentDescription
                                     images:contentImage
                                        url:[NSURL URLWithString:contentURL]
                                      title:contentTitle
                                       type:shareContentType];
    
    [SSUIShareActionSheetStyle setShareActionSheetStyle:ShareActionSheetStyleSystem];
    //2. 分享,显示分享view
    SSUIShareActionSheetController *sheet =[ShareSDK showShareActionSheet:showInView
                             items:nil
                       shareParams:shareParams
               onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                   
                   switch (state) {
                       
                       case SSDKResponseStateSuccess:
                       {
                           
                           success();
                           break;
                           
                       }
                       case SSDKResponseStateFail:
                       {
                           if (platformType == SSDKPlatformTypeSMS && [error code] == 201)
                           {
                               failure(@"失败原因可能是:1、短信应用没有设置帐号;2、设备不支持短信应用;3、短信应用在iOS 7以上才能发送带附件的短                                                     信。");
                               break;
                               
                           }
                           else if(platformType == SSDKPlatformTypeMail && [error code] == 201)
                           {
                               
                               failure(@"失败原因可能是:1、邮件应用没有设置帐号;2、设备不支持邮件应用。");
                               break;
                               
                           }
                           else
                           {
                               failure([NSString stringWithFormat:@"%@",error]);
                               break;
                               
                           }
                           break;
                       }
                       case SSDKResponseStateCancel:
                       {
                           otherResponseStatus(SSDKResponseStateCancel);
                           
                           break;
                       }
                       default:
                           break;
                   }
                   if (state != SSDKResponseStateBegin)
                   {
                       failure([NSString stringWithFormat:@"%@",error]);
                       
                   }
               }];
    
    [sheet.directSharePlatforms addObject:@(SSDKPlatformTypeSinaWeibo)];
    [sheet.directSharePlatforms addObject:@(SSDKPlatformTypeMail)];
    [sheet.directSharePlatforms addObject:@(SSDKPlatformTypeSMS)];
}
#pragma mark QQ
+(void)ShareQQParamsByText:(NSString *)text
                          title:(NSString *)title
                            url:(NSURL *)url
                  audioFlashURL:(NSURL *)audioFlashURL
                  videoFlashURL:(NSURL *)videoFlashURL
                     thumbImage:(id)thumbImage
                         images:(id)images
                           type:(SSDKContentType)type
             forPlatformSubType:(SSDKPlatformType)platformSubType
                showInView:(UIView *)showInView{
    //1. 创建分享参数
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    
    [shareParams SSDKEnableUseClientShare];
    
    NSArray *items = @[@(SSDKPlatformSubTypeQZone)];
    
    [shareParams SSDKSetupQQParamsByText:text title:title url:url audioFlashURL:audioFlashURL videoFlashURL:audioFlashURL thumbImage:thumbImage images:images type:type forPlatformSubType:platformSubType];
    //2. 分享->显示分享view
    [ShareSDK showShareActionSheet:showInView                                                                    items:items
                                                               shareParams:shareParams
                                                       onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                                                           
                                                           switch (state) {
                                                                   
                                                               case SSDKResponseStateSuccess:
                                                               {
                                                                   //分享成功
                                                                  
                                                                   NSLog(@"%@",userData);
                                                                   break;
                                                                   
                                                               }
                                                               case SSDKResponseStateFail:
                                                               {
                                                                   
                                                                   NSLog(@"%@",error);
                                                                   
                                                                   break;
                                                               }
                                                               case SSDKResponseStateCancel:
                                                               {
                                                                   
                                                                   break;
                                                               }
                                                               default:
                                                                   break;
                                                           }
                                                           
                                                       }];
    
}
#pragma mark 分享文件代码(仅支持微信好友)
+ (void)shareVideoContentParamsByText:(NSString *)text
                                title:(NSString *)title
                                  url:(NSURL *)url
                           thumbImage:(id)thumbImage
                                image:(id)image
                         musicFileURL:(NSURL *)musicFileURL
                              extInfo:(NSString *)extInfo
                             fileData:(id)fileData
                         emoticonData:(id)emoticonData
                  sourceFileExtension:(NSString *)fileExtension
                       sourceFileData:(id)sourceFileData
                                 type:(SSDKContentType)type
                   forPlatformSubType:(SSDKPlatformType)platformSubType
                           showInView:(UIView *)showInView
                              success:(void (^)())success
                              failure:(void (^)(NSString *failureInfo))failure
                  OtherResponseStatus:(void (^)(SSDKResponseState state))otherResponseStatus{
    //1. 创建分享参数
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    
    [shareParams SSDKEnableUseClientShare];
    
    [shareParams SSDKSetupWeChatParamsByText:text title:title url:url thumbImage:thumbImage image:image musicFileURL:musicFileURL extInfo:extInfo fileData:fileData emoticonData:emoticonData sourceFileExtension:fileExtension sourceFileData:sourceFileData type:type forPlatformSubType:platformSubType];
   
    NSArray *items = @[@(SSDKPlatformSubTypeWechatSession)];
    //2. 分享->显示分享view
    SSUIShareActionSheetController *sheet = [ShareSDK showShareActionSheet:showInView                                                                    items:items
        shareParams:shareParams
        onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
            
            switch (state) {
                    
                case SSDKResponseStateSuccess:
                {
                    //分享成功
                    success();
                    
                    break;
                    
                }
                case SSDKResponseStateFail:
                {
                    
                    if (platformType == SSDKPlatformTypeSMS && [error code] == 201)
                    {
                        failure(@"失败原因可能是:1、短信应用没有设置帐号;2、设备不支持短信应用;3、短信应用在iOS 7以上才能发送带附件的短                                                     信。");
                        break;
                        
                    }
                    else if(platformType == SSDKPlatformTypeMail && [error code] == 201)
                    {
                        
                        failure(@"失败原因可能是:1、邮件应用没有设置帐号;2、设备不支持邮件应用。");
                        break;
                    }
                    else
                    {
                        failure([NSString stringWithFormat:@"%@",error]);
                        break;
                    }
                    break;
                }
                case SSDKResponseStateCancel:
                {
                    otherResponseStatus(SSDKResponseStateCancel);
                    break;
                }
                default:
                    break;
            }
           if (state != SSDKResponseStateBegin){
                
              failure([NSString stringWithFormat:@"%@",error]);
           }
    }];
    
    [sheet.directSharePlatforms addObject:@(SSDKPlatformTypeSinaWeibo)];
    [sheet.directSharePlatforms addObject:@(SSDKPlatformTypeMail)];
    [sheet.directSharePlatforms addObject:@(SSDKPlatformTypeSMS)];
}
#pragma mark ====第三方登录====
+(void)thirdLoginWithType:(SSDKPlatformType)type result:(ThirdLoginResult)loginResult{
    
    [ShareSDK cancelAuthorize:type];
    
    [ShareSDK getUserInfo:type onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
        
        switch (state) {
            
            case SSDKResponseStateSuccess:{
                
               
                        loginResult(YES,nil);
                        
                
                    }
                }];
                
                break;
            }
            case SSDKResponseStateFail:{
                
                loginResult(NO,error.localizedDescription);
                
                break;
            }
            default:
                break;
        }
    }];
}

@end
