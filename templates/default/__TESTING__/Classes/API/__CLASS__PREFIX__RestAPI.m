#import "__CLASS__PREFIX__RestAPI.h"
#import "__CLASS__PREFIX__RestAPIClient.h"

#define kCDSentMessageToSupportVerb @"sent comment to support"

@interface __CLASS__PREFIX__RestAPI ()

@property (nonatomic, strong) __CLASS__PREFIX__RestAPIClient *client;

- (void)makeGETRequest:(NSString *)path params:(NSMutableDictionary *)params success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure owner:(id)owner;

- (void)makePOSTRequest:(NSString *)path params:(NSMutableDictionary *)params success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure owner:(id)owner;

- (void)makePUTRequest:(NSString *)path params:(NSMutableDictionary *)params success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure owner:(id)owner;

- (void)makeDELETERequest:(NSString *)path params:(NSMutableDictionary *)params success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure owner:(id)owner;

- (void)makePATCHRequest:(NSString *)path params:(NSMutableDictionary *)params success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure owner:(id)owner;


@end


@implementation __CLASS__PREFIX__RestAPI
@synthesize client = _client;


/**
* Singleton
*
* @return id
*/
+ (id)sharedInstance
{
    static __CLASS__PREFIX__RestAPI *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (id)init
{
    if (self = [super init]) {
        _client = [[__CLASS__PREFIX__RestAPIClient alloc] initWithBaseURL:[NSURL URLWithString:k__CLASS__PREFIX__RestApiBaseUrl]];
        [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
        [_client setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            DDLogInfo(@"Reachability status changed: %d", status);
            NSDictionary *data;
            switch (status) {
                case AFNetworkReachabilityStatusNotReachable: {
                    data = @{@"status": [NSNumber numberWithInt:__CLASS__PREFIX__NetworkUnreachableStatus]};
                }
                    break;
                case AFNetworkReachabilityStatusReachableViaWWAN: {
                    data = @{@"status": [NSNumber numberWithInt:__CLASS__PREFIX__NetworkReachableViaWWANStatus]};
                }
                    break;
                case AFNetworkReachabilityStatusReachableViaWiFi: {
                    data = @{@"status": [NSNumber numberWithInt:__CLASS__PREFIX__NetworkReachableViaWiFiStatus]};
                }
                    break;
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:k__CLASS__PREFIX__ReachabilityChanged object:nil userInfo:data];
        }];
    }
    return self;
}

/**
* Return network status
*/
- (AFNetworkReachabilityStatus)reachabilityStatus
{
    return self.client.networkReachabilityStatus;
}

/**
* Makes actual request
*
* Adds required parameters to each request.
*
* @param params GET-parameters
* @param delegate Delegate than will be notified upon request completion
*/
- (void)makeGETRequest:(NSString *)path
                params:(NSMutableDictionary *)params
                success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
                  owner:(id)owner
{
    [self.client getPath:path delegate:owner parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        DDLogInfo(@"__CLASS__PREFIX__RestAPI finished");
        success(operation, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        DDLogError(@"__CLASS__PREFIX__RestAPI failed");
        failure(operation, error);
    }];
}

- (void)makePOSTRequest:(NSString *)path
                 params:(NSMutableDictionary *)params
                success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
                  owner:(id)owner
{
    DDLogInfo(@"POST %@: %@", path, params);
    [self.client postPath:path delegate:owner parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        DDLogInfo(@"__CLASS__PREFIX__RestAPI finished");
        success(operation, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        DDLogError(@"__CLASS__PREFIX__RestAPI failed");
        failure(operation, error);
    }];
}

- (void)makePUTRequest:(NSString *)path
                params:(NSMutableDictionary *)params
               success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
                 owner:(id)owner
{
    DDLogInfo(@"PUT %@: %@", path, params);
    [self.client putPath:path delegate:owner parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        DDLogInfo(@"__CLASS__PREFIX__RestAPI finished");
        success(operation, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        DDLogError(@"__CLASS__PREFIX__RestAPI failed");
        failure(operation, error);
    }];
}

- (void)makeDELETERequest:(NSString *)path
                   params:(NSMutableDictionary *)params
                  success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                  failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
                    owner:(id)owner
{
    [self.client deletePath:path delegate:owner parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        DDLogInfo(@"__CLASS__PREFIX__RestAPI finished");
        success(operation, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        DDLogError(@"__CLASS__PREFIX__RestAPI failed");
        failure(operation, error);
    }];
}

- (void)makePATCHRequest:(NSString *)path
                  params:(NSMutableDictionary *)params
                 success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                 failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
                   owner:(id)owner
{
    [self.client patchPath:path delegate:owner parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        DDLogInfo(@"__CLASS__PREFIX__RestAPI finished");
        success(operation, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        DDLogError(@"__CLASS__PREFIX__RestAPI failed");
        failure(operation, error);
    }];
}

/**
* Cancels all requests associated with given delegate
*/
- (void)cancelAllRequestsForDelegate:(id)delegate
{
    [self.client cancelAllOperationsForDelegate:delegate];
}

@end
