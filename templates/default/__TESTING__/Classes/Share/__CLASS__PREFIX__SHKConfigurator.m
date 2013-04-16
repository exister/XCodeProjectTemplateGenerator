#import "__CLASS__PREFIX__SHKConfigurator.h"

@implementation __CLASS__PREFIX__SHKConfigurator

- (NSString *)appName {
    return k__CLASS__PREFIX__SHKAppName;
}

- (NSString *)appURL {
    return k__CLASS__PREFIX__SHKAppUrl;
}

- (NSArray*)defaultFavoriteURLSharers {
    return [NSArray arrayWithObjects:@"SHKTwitter",@"SHKFacebook", @"SHKVkontakte", nil];
}

- (NSArray*)defaultFavoriteImageSharers {
    return [NSArray arrayWithObjects:@"SHKMail",@"SHKFacebook", @"SHKCopy", nil];
}

- (NSArray*)defaultFavoriteTextSharers {
    return [NSArray arrayWithObjects:@"SHKTwitter",@"SHKFacebook", @"SHKVkontakte", nil];
}

- (NSArray*)defaultFavoriteFileSharers {
    return [NSArray arrayWithObjects:@"SHKMail",@"SHKEvernote", nil];
}

- (NSString *)vkontakteAppId {
    return k__CLASS__PREFIX__SHKVkontakteAppId;
}

- (NSString *)facebookAppId {
    return k__CLASS__PREFIX__SHKFacebookAppId;
}

- (NSString *)facebookLocalAppId {
    return [super facebookLocalAppId];
}

- (NSString *)twitterConsumerKey {
    #warning Set real TW id
    return @"";
}

- (NSString *)twitterSecret {
    #warning Set real TW secret
    return @"";
}

- (NSString *)twitterCallbackUrl {
    #warning Set real url
    return @"";
}

- (NSString *)twitterUsername {
    return [super twitterUsername];
}

- (NSNumber *)shareMenuAlphabeticalOrder {
    return @1;
}

- (NSNumber *)showActionSheetMoreButton {
    return @0;
}

- (NSNumber *)allowOffline {
    return [super allowOffline];
}


@end
