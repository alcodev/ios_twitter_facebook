//
//  Created by aistomin on 1/19/12.
//
//


#import <Foundation/Foundation.h>
#import "SA_OAuthTwitterController.h"

@class ViewController;


@interface TwitterControllerDelegate : NSObject<SA_OAuthTwitterControllerDelegate>
- (TwitterControllerDelegate *)initWithController:(ViewController *)controller;
@end