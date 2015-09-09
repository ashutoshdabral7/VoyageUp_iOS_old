//
//  VoyageUpAPIManager.m
//  VoyageUp
//
//  Created by Deepak on 16/05/15.
//  Copyright (c) 2015 Deepak. All rights reserved.
//

#import "VoyageUpAPIManager.h"
#import "HttpUtility.h"
#import "NSDictionary+NullValidation.h"
@implementation VoyageUpAPIManager
@synthesize delegate;

+ (VoyageUpAPIManager *)sharedManager
{
    static VoyageUpAPIManager *_sharedRestAPIManager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedRestAPIManager = [[self alloc] initWithBaseURL:[NSURL URLWithString:BASE_URL]];
    });
    
    return _sharedRestAPIManager;
}

- (instancetype)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    
    if (self)
    {
        self.responseSerializer = [AFJSONResponseSerializer serializer];
        self.requestSerializer = [AFHTTPRequestSerializer serializer];
        [self addDefaultHeaders];
    }
    
    return self;
}

- (void)addDefaultHeaders
{
        AppDelegate* appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    //    ProfileDetails *profile=[ProfileDetails getProfileDetails];
    //    [self.requestSerializer setValue:@"ios" forHTTPHeaderField:@"Device-type"];
    //    NSString *token = (profile.token.length > 0)?profile.token:@"";
    //    NSString *deviceid = (appdelegate.deviceid.length > 0)?appdelegate.deviceid:@"123";
    //
    //    [self.requestSerializer setValue:token forHTTPHeaderField:@"Token"];
    [self.requestSerializer setValue:appdelegate.api_key forHTTPHeaderField:@"api-key"];
}
- (void) POST:(NSString *)URLString
   parameters:(id)parameters
      success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
   showLoader:(BOOL)showLoader
     withText:(NSString *)text{
    NSLog(@"URLString:%@",URLString);
    if([helper isNetworkAvailable])
    {
        
        if (showLoader) {
            if (text) {
                [SVProgressHUD showWithStatus:text maskType:SVProgressHUDMaskTypeClear];
            }
            else{
                [SVProgressHUD show];
            }
        }
        [self addDefaultHeaders];
        [self POST:URLString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             success(operation,responseObject);
             [SVProgressHUD dismiss];
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             failure(operation, error);
             [SVProgressHUD dismiss];
         }];
    }else{
        
        [[[UIAlertView alloc] initWithTitle:nil message:NO_NETWORK_AVAILABLE delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        
        
    }
    
}

- (void)GET:(NSString *)URLString
 parameters:(id)parameters
    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
 showLoader:(BOOL)showLoader
   withText:(NSString *)text
{
    NSLog(@"URLString:%@",URLString);
    
    if (showLoader) {
        if (text) {
            [SVProgressHUD showWithStatus:text maskType:SVProgressHUDMaskTypeClear];
        }
        else{
            [SVProgressHUD show];
        }
    }
    [self addDefaultHeaders];
    [self GET:URLString
   parameters:parameters
      success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         success(operation,responseObject);
         [SVProgressHUD dismiss];
     }
      failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         failure(operation, error);
         [SVProgressHUD dismiss];
         
     }
     
     ];
    
}


#pragma mark post methods

-(void)Signup:(NSDictionary*)postobject  WithCompletionblock:(VoyageUpCompletionBlock)completionHandler
{
    
    
    [self POST:[HttpUtility getUrlWithPath:API_SIGHNUP]
    parameters:@{
                 POST_FIRSTNAME:[postobject objectForKey:POST_FIRSTNAME],
                 POST_LASTNAME:[postobject objectForKey:POST_LASTNAME],
                 POST_EMAIL:[postobject objectForKey:POST_EMAIL],
                 POST_COUNTRY:[postobject objectForKey:POST_COUNTRY],
                 POST_DOB:[postobject objectForKey:POST_DOB],
                 POST_PASSWORD:[postobject objectForKey:POST_PASSWORD],
                 POST_GENDER:[postobject objectForKey:POST_GENDER],
                 POST_LOGINTYPE:[postobject objectForKey:POST_LOGINTYPE]
                 }
       success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         if (completionHandler != nil)
             completionHandler([(NSDictionary *)responseObject dictionaryByReplacingNullsWithStrings],nil);
         
         else
         {
             if ( delegate != nil && [delegate respondsToSelector:@selector(VoyageUpRestAPIManagerdelegate:WithResponseDictionary:)] )
                 [delegate VoyageUpRestAPIManagerdelegate:self WithResponseDictionary:[(NSDictionary *)responseObject dictionaryByReplacingNullsWithStrings]];
             
         }
     }
       failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         //TODO: Show or handle error
         if (completionHandler != nil)
             completionHandler(nil,error);
         
          [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Some thing went to wrong, please try again later" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
     }
    showLoader:YES withText:@"Loading"
     ];
}
-(void)Login:(NSDictionary*)postobject  WithCompletionblock:(VoyageUpCompletionBlock)completionHandler
{
    
    [self POST:[HttpUtility getUrlWithPath:API_LOGIN]
    parameters:@{
                 POST_EMAIL:[postobject objectForKey:POST_EMAIL],
                 POST_PASSWORD:[postobject objectForKey:POST_PASSWORD]
                 //POST_FACEBOOK:[postobject objectForKey:POST_FACEBOOK]
                 }
       success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         if (completionHandler != nil)
             completionHandler([(NSDictionary *)responseObject dictionaryByReplacingNullsWithStrings],nil);
         
         else
         {
             if ( delegate != nil && [delegate respondsToSelector:@selector(VoyageUpRestAPIManagerdelegate:WithResponseDictionary:)] )
                 [delegate VoyageUpRestAPIManagerdelegate:self WithResponseDictionary:[(NSDictionary *)responseObject dictionaryByReplacingNullsWithStrings]];
             
         }
     }
       failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         //TODO: Show or handle error
         if (completionHandler != nil)
             completionHandler(nil,error);
         
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Some thing went to wrong, please try again later" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
         
         
     }
    showLoader:YES withText:@"Logging in.."
     ];
}
-(void)ProfileUpdate:(NSDictionary*)postobject AndPhoto:(UIImage*)photo WithCompletionblock:(VoyageUpCompletionBlock)completionHandler
{
    ProfileDetails *profile=[ProfileDetails getProfileDetails];
    profile.token = @"";
    [self addDefaultHeaders];
    [self POST:[HttpUtility getUrlWithPath:API_PROFILE_UPDATE]
    parameters:@{
                 POST_FIRSTNAME:[postobject objectForKey:POST_FIRSTNAME],
                 POST_LASTNAME:[postobject objectForKey:POST_LASTNAME],
                 POST_COUNTRY:[postobject objectForKey:POST_COUNTRY],
                 POST_DOB:[postobject objectForKey:POST_DOB],
                 POST_GENDER:[postobject objectForKey:POST_GENDER],
                 }
     
constructingBodyWithBlock:^(id <AFMultipartFormData>formData)
     {
         NSData *imageData = UIImageJPEGRepresentation(photo, 0.5);
         // UIImage *img = [UIImage imageWithData:imageData];
         
         if (imageData != nil)
             [formData appendPartWithFileData:imageData name:@"uploaded_file" fileName:@"photo.jpg" mimeType:@"image/jpeg"];//TODO: Fill photo name
     }
       success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         if (completionHandler != nil)
             completionHandler([(NSDictionary *)responseObject dictionaryByReplacingNullsWithStrings],nil);
         
         else
         {
             if ( delegate != nil && [delegate respondsToSelector:@selector(VoyageUpRestAPIManagerdelegate:WithResponseDictionary:)] )
                 [delegate VoyageUpRestAPIManagerdelegate:self WithResponseDictionary:[(NSDictionary *)responseObject dictionaryByReplacingNullsWithStrings]];
             
         }
     }
       failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         //TODO: Show or handle error
         if (completionHandler != nil)
             completionHandler(nil,error);
         
         [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Some thing went to wrong, please try again later" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
         
     }
     
     ];
}


-(void)UpdateLocation:(NSDictionary*)postobject  WithCompletionblock:(VoyageUpCompletionBlock)completionHandler
{
    
    [self POST:[HttpUtility getUrlWithPath:API_POST_LOCATION]
    parameters:@{
                 POST_LATITUDE:[postobject objectForKey:POST_LATITUDE],
                 POST_LOGITUDE:[postobject objectForKey:POST_LOGITUDE],
                 POST_GEOFENCE_AREA:[postobject objectForKey:POST_GEOFENCE_AREA],
                 POST_DEVISE_ID:[postobject objectForKey:POST_DEVISE_ID],
                  POST_NETWORK_ID:[postobject objectForKey:POST_NETWORK_ID]
                 }
       success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         if (completionHandler != nil)
             completionHandler([(NSDictionary *)responseObject dictionaryByReplacingNullsWithStrings],nil);
         
         else
         {
             if ( delegate != nil && [delegate respondsToSelector:@selector(VoyageUpRestAPIManagerdelegate:WithResponseDictionary:)] )
                 [delegate VoyageUpRestAPIManagerdelegate:self WithResponseDictionary:[(NSDictionary *)responseObject dictionaryByReplacingNullsWithStrings]];
             
         }
     }
       failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         //TODO: Show or handle error
         if (completionHandler != nil)
             completionHandler(nil,error);
         
//       [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Some thing went to wrong, please try again later" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
//         
     }
    showLoader:NO withText:@"Loading"
     ];
}
-(void)getUsers:(NSDictionary*)postobject  WithCompletionblock:(VoyageUpCompletionBlock)completionHandler
{
    
    [self POST:[HttpUtility getUrlWithPath:API_GET_USERS]
    parameters:@{
                 POST_LATITUDE:[postobject objectForKey:POST_LATITUDE],
                 POST_LOGITUDE:[postobject objectForKey:POST_LOGITUDE],
                 POST_GEOFENCE_AREA:[postobject objectForKey:POST_GEOFENCE_AREA]
                 }
       success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         if (completionHandler != nil)
             completionHandler([(NSDictionary *)responseObject dictionaryByReplacingNullsWithStrings],nil);
         
         else
         {
             if ( delegate != nil && [delegate respondsToSelector:@selector(VoyageUpRestAPIManagerdelegate:WithResponseDictionary:)] )
                 [delegate VoyageUpRestAPIManagerdelegate:self WithResponseDictionary:[(NSDictionary *)responseObject dictionaryByReplacingNullsWithStrings]];
             
         }
     }
       failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         //TODO: Show or handle error
         if (completionHandler != nil)
             completionHandler(nil,error);
         
       [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Some thing went to wrong, please try again later" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
         
     }
    showLoader:NO withText:@"Loading"
     ];
}
-(void)getSingleUserDetails:(NSDictionary*)postobject  WithCompletionblock:(VoyageUpCompletionBlock)completionHandler
{
    
    [self POST:[HttpUtility getUrlWithPath:API_GET_SINGLE_USER]
    parameters:@{
                 USER_ID:[postobject objectForKey:USER_ID]
                 }
       success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         if (completionHandler != nil)
             completionHandler([(NSDictionary *)responseObject dictionaryByReplacingNullsWithStrings],nil);
         
         else
         {
             if ( delegate != nil && [delegate respondsToSelector:@selector(VoyageUpRestAPIManagerdelegate:WithResponseDictionary:)] )
                 [delegate VoyageUpRestAPIManagerdelegate:self WithResponseDictionary:[(NSDictionary *)responseObject dictionaryByReplacingNullsWithStrings]];
             
         }
     }
       failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         //TODO: Show or handle error
         if (completionHandler != nil)
             completionHandler(nil,error);
         
         [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Some thing went to wrong, please try again later" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
     }
    showLoader:YES withText:@"Loading"
     ];
}

#pragma mark get methods

-(void)GetConnectionList:(VoyageUpCompletionBlock)completionHandler
{
    
    
    [self GET:[HttpUtility getUrlWithPath:API_GET_CONNECTIONTYPES]
   parameters:nil
      success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         if (completionHandler != nil)
             completionHandler([(NSDictionary *)responseObject dictionaryByReplacingNullsWithStrings],nil);
         
         else
         {
             if ( delegate != nil && [delegate respondsToSelector:@selector(VoyageUpRestAPIManagerdelegate:WithResponseDictionary:)] )
                 [delegate VoyageUpRestAPIManagerdelegate:self WithResponseDictionary:[(NSDictionary *)responseObject dictionaryByReplacingNullsWithStrings]];
             
         }
     }
      failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Some thing went to wrong, please try again later" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
     }showLoader:NO withText:@"Loading.."
     ];
    
}
-(void)GetConnection_singleUser:(NSString*)userid :(VoyageUpCompletionBlock)completionHandler
{
    NSString *api=[API_GET_CONNECTIONTYPE_USER_ID stringByReplacingOccurrencesOfString:@"userid" withString:userid];
    
    [self GET:[HttpUtility getUrlWithPath:api]
   parameters:nil
      success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         if (completionHandler != nil)
             completionHandler([(NSDictionary *)responseObject dictionaryByReplacingNullsWithStrings],nil);
         
         else
         {
             if ( delegate != nil && [delegate respondsToSelector:@selector(VoyageUpRestAPIManagerdelegate:WithResponseDictionary:)] )
                 [delegate VoyageUpRestAPIManagerdelegate:self WithResponseDictionary:[(NSDictionary *)responseObject dictionaryByReplacingNullsWithStrings]];
             
         }
     }
      failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Some thing went to wrong, please try again later" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
     }showLoader:NO withText:@"Loading.."
     ];
    
}
-(void)GetLatestMessages:(VoyageUpCompletionBlock)completionHandler
{
    
    
    [self GET:[HttpUtility getUrlWithPath:API_GET_LATEST_MSGS]
   parameters:nil
      success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         if (completionHandler != nil)
             completionHandler([(NSDictionary *)responseObject dictionaryByReplacingNullsWithStrings],nil);
         
         else
         {
             if ( delegate != nil && [delegate respondsToSelector:@selector(VoyageUpRestAPIManagerdelegate:WithResponseDictionary:)] )
                 [delegate VoyageUpRestAPIManagerdelegate:self WithResponseDictionary:[(NSDictionary *)responseObject dictionaryByReplacingNullsWithStrings]];
             
         }
     }
      failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Some thing went to wrong, please try again later" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
     }showLoader:NO withText:@"Loading.."
     ];
    
}
@end
