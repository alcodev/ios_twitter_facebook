//
//  Created by aistomin on 1/17/12.
//
//


#import "FacebookFacade.h"

#define FACEBOOK_AUTH_TOKEN             @"FBAccessTokenKey"
#define FACEBOOK_EXPIRATION_DATE_KEY    @"FBExpirationDateKey"

@interface FacebookFacade()

- (void)defaultsLoad;

- (void)defaultsUpdate;

- (void)defaultsClear;

@end

@implementation FacebookFacade {
    NSArray *_permissions;
}


@synthesize facebook = _facebook;
@synthesize onSessionRestored = _onSessionRestored;
@synthesize onSessionInvalidated = _onSessionInvalidated;
@synthesize onLoginSuccess = _onLoginSuccess;
@synthesize onLoginError = _onLoginError;
@synthesize onLogoutSuccess = _onLogoutSuccess;


- (id)initWithAppId:(NSString *)appId {
    self = [super init];
    if (self) {
        _permissions = [[NSArray alloc] initWithObjects:@"offline_access", @"user_about_me", nil];
        _facebook = [[Facebook alloc] initWithAppId:appId andDelegate:self];

        [self defaultsLoad];
    }

    return self;
}

- (void)dealloc {
    [_permissions release];
    [_facebook release];

    [_onSessionRestored release];
    [_onSessionInvalidated release];
    [_onLoginSuccess release];
    [_onLoginError release];
    [_onLogoutSuccess release];

    [super dealloc];
}

- (void)defaultsLoad {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:FACEBOOK_AUTH_TOKEN] && [defaults objectForKey:FACEBOOK_EXPIRATION_DATE_KEY]) {
        _facebook.accessToken = [defaults objectForKey:FACEBOOK_AUTH_TOKEN];
        _facebook.expirationDate = [defaults objectForKey:FACEBOOK_EXPIRATION_DATE_KEY];
    }
}

- (void)defaultsUpdate {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:_facebook.accessToken forKey:FACEBOOK_AUTH_TOKEN];
    [defaults setObject:_facebook.expirationDate forKey:FACEBOOK_EXPIRATION_DATE_KEY];
    [defaults synchronize];
}

- (void)defaultsClear {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:FACEBOOK_AUTH_TOKEN];
    [defaults removeObjectForKey:FACEBOOK_EXPIRATION_DATE_KEY];
    [defaults synchronize];
}

- (void)login {
    if ([_facebook isSessionValid]) {
        self.onLoginSuccess();
    } else {
        [_facebook authorize:_permissions];
    }
}

- (void)logout {
   [_facebook logout];
}

- (void)restoreSession {
    if ([_facebook isSessionValid]) {
        LOG(@"Facebook session restored");
        self.onSessionRestored();
    } else{
        LOG(@"Facebook session not found");
    }
}

- (void)fbDidLogin {
    LOG(@"Facebook logged in");
    [self defaultsUpdate];
    self.onLoginSuccess();
}

- (void)fbDidNotLogin:(BOOL)cancelled {
    LOG(@"Facebook login error");
    self.onLoginError();
}

- (void)fbDidLogout {
    LOG(@"Facebook logged out");
    [self defaultsClear];
    self.onLogoutSuccess();
}

- (void)fbSessionInvalidated {
    LOG(@"Facebook session invalidated");
    self.onSessionInvalidated();
}

- (void)requestWithGraphPath:(NSString *)path onSuccess:(FacebookMethodCallback)onSuccess onError:(FacebookErrorCallback)onError {
    FacebookResponseDelegate *responseDelegate = [[[FacebookResponseDelegate alloc] initWithOnSuccess:onSuccess onError:onError] autorelease];
    [_facebook requestWithGraphPath:path andDelegate:responseDelegate];
}

@end