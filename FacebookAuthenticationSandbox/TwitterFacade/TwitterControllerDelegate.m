//
//  Created by aistomin on 1/19/12.
//
//


#import "TwitterControllerDelegate.h"
#import "ViewController.h"
#import "SA_OAuthTwitterEngine.h"

#define TWITTER_AUTH_TOKEN      @"twitterAuthenticationToken"
#define TWITTER_USERNAME        @"twitterUsername"

@implementation TwitterControllerDelegate {
    ViewController *_viewController;
}

- (TwitterControllerDelegate *)initWithController:(ViewController *)controller {
    self = [super init];
    if (self){
        _viewController = [controller retain];
    }

    return (self);
}

- (void)dealloc {
    [_viewController release];
    [super dealloc];
}

//called by MGTwitterEngine
- (void)requestSucceeded:(NSString *)connectionIdentifier {
    LOG(@"Twitter Request Succeeded: %@", connectionIdentifier);

}

//called by MGTwitterEngine
- (void)requestFailed:(NSString *)connectionIdentifier withError:(NSError *)error {
    LOG(@"Twitter Request Failed: %@", error);
}

//called by MGTwitterEngine
- (void)userInfoReceived:(NSArray *)userInfo forRequest:(NSString *)connectionIdentifier {
    id userName = [[userInfo objectAtIndex:0] objectForKey:@"name"];
    LOG(@"Twitter Name: %@", userName);
    [_viewController showTwitterUsername:userName];
};

#pragma mark SA_OAuthTwitterControllerDelegate
- (void)OAuthTwitterController:(SA_OAuthTwitterController *)controller authenticatedWithUsername:(NSString *)username {
    NSLog(@"Twitter user authenicated for %@", username);
    [[controller engine] getUserInformationFor:username];
}

- (void)OAuthTwitterControllerFailed:(SA_OAuthTwitterController *)controller {
    LOG(@"Twitter authentication failed!");
    [_viewController showTwitterAuthenticationFailed];
}

- (void)OAuthTwitterControllerCanceled:(SA_OAuthTwitterController *)controller {
    LOG(@"TWITTER authentication canceled.");
    [_viewController showTwitterAuthenticationCanceled];
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