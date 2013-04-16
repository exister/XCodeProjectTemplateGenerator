#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@protocol __CLASS__PREFIX__RestApiDelegate;

@interface __CLASS__PREFIX__RestAPI : NSObject
+ (id)sharedInstance;

- (AFNetworkReachabilityStatus)reachabilityStatus;


- (void)cancelAllRequestsForDelegate:(id)delegate;

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