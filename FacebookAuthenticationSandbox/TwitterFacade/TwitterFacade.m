//
//  Created by aistomin on 1/18/12.
//
//


#import "TwitterFacade.h"
#import "SA_OAuthTwitterEngine.h"

#define TWITTER_AUTH_TOKEN      @"twitterAuthenticationToken"
#define TWITTER_USERNAME        @"twitterUsername"

@interface TwitterFacade ()

- (id)defaultsGetObjectForKey:(NSString *)key;

- (void)defaultsClear;

@end

@implementation TwitterFacade {
    NSString *_appConsumerKey;
    NSString *_appConsumerSecret;

    SA_OAuthTwitterEngine *_engine;
}

@synthesize onEnterCredentials = _onEnterCredentials;
@synthesize onSessionRestored = _onSessionRestored;
@synthesize onLoggedIn = _onLoggedIn;
@synthesize onLoginError = _onLoginError;
@synthesize onLoginCanceled = _onLoginCanceled;
@synthesize onLoggedOut = _onLoggedOut;


- (id)initWithAppConsumerKey:(NSString *)appConsumerKey appConsumerSecret:(NSString *)appConsumerSecret {
    self = [super init];
    if (self) {
        _appConsumerKey = [appConsumerKey copy];
        _appConsumerSecret = [appConsumerSecret copy];
    }

    return self;
}

- (void)dealloc {
    [_appConsumerKey release];
    [_appConsumerSecret release];
    [_engine release];

    [_onEnterCredentials release];
    [_onSessionRestored release];
    [_onLoggedIn release];
    [_onLoginError release];
    [_onLoginCanceled release];
    [_onLoggedOut release];

    [super dealloc];
}

- (id)defaultsGetObjectForKey:(NSString *)key {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:key];
}

- (void)defaultsClear {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:TWITTER_AUTH_TOKEN];
    [defaults removeObjectForKey:TWITTER_USERNAME];
    [defaults synchronize];
}

- (void)engineCreate {
    _engine = [[SA_OAuthTwitterEngine alloc] initOAuthWithDelegate:self];
    _engine.consumerKey = _appConsumerKey;
    _engine.consumerSecret = _appConsumerSecret;
}

- (void)engineClear {
    if (_engine) {
        [_engine clearAccessToken];
        [_engine endUserSession];
        [_engine release];
        _engine = nil;
    }
}

- (BOOL)isAuthorized {
    return _engine && [_engine isAuthorized];
}

- (void)login {
    [self engineCreate];
    if ([self isAuthorized]) {
        return;
    }

    UIViewController *enterCredentialsController = [SA_OAuthTwitterController controllerToEnterCredentialsWithTwitterEngine:_engine delegate:self];
    self.onEnterCredentials(enterCredentialsController);
}

- (void)restoreSession {
    if (_engine) {
        return;
    }

    [self engineCreate];
    if (![self isAuthorized]) {
        LOG(@"Twitter session not found");
    } else {
        LOG(@"Twitter session restored for user %@", [self defaultsGetObjectForKey:TWITTER_USERNAME]);
        self.onSessionRestored([self defaultsGetObjectForKey:TWITTER_USERNAME]);
    }
}

- (void)logout {
    [self engineClear];
    [self defaultsClear];

    LOG(@"Twitter logged out");

    self.onLoggedOut();
}


- (void)requestSucceeded:(NSString *)connectionIdentifier {
    LOG(@"Twitter request succeeded: %@", connectionIdentifier);

}

- (void)requestFailed:(NSString *)connectionIdentifier withError:(NSError *)error {
    LOG(@"Twitter request failed: %@", error);
}

- (void)userInfoReceived:(NSArray *)userInfo forRequest:(NSString *)connectionIdentifier {
    id userName = [[userInfo objectAtIndex:0] objectForKey:@"name"];
    LOG(@"Twitter Name: %@", userName);
};

#pragma mark SA_OAuthTwitterControllerDelegate
- (void)OAuthTwitterController:(SA_OAuthTwitterController *)controller authenticatedWithUsername:(NSString *)username {
    LOG(@"Twitter logged in: %@", username);
    self.onLoggedIn(username);
}

- (void)OAuthTwitterControllerFailed:(SA_OAuthTwitterController *)controller {
    LOG(@"Twitter login error");

    [self engineClear];
    self.onLoginError();
}

- (void)OAuthTwitterControllerCanceled:(SA_OAuthTwitterController *)controller {
    LOG(@"Twitter login canceled");

    [self engineClear];
    self.onLoginCanceled();
}

//called by SA_OAuthTwitterEngine
- (void)storeCachedTwitterOAuthData:(NSString *)data forUsername:(NSString *)username {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:data forKey:TWITTER_AUTH_TOKEN];
    [defaults setObject:username forKey:TWITTER_USERNAME];
    [defaults synchronize];
}

//called by SA_OAuthTwitterEngine
- (NSString *)cachedTwitterOAuthDataForUsername:(NSString *)username {
    return [[NSUserDefaults standardUserDefaults] objectForKey:TWITTER_AUTH_TOKEN];
}

@end