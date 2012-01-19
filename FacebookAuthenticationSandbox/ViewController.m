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

@implementation ViewController {
    FacebookFacade *_facebookFacade;
    TwitterFacade *_twitterFacade;
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
        _facebookFacade = [[FacebookFacade alloc] initWithAppId:FACEBOOK_APP_ID andDelegate:self];
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
    if ([defaults objectForKey:@"FBAccessTokenKey"]
            && [defaults objectForKey:@"FBExpirationDateKey"]) {
        [[self getFacebookFacade] facebook].accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
        [[self getFacebookFacade] facebook].expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
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
    // Return YES for supported orientations
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
    [super dealloc];
}

- (IBAction)facebookLoginButtonClicked:(id)sender {
    [facebookLoginButton setEnabled:NO];
    [facebookLogoutButton setEnabled:NO];
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


- (void)fbDidLogin {
    LOG(@"User did login");
    FacebookFacade *facebookFacade = [self getFacebookFacade];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[[facebookFacade facebook] accessToken] forKey:@"FBAccessTokenKey"];
    [defaults setObject:[[facebookFacade facebook] expirationDate] forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
    [[facebookFacade facebook] requestWithGraphPath:@"me" andDelegate:self];
    [facebookLoginButton setEnabled:NO];
    [facebookLogoutButton setEnabled:YES];
}

- (void)fbDidNotLogin:(BOOL)cancelled {
    LOG(@"User did NOT login");
    [facebookNotificationTextLabel setText:@"Invalid user or password"];
    [facebookLoginButton setEnabled:YES];
    [facebookLogoutButton setEnabled:NO];
}

- (void)fbDidLogout {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"FBAccessTokenKey"];
    [defaults removeObjectForKey:@"FBExpirationDateKey"];
    [defaults synchronize];
    LOG(@"User did logout");
    [facebookNotificationTextLabel setText:@""];
    [facebookLoginButton setEnabled:YES];
    [facebookLogoutButton setEnabled:NO];
}

- (void)fbSessionInvalidated {
    LOG(@"Session invalidated");
    [facebookNotificationTextLabel setText:@"Session invalidated"];
    [facebookLoginButton setEnabled:YES];
    [facebookLogoutButton setEnabled:NO];
}

- (void)request:(FBRequest *)request didReceiveResponse:(NSURLResponse *)response {
    LOG(@"Inside didReceiveResponse: received response");
    LOG(@"URL @", [response URL]);
}

- (void)request:(FBRequest *)request didLoad:(id)result {
    if ([result isKindOfClass:[NSArray class]]) {
        result = [result objectAtIndex:0];
    }
    if ([result isKindOfClass:[NSDictionary class]]) {
        id userName = [result objectForKey:@"name"];
        LOG(@"Facebook Name: %@", userName);
        [facebookNotificationTextLabel setText:userName];
    }
}



- (void)logoutFinished {
    [twitterNotificationTextLabel setText:@""];
}

- (void)showTwitterUsername:(NSString *)username {
   [twitterNotificationTextLabel setText:username];
}

- (void)showTwitterAuthenticationFailed {
    [twitterNotificationTextLabel setText:@"Twitter authentication failed"];
}

- (void)showTwitterAuthenticationCanceled {
    [twitterNotificationTextLabel setText:@"Twitter authentication canceled"];
}
@end
