
#import <Foundation/Foundation.h>

#include <ifaddrs.h>
#include <arpa/inet.h>
#include <net/if.h>
#include <sys/socket.h>
#include <sys/sysctl.h>
#include <net/if_dl.h>

#import <UIKit/UIKit.h>
#import <SystemConfiguration/CaptiveNetwork.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>

@interface NetworkInformation : NSObject 

- (NSString *) getIPFromWebservice;
- (NSString *) getIPAddress:(BOOL)preferIPv4;
- (NSString *) getMacAddress;
- (NSString *) getIPAddressOfDevice;
- (NSString *) getSSID;
- (NSString *) getBluetoothStatus;
- (NSString *) getCarrier;
- (NSString *) getMacAddressOutdated;

@end
