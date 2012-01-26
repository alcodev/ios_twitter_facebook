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

@interface ViewController : UIViewController {

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


- (void)showTwitterResult:(NSString *)text;

- (void)showFacebookResult:(NSString *)text;
@end
