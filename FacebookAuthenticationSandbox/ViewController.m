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

@implementation ViewController {
    FacebookFacade *_facebookFacade;
}

@synthesize facebookFacade = _facebookFacade;

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [notificationTextLabel setText:@""];
//    [loginButton setEnabled:NO];
    [logoutButton setEnabled:NO];
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

- (void)viewWillAppear:(BOOL)animated {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [super viewWillAppear:animated];
    if ([defaults objectForKey:@"FBAccessTokenKey"]
            && [defaults objectForKey:@"FBExpirationDateKey"]) {
        [[self getFacebookFacade] facebook].accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
        [[self getFacebookFacade] facebook].expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
    }
    [[self getFacebookFacade] restoreSession];
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
    [notificationTextLabel release];
    [loginButton release];
    [logoutButton release];
    [super dealloc];
}

- (IBAction)loginButtonClicked:(id)sender {
    [loginButton setEnabled:NO];
    [logoutButton setEnabled:NO];
    FacebookFacade *facebookFacade = [self getFacebookFacade];
    [facebookFacade login];
}

- (IBAction)logoutButtonClicked:(id)sender {
    [[self getFacebookFacade] logout];
}


- (void)fbDidLogin {
    LOG(@"User did login");
    FacebookFacade *facebookFacade = [self getFacebookFacade];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[[facebookFacade facebook] accessToken] forKey:@"FBAccessTokenKey"];
    [defaults setObject:[[facebookFacade facebook] expirationDate] forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
    [[facebookFacade facebook] requestWithGraphPath:@"me" andDelegate:self];
    [loginButton setEnabled:NO];
    [logoutButton setEnabled:YES];
}

- (void)fbDidNotLogin:(BOOL)cancelled {
    LOG(@"User did NOT login");
    [notificationTextLabel setText:@"Invalid user or password"];
    [loginButton setEnabled:YES];
    [logoutButton setEnabled:NO];
}

- (void)fbDidLogout {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"FBAccessTokenKey"];
    [defaults removeObjectForKey:@"FBExpirationDateKey"];
    [defaults synchronize];
    LOG(@"User did logout");
    [notificationTextLabel setText:@""];
    [loginButton setEnabled:YES];
    [logoutButton setEnabled:NO];
}

- (void)fbSessionInvalidated {
    LOG(@"Session invalidated");
    [notificationTextLabel setText:@"Session invalidated"];
    [loginButton setEnabled:YES];
    [logoutButton setEnabled:NO];
}

- (void)request:(FBRequest *)request didReceiveResponse:(NSURLResponse *)response {
    LOG(@"Inside didReceiveResponse: received response");
    LOG(@"URL @", [response URL]);
}

- (void)request:(FBRequest *)request didLoad:(id)result {
    NSLog(@"Inside didLoad");
    if ([result isKindOfClass:[NSArray class]]) {
        result = [result objectAtIndex:0];
    }
    if ([result isKindOfClass:[NSDictionary class]]) {
        id userName = [result objectForKey:@"name"];LOG(@"Name: %@", userName);
        [notificationTextLabel setText:userName];
    }
    LOG(@"request returns %@", result);

};
@end
