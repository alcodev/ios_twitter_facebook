//
//  Created by aistomin on 1/19/12.
//
//


#import <Foundation/Foundation.h>
#import "FBRequest.h"
#import "Facebook.h"

@class ViewController;


@interface FacebookControllerDelegate : NSObject<FBSessionDelegate, FBRequestDelegate>
- (FacebookControllerDelegate *)initWithController:(ViewController *)controller;
@end