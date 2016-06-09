
#import "ExampleForPrivateAPIIMEI.h"

@implementation ExampleForPrivateAPIIMEI

-(void) getIMEI
{
    NSBundle *b = [NSBundle bundleWithPath:@"/System/Library/PrivateFrameworks/FMCore.framework"];
    BOOL success = [b load];
    
    NSLog(@"done loading priv api: %@", success ? @"YES" : @"NO");
    
    Class FMSystemInfo_ios = NSClassFromString(@"FMSystemInfo_ios");
    id si = [FMSystemInfo_ios valueForKey:@"sharedInstance"];
    
    NSLog(@"deviceClass %@", [si valueForKey:@"deviceClass"]);
    NSLog(@"deviceModelName %@", [si valueForKey:@"deviceModelName"]);
    NSLog(@"deviceName %@", [si valueForKey:@"deviceName"]);
    NSLog(@"deviceUDID %@", [si valueForKey:@"deviceUDID"]);
    NSLog(@"ecid %@", [si valueForKey:@"ecid"]);
    NSLog(@"imei %@", [si valueForKey:@"imei"]);
    NSLog(@"meid %@", [si valueForKey:@"meid"]);
    NSLog(@"osBuildVersion %@", [si valueForKey:@"osBuildVersion"]);
    NSLog(@"osVersion %@", [si valueForKey:@"osVersion"]);
    NSLog(@"ownerAccount %@", [si valueForKey:@"ownerAccount"]);
    NSLog(@"productName %@", [si valueForKey:@"productName"]);
    NSLog(@"productType %@", [si valueForKey:@"productType"]);
    NSLog(@"wifiMacAddress %@", [si valueForKey:@"wifiMacAddress"]);
    NSLog(@"serialNumber %@", [si valueForKey:@"serialNumber"]);
}

//2016-05-07 21:43:34.722 GRR agent[1384:1895688] done loading priv api: YES
//2016-05-07 21:43:34.723 GRR agent[1384:1895688] deviceClass iPhone
//2016-05-07 21:43:34.723 GRR agent[1384:1895688] deviceModelName iPhone
//2016-05-07 21:43:34.740 GRR agent[1384:1895688] deviceName Julians iPhone
//2016-05-07 21:43:34.745 GRR agent[1384:1895688] deviceUDID (null)
//2016-05-07 21:43:34.748 GRR agent[1384:1895688] ecid (null)
//2016-05-07 21:43:34.751 GRR agent[1384:1895688] imei (null)  // <---
//2016-05-07 21:43:34.753 GRR agent[1384:1895688] meid (null)
//2016-05-07 21:43:34.755 GRR agent[1384:1895688] osBuildVersion 13F69
//2016-05-07 21:43:34.755 GRR agent[1384:1895688] osVersion 9.3.2
//2016-05-07 21:43:34.771 GRR agent[1384:1895688] ownerAccount (null)
//2016-05-07 21:43:34.771 GRR agent[1384:1895688] productName iPhone OS
//2016-05-07 21:43:34.771 GRR agent[1384:1895688] productType iPhone6,2
//2016-05-07 21:43:34.774 GRR agent[1384:1895688] wifiMacAddress (null)
//2016-05-07 21:43:34.776 GRR agent[1384:1895688] serialNumber (null)

@end
