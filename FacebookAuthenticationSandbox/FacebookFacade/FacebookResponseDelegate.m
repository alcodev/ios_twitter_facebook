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
    LOG(@"Facebook response was received. URL @", [response URL]);
}

- (void)request:(FBRequest *)request didLoad:(id)result {
    _onSuccess(result);
}

- (void)request:(FBRequest *)request didFailWithError:(NSError *)error {
    _onError(error);
}

@end