//
//  Created by aistomin on 1/18/12.
//
//


#import <Foundation/Foundation.h>

@protocol MGTwitterEngineDelegate;
@protocol SA_OAuthTwitterControllerDelegate;
@class ViewController;


@interface TwitterFacade : NSObject
- (id)initWithViewController:(ViewController *)viewController;

- (void)login;

- (void)restore;

- (void)logout;

@end