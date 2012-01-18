//
//  Created by aistomin on 1/17/12.
//
//


#import "FacebookFacade.h"
#import "Facebook.h"


@implementation FacebookFacade {
    NSArray *_permissions;
    id<FBSessionDelegate> _fbSessionDelegate;

}
@synthesize facebook = _facebook;

- (id)initWithAppId:(NSString *)appId andDelegate:(id <FBSessionDelegate>)delegate {
    self = [super init];
    if (self) {
        _fbSessionDelegate = delegate;
        _permissions = [[NSArray alloc] initWithObjects:@"offline_access", @"user_about_me", nil];
        _facebook = [[Facebook alloc] initWithAppId:appId andDelegate:delegate];
    }

    return self;
}

- (void)login {
    if (![_facebook isSessionValid]) {
        [_facebook authorize:_permissions];
    } else {
        [_fbSessionDelegate fbDidLogin];
    }

}

- (void)dealloc {
    [_permissions release];
    [_facebook release];
    [super dealloc];
}

- (void)logout {
   [_facebook logout];
}

- (void)restoreSession {
    if ([_facebook isSessionValid]) {
        LOG(@"User is authenticated. Restore the session");
        [_fbSessionDelegate fbDidLogin];
    } else{
        LOG(@"User not authenticated");
    }
}

@end