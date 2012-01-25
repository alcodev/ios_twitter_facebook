//
//  Created by aistomin on 1/18/12.
//
//


#import "TwitterFacade.h"
#import "SA_OAuthTwitterEngine.h"
#import "SA_OAuthTwitterController.h"
#import "Consts.h"
#import "ViewController.h"
#import "TwitterControllerDelegate.h"

#define TWITTER_AUTH_TOKEN      @"twitterAuthenticationToken"
#define TWITTER_USERNAME        @"twitterUsername"

@interface TwitterFacade ()

- (id)defaultsGetObjectForKey:(NSString *)key;

- (BOOL)engineIsAuthorized;

- (void)defaultsClear;

@end

@implementation TwitterFacade {
    SA_OAuthTwitterEngine *_engine;
    ViewController *_controller;
    TwitterControllerDelegate *_delegate;
}

- (id)initWithViewController:(ViewController *)viewController {
    self = [super init];
    if (self) {
        _controller = [viewController retain];
        _delegate = [[TwitterControllerDelegate alloc] initWithController:viewController];
    }

    return self;
}

- (void)dealloc {
    [_engine release];
    [_delegate release];
    [_controller release];

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
    _engine = [[SA_OAuthTwitterEngine alloc] initOAuthWithDelegate:_delegate];
    _engine.consumerKey = TWITTER_APP_CONSUMER_KEY;
    _engine.consumerSecret = TWITTER_APP_CONSUMER_SECRET;
}

- (BOOL)engineIsAuthorized {
    return _engine && [_engine isAuthorized];
}

- (void)engineClear {
    if (_engine) {
        [_engine clearAccessToken];
        [_engine endUserSession];
        [_engine release];
        _engine = nil;
    }
}

- (void)login {
    [self engineCreate];
    if ([self engineIsAuthorized]) {
        return;
    }

    UIViewController *controller = [SA_OAuthTwitterController controllerToEnterCredentialsWithTwitterEngine:_engine delegate:_delegate];
    if (controller)
        [_controller presentModalViewController:controller animated:YES];
    else {
        [_engine sendUpdate:[NSString stringWithFormat:@"Already Updated. %@", [NSDate date]]];
    }
}

- (void)restore {
    if (_engine) {
        return;
    }

    [self engineCreate];
    if ([self engineIsAuthorized]) {
        id username = [self defaultsGetObjectForKey:TWITTER_USERNAME];
        [_engine getUserInformationFor:username];
    }
}

- (void)logout {
    [self engineClear];
    [self defaultsClear];

    [_controller twitterLogoutFinished];
}

@end