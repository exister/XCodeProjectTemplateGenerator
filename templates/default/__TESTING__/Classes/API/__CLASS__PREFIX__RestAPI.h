#import <Foundation/Foundation.h>
#import "AFHTTPClient.h"
#import "AFHTTPRequestOperation.h"

typedef void (^__CLASS__PREFIX__RestAPISuccessCallback)(AFHTTPRequestOperation *operation, id responseObject);
typedef void (^__CLASS__PREFIX__RestAPIFailureCallback)(AFHTTPRequestOperation *operation, NSError *error);

@protocol __CLASS__PREFIX__RestApiDelegate;

@interface __CLASS__PREFIX__RestAPI : NSObject
+ (id)sharedInstance;

+ (NSString *)convertNonFieldErrorsToString:(NSArray *)errors;

- (AFNetworkReachabilityStatus)reachabilityStatus;


- (void)cancelAllRequestsForDelegate:(id)delegate;

- (void)registerDeviceWithSuccessBlock:(__CLASS__PREFIX__RestAPISuccessCallback)success failure:(__CLASS__PREFIX__RestAPIFailureCallback)failure owner:(id)owner;

@end


@protocol __CLASS__PREFIX__RestApiDelegate

/**
* Called if request was successful
*
* @param responseObject
*/
- (void)restApiRequestFinished:(id)responseObject;

/**
* Called if request failed
*/
- (void)restApiRequestFailed;

@end