//
//  ViewController.m
//  FacebookAuthenticationSandbox
//
//  Created by Andrej Istomin on 1/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "FacebookFacade.h"
#import "Consts.h"
#import "TwitterFacade.h"

@interface ViewController ()

- (void)onFacebookLoggedIn;

- (void)onFacebookLoggedOut;

@end

@implementation ViewController {
    FacebookFacade *_facebookFacade;
    TwitterFacade *_twitterFacade;
}

@synthesize facebookFacade = _facebookFacade;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _twitterFacade = [[TwitterFacade alloc] initWithAppConsumerKey:TWITTER_APP_CONSUMER_KEY appConsumerSecret:TWITTER_APP_CONSUMER_SECRET];
        _twitterFacade.onEnterCredentials = ^(UIViewController *enterCredentialsController) {
            [self presentModalViewController:enterCredentialsController animated:YES];
        };
        _twitterFacade.onSessionRestored = ^(NSString *username) {
            [twitterLoginButton setEnabled:NO];
            [twitterLogoutButton setEnabled:YES];
            [self showTwitterUsername:username];
        };
        _twitterFacade.onLoggedIn = ^(NSString *username) {
            //[[controller engine] getUserInformationFor:username];
            [twitterLoginButton setEnabled:NO];
            [twitterLogoutButton setEnabled:YES];
            [self showTwitterUsername:username];
        };
        _twitterFacade.onLoginError = ^() {
            [self showTwitterUsername:@"Error"];
        };
        _twitterFacade.onLoginCanceled = ^() {
            [self showTwitterUsername:@"Canceled"];
        };
        _twitterFacade.onLoggedOut = ^() {
            [twitterLoginButton setEnabled:YES];
            [twitterLogoutButton setEnabled:NO];
            [self showTwitterUsername:@""];
        };

        _facebookFacade = [[FacebookFacade alloc] initWithAppId:FACEBOOK_APP_ID];
        _facebookFacade.onSessionInvalidated = ^{
            LOG(@"Facebook session invalidated");
            [facebookNotificationTextLabel setText:@"Session invalidated"];
            [facebookLoginButton setEnabled:YES];
            [facebookLogoutButton setEnabled:NO];
        };
        _facebookFacade.onSessionRestored = ^{
            LOG(@"Facebook session restored");
            [self onFacebookLoggedIn];
        };
    }

    return self;
}

- (void)dealloc {
    [_facebookFacade release];
    [_twitterFacade release];

    [facebookNotificationTextLabel release];
    [twitterNotificationTextLabel release];

    [facebookLoginButton release];
    [facebookLogoutButton release];

    [twitterLoginButton release];
    [twitterLogoutButton release];

    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [facebookNotificationTextLabel setText:@""];
    [twitterNotificationTextLabel setText:@""];

    [facebookLogoutButton setEnabled:NO];
    [twitterLogoutButton setEnabled:NO];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [_facebookFacade restoreSession];
    [_twitterFacade restoreSession];
}

- (IBAction)facebookLoginButtonClicked:(id)sender {
     [_facebookFacade loginAndDoOnSuccess:^{
         LOG(@"Facebook login success");
         [self onFacebookLoggedIn];
     } onError:^{
        //handle error
     }];
}

- (IBAction)facebookLogoutButtonClicked:(id)sender {
    [_facebookFacade logoutAndDoOnSuccess:^{
        LOG(@"Facebook logout success");
        [self onFacebookLoggedOut];
    }];
}

-(void)onFacebookLoggedIn {
    [facebookLoginButton setEnabled:NO];
    [facebookLogoutButton setEnabled:YES];

    [_facebookFacade requestWithGraphPath:@"me" onSuccess:^(id result){
        LOG(@"Facebook graph api request success");
        if ([result isKindOfClass:[NSArray class]]) {
            LOG(@"Received Facebook result is array");
            result = [result objectAtIndex:0];
        }

        if ([result isKindOfClass:[NSDictionary class]]) {
            id fullName = [result objectForKey:@"name"];
            [facebookNotificationTextLabel setText:fullName];
            LOG(@"Received Facebook full name: %@", fullName);
        }
    } onError:^(NSError *error){
        LOG(@"Facebook graph api request error: %@", error.description);
    }];
}

-(void)onFacebookLoggedOut {
    [facebookNotificationTextLabel setText:@""];
    [facebookLoginButton setEnabled:YES];
    [facebookLogoutButton setEnabled:NO];
}

- (IBAction)twitterLoginButtonClicked:(id)sender {
    [_twitterFacade login];
}

- (IBAction)twitterLogoutButtonClicked:(id)sender {
    [_twitterFacade logout];
}

- (void)showTwitterUsername:(NSString *)username {
    [twitterNotificationTextLabel setText:username];
}

@end
