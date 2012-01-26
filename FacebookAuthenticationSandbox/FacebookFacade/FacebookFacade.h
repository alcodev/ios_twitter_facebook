//
//  Created by aistomin on 1/17/12.
//
//


#import <Foundation/Foundation.h>
#import "FBRequest.h"
#import "Facebook.h"
#import "FacebookResponseDelegate.h"

@class Facebook;

@interface FacebookFacade : NSObject<FBSessionDelegate, FBRequestDelegate> {
    Facebook *_facebook;
}

@property(nonatomic, readonly) Facebook *facebook;
@property(nonatomic, copy) Callback onSessionRestored;
@property(nonatomic, copy) Callback onSessionInvalidated;
@property(nonatomic, copy) Callback onLoginSuccess;
@property(nonatomic, copy) Callback onLoginError;
@property(nonatomic, copy) Callback onLogoutSuccess;


- (id)initWithAppId:(NSString *)appId;

- (void)login;

- (void)logout;

- (void)restoreSession;

- (void)requestWithGraphPath:(NSString *)path onSuccess:(FacebookMethodCallback)onSuccess onError:(FacebookErrorCallback)onError;

@end