//
//  ViewController.h
//  FacebookAuthenticationSandbox
//
//  Created by Andrej Istomin on 1/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Facebook.h"
#import "MGTwitterEngineDelegate.h"
#import "SA_OAuthTwitterController.h"

@class FacebookFacade;

@interface ViewController : UIViewController<FBSessionDelegate, FBRequestDelegate, SA_OAuthTwitterControllerDelegate> {

    IBOutlet UILabel *facebookNotificationTextLabel;
    IBOutlet UIButton *facebookLoginButton;
    IBOutlet UIButton *facebookLogoutButton;

    IBOutlet UILabel *twitterNotificationTextLabel;
    IBOutlet UIButton *twitterLoginButton;
    IBOutlet UIButton *twitterLogoutButton;
}
@property(nonatomic, readonly)FacebookFacade *facebookFacade;

- (IBAction)facebookLoginButtonClicked:(id)sender;
- (IBAction)facebookLogoutButtonClicked:(id)sender;

- (IBAction)twitterLoginButtonClicked:(id)sender;
- (IBAction)twitterLogoutButtonClicked:(id)sender;


/**
 * Called when the user successfully logged in.
 */
- (void)fbDidLogin;

/**
 * Called when the user dismissed the dialog without logging in.
 */
- (void)fbDidNotLogin:(BOOL)cancelled;

/**
 * Called when the user logged out.
 */
- (void)fbDidLogout;

/**
 * Called when the current session has expired. This might happen when:
 *  - the access token expired
 *  - the app has been disabled
 *  - the user revoked the app's permissions
 *  - the user changed his or her password
 */
- (void)fbSessionInvalidated;



- (void)requestSucceeded:(NSString *)connectionIdentifier;

- (void)requestFailed:(NSString *)connectionIdentifier withError:(NSError *)error;

- (void)userInfoReceived:(NSArray *)userInfo forRequest:(NSString *)connectionIdentifier;


@end
