
#import <Foundation/Foundation.h>

#include <objc/runtime.h>

@interface AppInformation : NSObject

- (NSString *) getAllApps;
- (NSString *) getThirdPartyApps;

@end
