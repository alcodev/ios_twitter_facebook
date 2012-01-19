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
#import "DefaultsKeys.h"
#import "FacebookControllerDelegate.h"

@implementation ViewController {
    FacebookFacade *_facebookFacade;
    TwitterFacade *_twitterFacade;
    FacebookControllerDelegate *_facebookControllerDelegate;
}

@synthesize facebookFacade = _facebookFacade;

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [facebookNotificationTextLabel setText:@""];
    [twitterNotificationTextLabel setText:@""];
//    [loginButton setEnabled:NO];
    [facebookLogoutButton setEnabled:NO];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (FacebookFacade *)getFacebookFacade {
    if (!_facebookFacade) {
        _facebookControllerDelegate = [[FacebookControllerDelegate alloc] initWithController:self];
        _facebookFacade = [[FacebookFacade alloc] initWithAppId:FACEBOOK_APP_ID andDelegate:_facebookControllerDelegate];
    }
    return (_facebookFacade);
}

- (TwitterFacade *)getTwitterFacade {
    if (!_twitterFacade) {
        _twitterFacade = [[TwitterFacade alloc] initWithViewController:self];
    }
    return (_twitterFacade);
}

- (void)viewWillAppear:(BOOL)animated {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [super viewWillAppear:animated];
    if ([defaults objectForKey:FACEBOOK_AUTH_TOKEN]
            && [defaults objectForKey:FACEBOOK_EXPIRATION_DATE_KEY]) {
        [[self getFacebookFacade] facebook].accessToken = [defaults objectForKey:FACEBOOK_AUTH_TOKEN];
        [[self getFacebookFacade] facebook].expirationDate = [defaults objectForKey:FACEBOOK_EXPIRATION_DATE_KEY];
    }
    [[self getFacebookFacade] restoreSession];

    [[self getTwitterFacade] restore];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}


- (void)dealloc {
    [_facebookFacade release];
    [facebookNotificationTextLabel release];
    [facebookLoginButton release];
    [facebookLogoutButton release];
    [_twitterFacade release];
    [_facebookControllerDelegate release];
    [super dealloc];
}

- (IBAction)facebookLoginButtonClicked:(id)sender {
    [facebookLoginButton setEnabled:NO];
    [facebookLogoutButton setEnabled:NO];
    [twitterLoginButton setEnabled:NO];
    [twitterLogoutButton setEnabled:NO];
    FacebookFacade *facebookFacade = [self getFacebookFacade];
    [facebookFacade login];
}

- (IBAction)facebookLogoutButtonClicked:(id)sender {
    [[self getFacebookFacade] logout];
}


- (IBAction)twitterLoginButtonClicked:(id)sender {
    [[self getTwitterFacade] login];
}

- (IBAction)twitterLogoutButtonClicked:(id)sender {
    [[self getTwitterFacade] logout];
}

- (void)twitterLogoutFinished {
    [twitterNotificationTextLabel setText:@""];
    [twitterLoginButton setEnabled:YES];
    [twitterLogoutButton setEnabled:NO];
}

- (void)showTwitterUsername:(NSString *)username {
    [twitterNotificationTextLabel setText:username];
    [twitterLoginButton setEnabled:NO];
    [twitterLogoutButton setEnabled:YES];
}

- (void)showTwitterAuthenticationFailed {
    [twitterNotificationTextLabel setText:@"Twitter authentication failed"];
    [twitterLoginButton setEnabled:YES];
    [twitterLogoutButton setEnabled:NO];
}

- (void)showTwitterAuthenticationCanceled {
    [twitterNotificationTextLabel setText:@"Twitter authentication canceled"];
    [twitterLoginButton setEnabled:YES];
    [twitterLogoutButton setEnabled:NO];
}

- (void)onFacebookLoginSuccess {
    FacebookFacade *facebookFacade = [self getFacebookFacade];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[[facebookFacade facebook] accessToken] forKey:FACEBOOK_AUTH_TOKEN];
    [defaults setObject:[[facebookFacade facebook] expirationDate] forKey:FACEBOOK_EXPIRATION_DATE_KEY];
    [defaults synchronize];
    [[facebookFacade facebook] requestWithGraphPath:@"me" andDelegate:_facebookControllerDelegate];
    [facebookLoginButton setEnabled:NO];
    [facebookLogoutButton setEnabled:YES];
}

- (void)onFacebookLoginFailed {
    [facebookNotificationTextLabel setText:@"Invalid user or password"];
    [facebookLoginButton setEnabled:YES];
    [facebookLogoutButton setEnabled:NO];
}

- (void)onFacebookLogout {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:FACEBOOK_AUTH_TOKEN];
    [defaults removeObjectForKey:FACEBOOK_EXPIRATION_DATE_KEY];
    [defaults synchronize];
    LOG(@"User did logout");
    [facebookNotificationTextLabel setText:@""];
    [facebookLoginButton setEnabled:YES];
    [facebookLogoutButton setEnabled:NO];

}

- (void)onFacebookSessionInvalidated {
    [facebookNotificationTextLabel setText:@"Session invalidated"];
    [facebookLoginButton setEnabled:YES];
    [facebookLogoutButton setEnabled:NO];
}

- (void)showFacebookUsername:(NSString *)username {
    [facebookNotificationTextLabel setText:username];
}
@end
