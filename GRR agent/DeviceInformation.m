
#import "DeviceInformation.h"

@implementation DeviceInformation

- (NSString *) getDeviceModel
{
    struct utsname systemInfo;
    uname(&systemInfo);
    
    NSString* code = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    static NSDictionary* deviceNamesByCode = nil;
    
    if (!deviceNamesByCode) {
        
        // https://www.theiphonewiki.com/wiki/Models
        
        deviceNamesByCode = @{@"i386"      :@"Simulator",
                              @"x86_64"    :@"Simulator",
                              
                              @"iPhone1,1" :@"iPhone A1203",
                              @"iPhone1,2" :@"iPhone 3G A1241 A1324",
                              @"iPhone2,1" :@"iPhone 3GS A1303 A1325",
                              @"iPhone3,1" :@"iPhone 4 A1332",
                              @"iPhone3,2" :@"iPhone 4 A1332",
                              @"iPhone3,3" :@"iPhone 4 A1349",
                              @"iPhone4,1" :@"iPhone 4S A1387 A1431",
                              @"iPhone5,1" :@"iPhone 5 A1428",
                              @"iPhone5,2" :@"iPhone 5 A1429 A1442",
                              @"iPhone5,3" :@"iPhone 5c A1456 A1532",
                              @"iPhone5,4" :@"iPhone 5c A1507 A1516 A1526 A1529",
                              @"iPhone6,1" :@"iPhone 5s A1453 A1533",
                              @"iPhone6,2" :@"iPhone 5s A1457 A1518 A1528 A1530",
                              @"iPhone7,2" :@"iPhone 6 A1549 A1586 A1589",
                              @"iPhone7,1" :@"iPhone 6 Plus A1522 A1524 A1593",
                              @"iPhone8,1" :@"iPhone 6S A1633 A1688 A1691 A1700",
                              @"iPhone8,2" :@"iPhone 6S Plus A1634 A1687 A1690 A1699",
                              @"iPhone8,4" :@"iPhone SE A1662 A1723 A1724",
                              
                              @"iPad1,1"   :@"iPad A1219 A1337",
                              @"iPad2,1"   :@"iPad 2 A1395",
                              @"iPad2,2"   :@"iPad 2 A1396",
                              @"iPad2,3"   :@"iPad 2 A1397",
                              @"iPad2,4"   :@"iPad 2 A1395",
                              @"iPad3,1"   :@"iPad 3 A1416",
                              @"iPad3,2"   :@"iPad 3 A1403",
                              @"iPad3,3"   :@"iPad 3 A1430",
                              @"iPad3,4"   :@"iPad 4 A1458",
                              @"iPad3,5"   :@"iPad 4 A1459",
                              @"iPad3,6"   :@"iPad 4 A1460",
                              @"iPad4,1"   :@"iPad Air A1474",
                              @"iPad4,2"   :@"iPad Air A1475",
                              @"iPad4,3"   :@"iPad Air A1476",
                              @"iPad5,3"   :@"iPad Air 2 A1566",
                              @"iPad5,4"   :@"iPad Air 2 A1567",
                              @"iPad6,3"   :@"iPad Pro (9.7 inch) A1673",
                              @"iPad6,4"   :@"iPad Pro (9.7 inch) A1647 A1675",
                              @"iPad6,7"   :@"iPad Pro (12.9 inch) A1584",
                              @"iPad6,8"   :@"iPad Pro (12.9 inch) A1652",
                              
                              @"iPad2,5"   :@"iPad Mini A1432",
                              @"iPad2,6"   :@"iPad Mini A1454",
                              @"iPad2,7"   :@"iPad Mini A1455",
                              @"iPad4,4"   :@"iPad Mini 2 A1489",
                              @"iPad4,5"   :@"iPad Mini 2 A1490",
                              @"iPad4,6"   :@"iPad Mini 2 A1491",
                              @"iPad4,7"   :@"iPad Mini 3 A1599",
                              @"iPad4,8"   :@"iPad Mini 3 A1600",
                              @"iPad4,9"   :@"iPad Mini 3 A1601",
                              @"iPad5,1"   :@"iPad Mini 4 A1538",
                              @"iPad5,2"   :@"iPad Mini 4 A1550"
                              };
    }
    
    NSString *deviceName = [deviceNamesByCode objectForKey:code];
    
    if (!deviceName) {
        
        deviceName = @"Device not found in list";
        
        /*
         if([code rangeOfString:@"iPad"].location != NSNotFound) {
         deviceName = @"iPad";
         }
         else if([code rangeOfString:@"iPhone"].location != NSNotFound){
         deviceName = @"iPhone";
         }
         else {
         deviceName = @"Device unknown";
         }
         */
    }
    return deviceName;
}


- (NSString *) getDeviceName
{
    return [[UIDevice currentDevice] name];
}

// http://stackoverflow.com/questions/25490229/what-exactly-is-a-die-id

- (NSString *) getDieID
{
    NSLog(@"dieID: %@", [[UIDevice currentDevice] dieID]);
    return [[UIDevice currentDevice] dieID];
}

- (NSString *) getBatteryID
{
    NSLog(@"battery ID: %@", [[UIDevice currentDevice] batteryID]);
    return [[UIDevice currentDevice] batteryID];
}

- (NSString *) getSerialNumber
{
    NSLog(@"serial: %@", [[UIDevice currentDevice] serialNumber]);
    return [[UIDevice currentDevice] serialNumber];
}

- (NSString *) getSystemVersion
{
    return [[UIDevice currentDevice] systemVersion];
}

- (NSString *) getUUID
{
    return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
}


- (NSString *) getAppleIDFA
{
    return [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
}

@end
