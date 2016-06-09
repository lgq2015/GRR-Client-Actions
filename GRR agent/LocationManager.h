
#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface LocationManager : NSObject 

- (NSString *) getGPSInformation;
- (NSString *) getGPSCoordinates;
- (NSString *) getFullLocation;

@end
