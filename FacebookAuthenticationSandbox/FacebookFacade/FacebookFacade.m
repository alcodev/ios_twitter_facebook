//
//  Created by aistomin on 1/17/12.
//
//


#import "FacebookFacade.h"

@interface FacebookFacade()

@property(nonatomic, copy) Callback onLoginSuccess;
@property(nonatomic, copy) Callback onLoginError;
@property(nonatomic, copy) Callback onLogoutSuccess;

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

- (void)loginAndDoOnSuccess:(Callback)onSuccess onError:(Callback)onError {
    self.onLoginSuccess = onSuccess;
    self.onLoginError = onError;

    if ([_facebook isSessionValid]) {
        self.onLoginSuccess();
    } else {
        [_facebook authorize:_permissions];
    }
}

- (void)logoutAndDoOnSuccess:(Callback)onSuccess {
    self.onLogoutSuccess = onSuccess;

   [_facebook logout];
}

- (void)restoreSession {
    if ([_facebook isSessionValid]) {
        LOG(@"User is authenticated. Restore the session");
        self.onSessionRestored();
    } else{
        LOG(@"User not authenticated");
    }
}

- (void)fbDidLogin {
    LOG(@"Facebook user did login");
    self.onLoginSuccess();
}

- (void)fbDidNotLogin:(BOOL)cancelled {
    LOG(@"Facebook user did NOT login");
    self.onLoginError();
}

- (void)fbDidLogout {
    LOG(@"Facebook user logout");
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