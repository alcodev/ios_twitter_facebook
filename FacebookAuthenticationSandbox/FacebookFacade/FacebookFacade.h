//
//  Created by aistomin on 1/17/12.
//
//


#import <Foundation/Foundation.h>
#import "FBRequest.h"
#import "Facebook.h"
#import "FacebookResponseDelegate.h"

@class Facebook;

typedef void(^FacebookCallback)(id result);

@interface FacebookFacade : NSObject<FBSessionDelegate, FBRequestDelegate> {
    Facebook *_facebook;
}

@property(nonatomic, readonly) Facebook *facebook;
@property(nonatomic, copy) Callback onSessionRestored;
@property(nonatomic, copy) Callback onSessionInvalidated;


- (id)initWithAppId:(NSString *)appId;

- (void)loginAndDoOnSuccess:(Callback)onSuccess onError:(Callback)onError;

- (void)logoutAndDoOnSuccess:(Callback)onSuccess;

- (void)restoreSession;

- (void)requestWithGraphPath:(NSString *)path onSuccess:(FacebookMethodCallback)onSuccess onError:(FacebookErrorCallback)onError;

@end