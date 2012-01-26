//
//  Created by vavaka on 1/25/12.



#import "FacebookResponseDelegate.h"


@implementation FacebookResponseDelegate {
    FacebookMethodCallback _onSuccess;
    FacebookMethodCallback _onError;
}

- (id)initWithOnSuccess:(FacebookMethodCallback)onSuccess onError:(FacebookErrorCallback)onError {
    self = [super init];
    if (self) {
        _onSuccess = Block_copy(onSuccess);
        _onError = Block_copy(onError);
    }

    return self;
}

- (void)request:(FBRequest *)request didReceiveResponse:(NSURLResponse *)response {
    LOG(@"Facebook graph api response received: %@", [response URL]);
}

- (void)request:(FBRequest *)request didLoad:(id)result {
    LOG(@"Facebook graph api request success");
    _onSuccess(result);
}

- (void)request:(FBRequest *)request didFailWithError:(NSError *)error {
    LOG(@"Facebook graph api request error: %@", error.description);
    _onError(error);
}

@end