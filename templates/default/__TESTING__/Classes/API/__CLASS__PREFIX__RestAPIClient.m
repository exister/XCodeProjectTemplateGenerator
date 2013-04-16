#import <objc/runtime.h>
#import "__CLASS__PREFIX__RestAPIClient.h"
#import "AFNetworking.h"
#import "__CLASS__PREFIX__RestAPI.h"
#import "__CLASS__PREFIX__RegistrationHelper.h"


/**
* Maintains list of delegates, so each of them could cancel all requests associated with it.
*/


static char kCDRestAPIOperationDelegateObjectKey;


@implementation __CLASS__PREFIX__RestAPIClient
{

}

- (id)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    if (self) {
        NSString *applicationName = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleExecutableKey] ?: [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleIdentifierKey];
        NSString *applicationVersion = (__bridge id)CFBundleGetValueForInfoDictionaryKey(CFBundleGetMainBundle(), kCFBundleVersionKey) ?: [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
        NSString *screenType = [NSString stringWithFormat:@"%f", ([[UIScreen mainScreen] respondsToSelector:@selector(scale)] ? [[UIScreen mainScreen] scale] : 1.0f)];

        [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
        [self setDefaultHeader:@"Accept" value:@"application/json"];
        [self setDefaultHeader:@"DEVICE_ID" value:[__CLASS__PREFIX__RegistrationHelper pushToken]];
        [self setDefaultHeader:@"PUSH_ID" value:[__CLASS__PREFIX__RegistrationHelper pushToken]];
        [self setDefaultHeader:@"DEVICE_OS" value:@"iOS"];
        [self setDefaultHeader:@"DEVICE_OS_VERSION" value:[[UIDevice currentDevice] systemVersion]];
        [self setDefaultHeader:@"DEVICE_MODEL" value:[[UIDevice currentDevice] model]];
        [self setDefaultHeader:@"DEVICE_SCREEN" value:screenType];
        [self setDefaultHeader:@"APPLICATION" value:applicationName];
        [self setDefaultHeader:@"APPLICATION_VERSION" value:applicationVersion];
        if ([__CLASS__PREFIX__RegistrationHelper authToken]) {
            [self setDefaultHeader:@"Authorization" value:[NSString stringWithFormat:@"Token %@", [__CLASS__PREFIX__RegistrationHelper authToken]]];
        }

        self.parameterEncoding = AFJSONParameterEncoding;
    }

    return self;
}

- (NSMutableURLRequest *)requestWithMethod:(NSString *)method path:(NSString *)path parameters:(NSDictionary *)parameters {
    [self setDefaultHeader:@"DEVICE_ID" value:[__CLASS__PREFIX__RegistrationHelper pushToken]];
    [self setDefaultHeader:@"PUSH_ID" value:[__CLASS__PREFIX__RegistrationHelper pushToken]];
    return [super requestWithMethod:method path:path parameters:parameters];
}


/** Makes request, maps list of operations to given delegate;
*
* @param path Relative url
* @param delegate Delegate
* @param parameters GET-params
* @param success Completion block
* @param failure Failure block
*/
- (void)getPath:(NSString *)path
        delegate:(id)delegate
        parameters:(NSDictionary *)parameters
        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSURLRequest *request = [self requestWithMethod:@"GET" path:path parameters:parameters];
    AFHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:request success:success failure:failure];

    objc_setAssociatedObject(operation, &kCDRestAPIOperationDelegateObjectKey, delegate, OBJC_ASSOCIATION_ASSIGN);

    [self enqueueHTTPRequestOperation:operation];
}

- (void)postPath:(NSString *)path
        delegate:(id)delegate
        parameters:(NSDictionary *)parameters
        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSURLRequest *request = [self requestWithMethod:@"POST" path:path parameters:parameters];
    AFHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:request success:success failure:failure];

    objc_setAssociatedObject(operation, &kCDRestAPIOperationDelegateObjectKey, delegate, OBJC_ASSOCIATION_ASSIGN);

    [self enqueueHTTPRequestOperation:operation];
}

- (void)putPath:(NSString *)path
        delegate:(id)delegate
        parameters:(NSDictionary *)parameters
        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSURLRequest *request = [self requestWithMethod:@"PUT" path:path parameters:parameters];
    AFHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:request success:success failure:failure];

    objc_setAssociatedObject(operation, &kCDRestAPIOperationDelegateObjectKey, delegate, OBJC_ASSOCIATION_ASSIGN);

    [self enqueueHTTPRequestOperation:operation];
}

- (void)deletePath:(NSString *)path
        delegate:(id)delegate
        parameters:(NSDictionary *)parameters
        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSURLRequest *request = [self requestWithMethod:@"DELETE" path:path parameters:parameters];
    AFHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:request success:success failure:failure];

    objc_setAssociatedObject(operation, &kCDRestAPIOperationDelegateObjectKey, delegate, OBJC_ASSOCIATION_ASSIGN);

    [self enqueueHTTPRequestOperation:operation];
}

- (void)patchPath:(NSString *)path
        delegate:(id)delegate
        parameters:(NSDictionary *)parameters
        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSURLRequest *request = [self requestWithMethod:@"PATCH" path:path parameters:parameters];
    AFHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:request success:success failure:failure];

    objc_setAssociatedObject(operation, &kCDRestAPIOperationDelegateObjectKey, delegate, OBJC_ASSOCIATION_ASSIGN);

    [self enqueueHTTPRequestOperation:operation];
}

/** Cancels all operations associated with delegate
*
* @param delegate Delegate
*/
- (void)cancelAllOperationsForDelegate:(id)delegate
{
    for (NSOperation *operation in [self.operationQueue operations]) {
        if (![operation isKindOfClass:[AFHTTPRequestOperation class]]) {
            continue;
        }

        BOOL match = (id)objc_getAssociatedObject(operation, &kCDRestAPIOperationDelegateObjectKey) == delegate;

        if (match) {
            [operation cancel];
        }
    }
}

@end