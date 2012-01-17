//
//  Created by aistomin on 1/17/12.
//
//


#import <Foundation/Foundation.h>

@class Facebook;
@protocol FBSessionDelegate;

@interface FacebookFacade : NSObject {
    Facebook *_facebook;
}
@property(nonatomic, readonly) Facebook *facebook;

- (id)initWithAppId:(NSString *)appId andDelegate:(id <FBSessionDelegate>)delegate;

- (void)login;

- (void)logout;

- (void)restoreSession;
@end