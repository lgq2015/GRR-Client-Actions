
#import "NetworkInformation.h"

@interface NetworkInformation() <CBCentralManagerDelegate>

@property (nonatomic) CBCentralManager *bluetoothManager;
@property (nonatomic, strong) NSString *bluetoothStatus;
@property (nonatomic, strong) NSDictionary *json;

@end

@implementation NetworkInformation
- (instancetype)init
{
    self = [super init];
    if (self) {
        _bluetoothManager = [[CBCentralManager alloc] initWithDelegate:self
                                                                 queue:nil
                                                               options:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:0]
                                                                                                   forKey:CBCentralManagerOptionShowPowerAlertKey]];
    }
    return self;
}

#define IOS_CELLULAR    @"pdp_ip0"
#define IOS_WIFI        @"en0"
#define IOS_VPN         @"utun0"
#define IP_ADDR_IPv4    @"ipv4"
#define IP_ADDR_IPv6    @"ipv6"

- (NSString *) getIPAddress:(BOOL)preferIPv4
{
    NSArray *searchArray = preferIPv4 ?
    @[ IOS_VPN @"/" IP_ADDR_IPv4, IOS_VPN @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6 ] :
    @[ IOS_VPN @"/" IP_ADDR_IPv6, IOS_VPN @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4 ] ;
    
    NSDictionary *addresses = [self getIPAddresses];
    NSLog(@"addresses: %@", addresses);
    
    __block NSString *address;
    [searchArray enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop)
     {
         address = addresses[key];
         if(address) *stop = YES;
     } ];
    return address ? address : @"0.0.0.0";
}


- (NSDictionary *) getIPAddresses
{
    NSMutableDictionary *addresses = [NSMutableDictionary dictionaryWithCapacity:8];
    
    // Retrieve the current interfaces - returns 0 on success
    struct ifaddrs *interfaces;
    if(!getifaddrs(&interfaces)) {
        // Loop through linked list of interfaces
        struct ifaddrs *interface;
        for(interface=interfaces; interface; interface=interface->ifa_next) {
            if(!(interface->ifa_flags & IFF_UP) /* || (interface->ifa_flags & IFF_LOOPBACK) */ ) {
                continue; // deeply nested code harder to read
            }
            const struct sockaddr_in *addr = (const struct sockaddr_in*)interface->ifa_addr;
            char addrBuf[ MAX(INET_ADDRSTRLEN, INET6_ADDRSTRLEN) ];
            if(addr && (addr->sin_family==AF_INET || addr->sin_family==AF_INET6)) {
                NSString *name = [NSString stringWithUTF8String:interface->ifa_name];
                NSString *type;
                if(addr->sin_family == AF_INET) {
                    if(inet_ntop(AF_INET, &addr->sin_addr, addrBuf, INET_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv4;
                    }
                } else {
                    const struct sockaddr_in6 *addr6 = (const struct sockaddr_in6*)interface->ifa_addr;
                    if(inet_ntop(AF_INET6, &addr6->sin6_addr, addrBuf, INET6_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv6;
                    }
                }
                if(type) {
                    NSString *key = [NSString stringWithFormat:@"%@/%@", name, type];
                    addresses[key] = [NSString stringWithUTF8String:addrBuf];
                }
            }
        }
        // Free memory
        freeifaddrs(interfaces);
    }
    return [addresses count] ? addresses : nil;
}


//- (NSString *) getIPFromWebservice
//{
//    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
//    NSString *dataIP = @"http://ipof.in/json";
//    NSURL *url = [NSURL URLWithString:dataIP];
//    
//    NSURLRequest *request = [NSURLRequest requestWithURL:url];
//    NSURLSession *session = [NSURLSession sharedSession];
//    
//    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//        if (data)
//        {
//            _json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
//            dispatch_semaphore_signal(semaphore);
//        }
//        else
//        {
//            NSLog(@"error: %@", error);
//        }
//        
//    }];
//    [task resume];
//    
//    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
//    
//    return _json[@"ip"];
//}


- (NSString *) getIPFromWebservice
{
    NSURL *urlIPof = [NSURL URLWithString:@"https://api.ipify.org"];
    NSString *urlContentIPof = [NSString stringWithContentsOfURL:urlIPof
                                                 encoding:NSASCIIStringEncoding
                                                    error:nil];
    return urlContentIPof;
}

// Hardcoded, settings/general/about
- (NSString *) getMacAddressBluetooth
{
    // NSLog(@"hardcoded");
    return @"AC:29:**:**:**:9B";
}

// Hardcoded, settings/general/about
- (NSString *) getMacAddress
{
    // NSLog(@"hardcoded");
    return @"AC:29:**:**:**:9A";
}

#define IS_OS_7_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)

// Only for systemversion < 7.0
- (NSString *) getMacAddressOutdated
{
    if(IS_OS_7_OR_LATER)
        return @"not accessible under 7.0 and later";
    int                 mgmtInfoBase[6];
    char                *msgBuffer = NULL;
    NSString            *errorFlag = NULL;
    size_t              length;
    
    // Setup the management Information Base (mib)
    mgmtInfoBase[0] = CTL_NET;        // Request network subsystem
    mgmtInfoBase[1] = AF_ROUTE;       // Routing table info
    mgmtInfoBase[2] = 0;
    mgmtInfoBase[3] = AF_LINK;        // Request link layer information
    mgmtInfoBase[4] = NET_RT_IFLIST;  // Request all configured interfaces
    
    // With all configured interfaces requested, get handle index
    if ((mgmtInfoBase[5] = if_nametoindex("en0")) == 0)
        errorFlag = @"if_nametoindex failure";
    // Get the size of the data available (store in len)
    else if (sysctl(mgmtInfoBase, 6, NULL, &length, NULL, 0) < 0)
        errorFlag = @"sysctl mgmtInfoBase failure";
    // Alloc memory based on above call
    else if ((msgBuffer = malloc(length)) == NULL)
        errorFlag = @"buffer allocation failure";
    // Get system information, store in buffer
    else if (sysctl(mgmtInfoBase, 6, msgBuffer, &length, NULL, 0) < 0)
    {
        free(msgBuffer);
        errorFlag = @"sysctl msgBuffer failure";
    }
    else
    {
        // Map msgbuffer to interface message structure
        struct if_msghdr *interfaceMsgStruct = (struct if_msghdr *) msgBuffer;
        
        // Map to link-level socket structure
        struct sockaddr_dl *socketStruct = (struct sockaddr_dl *) (interfaceMsgStruct + 1);
        
        // Copy link layer address data in socket structure to an array
        unsigned char macAddress[6];
        memcpy(&macAddress, socketStruct->sdl_data + socketStruct->sdl_nlen, 6);
        
        // Read from char array into a string object, into traditional Mac address format
        NSString *macAddressString = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X",
                                      macAddress[0], macAddress[1], macAddress[2], macAddress[3], macAddress[4], macAddress[5]];
        if(YES) NSLog(@"mac address: %@", macAddressString);
        
        // Release the buffer memory
        free(msgBuffer);
        
        return macAddressString;
    }
    
    // Error...
    if(YES) NSLog(@"error: %@", errorFlag);
    
    return errorFlag;
}


- (NSString *) getIPAddressOfDevice
{
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0)
    {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL)
        {
            if(temp_addr->ifa_addr->sa_family == AF_INET)
            {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"])
                {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    
    // Free memory
    freeifaddrs(interfaces);
    return address;
}


- (NSString *) getSSID
{
    NSArray *ifs = (__bridge_transfer NSArray *)CNCopySupportedInterfaces();
    NSDictionary *info;
    for (NSString *ifnam in ifs) {
        info = (__bridge_transfer NSDictionary *)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        if (info && [info count]) { break; }
    }
    NSString *SSID = [info valueForKey:@"SSID"];
    return SSID;
}


- (NSString*) getBluetoothStatus
{
    return _bluetoothStatus;
}

 
- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    switch(_bluetoothManager.state)
    {
        case CBCentralManagerStatePoweredOn: _bluetoothStatus = @"bluetooth on"; break;
        case CBCentralManagerStatePoweredOff: _bluetoothStatus = @"bluetooth off"; break;
        default: _bluetoothStatus = @"bluetooth unkown"; break;
    }
}


- (NSString *) getCarrier
{
    /* Alternativ:
     NSBundle *b = [NSBundle bundleWithPath:@"System/Library/PrivateFrameworks/FTServices.framework"];
     BOOL success = [b load];
     
     NSLog(@"done loading priv api: %@", success ? @"YES" : @"NO");
     
     Class FTDeviceSupport = NSClassFromString(@"FTDeviceSupport");
     id si = [FTDeviceSupport valueForKey:@"sharedInstance"];
     
     NSLog(@"MNC %@", [si valueForKey:@"CTNetworkInformation"]);
    */  
    
    CTTelephonyNetworkInfo *netinfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [netinfo subscriberCellularProvider];
    /* In case name not listed in sim: http://en.wikipedia.org/wiki/Mobile_country_code
     NSLog(@"mobile network code: %@", [carrier mobileNetworkCode]);
     NSLog(@"mobile country code: %@", [carrier mobileCountryCode]);
     */
    NSString *carrierName = [carrier carrierName];
    
    return carrierName;
}

@end
