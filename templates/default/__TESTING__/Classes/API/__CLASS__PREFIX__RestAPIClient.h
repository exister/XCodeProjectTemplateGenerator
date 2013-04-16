#import <Foundation/Foundation.h>
#import "AFHTTPClient.h"

@class AFHTTPRequestOperation;


@interface __CLASS__PREFIX__RestAPIClient : AFHTTPClient
- (void)getPath:(NSString *)path delegate:(id)delegate parameters:(NSDictionary *)parameters success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure;

- (void)postPath:(NSString *)path delegate:(id)delegate parameters:(NSDictionary *)parameters success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure;

- (void)putPath:(NSString *)path delegate:(id)delegate parameters:(NSDictionary *)parameters success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure;

- (void)deletePath:(NSString *)path delegate:(id)delegate parameters:(NSDictionary *)parameters success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure;

- (void)patchPath:(NSString *)path delegate:(id)delegate parameters:(NSDictionary *)parameters success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure;


- (void)cancelAllOperationsForDelegate:(id)delegate;

@end