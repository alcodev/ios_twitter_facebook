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
#import "DefaultsKeys.h"


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

- (void)createEngine {
    _engine = [[SA_OAuthTwitterEngine alloc] initOAuthWithDelegate:_delegate];
    _engine.consumerKey = TWITTER_APP_CONSUMER_KEY;
    _engine.consumerSecret = TWITTER_APP_CONSUMER_SECRET;
}

- (void)login {
    [self createEngine];
    if ([_engine isAuthorized]) {
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
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    id username = [defaults objectForKey:TWITTER_USERNAME];
    [self createEngine];
    if ([_engine isAuthorized]) {
        [_engine getUserInformationFor:username];
    }
}

- (void)logout {
    [_engine clearAccessToken];
    [_engine endUserSession];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:TWITTER_AUTH_TOKEN];
    [defaults removeObjectForKey:TWITTER_USERNAME];
    [defaults synchronize];
    [_engine release];
    [_controller twitterLogoutFinished];
}

@end