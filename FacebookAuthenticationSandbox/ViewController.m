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
            [self showTwitterResult:username];
        };
        _twitterFacade.onLoggedIn = ^(NSString *username) {
            //[[controller engine] getUserInformationFor:username];
            [twitterLoginButton setEnabled:NO];
            [twitterLogoutButton setEnabled:YES];
            [self showTwitterResult:username];
        };
        _twitterFacade.onLoginError = ^() {
            [self showTwitterResult:@"Error"];
        };
        _twitterFacade.onLoginCanceled = ^() {
            [self showTwitterResult:@"Canceled"];
        };
        _twitterFacade.onLoggedOut = ^() {
            [twitterLoginButton setEnabled:YES];
            [twitterLogoutButton setEnabled:NO];
            [self showTwitterResult:@""];
        };

        _facebookFacade = [[FacebookFacade alloc] initWithAppId:FACEBOOK_APP_ID];
        _facebookFacade.onSessionInvalidated = ^{
            [self showFacebookResult:@"Session invalidated"];
            [facebookLoginButton setEnabled:YES];
            [facebookLogoutButton setEnabled:NO];
        };
        _facebookFacade.onSessionRestored = ^{
            [self onFacebookLoggedIn];
        };
        _facebookFacade.onLoginSuccess = ^{
            [self onFacebookLoggedIn];
        };
        _facebookFacade.onLoginError = ^{
            [self showFacebookResult:@"Error"];
        };
        _facebookFacade.onLogoutSuccess = ^{
            [self onFacebookLoggedOut];
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

    [self showFacebookResult:@""];
    [self showTwitterResult:@""];

    [facebookLogoutButton setEnabled:NO];
    [twitterLogoutButton setEnabled:NO];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [_facebookFacade restoreSession];
    [_twitterFacade restoreSession];
}

- (IBAction)facebookLoginButtonClicked:(id)sender {
    [_facebookFacade login];
}

- (IBAction)facebookLogoutButtonClicked:(id)sender {
    [_facebookFacade logout];
}

- (IBAction)twitterLoginButtonClicked:(id)sender {
    [_twitterFacade login];
}

- (IBAction)twitterLogoutButtonClicked:(id)sender {
    [_twitterFacade logout];
}

- (void)showFacebookResult:(NSString *)text {
    [facebookNotificationTextLabel setText:text];
}

- (void)showTwitterResult:(NSString *)text {
    [twitterNotificationTextLabel setText:text];
}

-(void)onFacebookLoggedIn {
    [facebookLoginButton setEnabled:NO];
    [facebookLogoutButton setEnabled:YES];

    [_facebookFacade requestWithGraphPath:@"me" onSuccess:^(id result){
        if ([result isKindOfClass:[NSArray class]]) {
            LOG(@"Facebook result is array");
            result = [result objectAtIndex:0];
        }

        if ([result isKindOfClass:[NSDictionary class]]) {
            id fullName = [result objectForKey:@"name"];
            [self showFacebookResult:fullName];
            LOG(@"Facebook full name: %@", fullName);
        }
    } onError:^(NSError *error){
        //handle error
    }];
}

-(void)onFacebookLoggedOut {
    [self showFacebookResult:@""];
    [facebookLoginButton setEnabled:YES];
    [facebookLogoutButton setEnabled:NO];
}

@end
