//
//  Created by aistomin on 1/19/12.
//
//


#import "FacebookControllerDelegate.h"
#import "ViewController.h"


@implementation FacebookControllerDelegate {
    ViewController *_viewController;
}
- (void)fbDidLogin {
    LOG(@"Facebook user did login");
    [_viewController onFacebookLoginSuccess];

}

- (void)fbDidNotLogin:(BOOL)cancelled {
    LOG(@"Facebook user did NOT login");
    [_viewController onFacebookLoginFailed];

}

- (void)fbDidLogout {
    LOG(@"Facebook user logout");
    [_viewController onFacebookLogout];
}

- (void)fbSessionInvalidated {
    LOG(@"Facebook session invalidated");
    [_viewController onFacebookSessionInvalidated];

}

- (void)request:(FBRequest *)request didReceiveResponse:(NSURLResponse *)response {
    LOG(@"Facebook response was received. URL @", [response URL]);
}

- (void)request:(FBRequest *)request didLoad:(id)result {
    if ([result isKindOfClass:[NSArray class]]) {
        result = [result objectAtIndex:0];
    }
    if ([result isKindOfClass:[NSDictionary class]]) {
        id userName = [result objectForKey:@"name"];
        LOG(@"Facebook Name: %@", userName);
        [_viewController showFacebookUsername:userName];
    }
}

- (FacebookControllerDelegate *)initWithController:(ViewController *)controller {
    self = [super init];
    if (self) {
        _viewController = [controller retain];
    }
    return (self);

}

- (void)dealloc {
    [_viewController release];
    [super dealloc];
}
@end