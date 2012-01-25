//
//  Created by vavaka on 1/25/12.



#import <Foundation/Foundation.h>
#import "FBRequest.h"


typedef void(^FacebookMethodCallback)(id);
typedef void(^FacebookErrorCallback)(NSError *);

@interface FacebookResponseDelegate : NSObject<FBRequestDelegate>

- (id)initWithOnSuccess:(FacebookMethodCallback)onSuccess onError:(FacebookErrorCallback)onError;

@end