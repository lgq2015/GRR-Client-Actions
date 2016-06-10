
#import <Foundation/Foundation.h>
#import <sys/utsname.h>
#import <UIKit/UIKit.h>
#import <AdSupport/ASIdentifierManager.h>

// private apis:
#import "UIDevice+Extensions.h"
#import "UIDevice+serialNumber.h"

@interface DeviceInformation : NSObject

- (NSString *) getDeviceModel;
- (NSString *) getDeviceName;
- (NSString *) getSystemVersion;
- (NSString *) getAppleIDFA;
- (NSString *) getUUID;
- (NSString *) getIMEI;
- (NSString *) getUDID;
- (NSString *) getSerialNumber;
- (NSString *) getBatteryID;
- (NSString *) getDieID;

@end
