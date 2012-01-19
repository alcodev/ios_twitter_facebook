//
//  Created by aistomin on 1/18/12.
//
//


#import "TwitterFacade.h"
#import "SA_OAuthTwitterEngine.h"
#import "SA_OAuthTwitterController.h"
#import "Consts.h"


@implementation TwitterFacade {
    SA_OAuthTwitterEngine *_engine;
    id <SA_OAuthTwitterControllerDelegate> _twitterEngineDelegate;
}
- (id)initWithTwitterEngineDelegate:(NSObject <MGTwitterEngineDelegate> *)delegate {
    self = [super init];
    if (self) {
        _twitterEngineDelegate = [delegate retain];
    }

    return self;
//To change the template use AppCode | Preferences | File Templates.
}

- (void)dealloc {
    [_engine release];
    [_twitterEngineDelegate release];
    [super dealloc];
}

- (void)login {
    if (_engine) return;
    _engine = [[SA_OAuthTwitterEngine alloc] initOAuthWithDelegate:_twitterEngineDelegate];
    _engine.consumerKey = TWITTER_APP_CONSUMER_KEY;
    _engine.consumerSecret = TWITTER_APP_CONSUMER_SECRET;

    UIViewController *controller = [SA_OAuthTwitterController controllerToEnterCredentialsWithTwitterEngine:_engine delegate:_twitterEngineDelegate];

    if (controller)
        [_twitterEngineDelegate presentModalViewController:controller animated:YES];
    else {
        [_engine sendUpdate:[NSString stringWithFormat:@"Already Updated. %@", [NSDate date]]];
    }


}

- (void)logout {
   [_engine ]

}

- (void)getUserInformationFor:(NSString *)username {
   [_engine getUserInformationFor:username];

}
@end