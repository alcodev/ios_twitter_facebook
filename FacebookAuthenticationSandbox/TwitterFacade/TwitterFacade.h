//
//  Created by aistomin on 1/18/12.
//
//


#import <Foundation/Foundation.h>

@protocol MGTwitterEngineDelegate;


@interface TwitterFacade : NSObject
- (id)initWithTwitterEngineDelegate:(NSObject <MGTwitterEngineDelegate> *)delegate;

- (void)login;

- (void)logout;

- (void)getUserInformationFor:(NSString *)string;
@end