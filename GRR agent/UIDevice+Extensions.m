
#import "UIDevice+Extensions.h"

@implementation UIDevice (Extensions)

- (NSString *)dieID {
    void *libMobileGestalt = dlopen("/usr/lib/libMobileGestalt.dylib", RTLD_LAZY);
    NSParameterAssert(libMobileGestalt);
    
    CFStringRef (*MGCopyAnswer)(CFStringRef string) = dlsym(libMobileGestalt, "MGCopyAnswer");
    NSParameterAssert(MGCopyAnswer);
    
    CFStringRef dieID = MGCopyAnswer(kMGDieID);
    NSString *dieIDString = (__bridge NSString *)dieID;
    
    CFRelease(dieID);
    dlclose(libMobileGestalt);
    
    return dieIDString;
}

/* Only available on iOS 8+ */
- (NSString *)batteryID {
    void *IOKit = dlopen("/System/Library/Frameworks/IOKit.framework/Versions/A/IOKit", RTLD_LAZY);
    NSParameterAssert(IOKit);
    
    mach_port_t *kIOMasterPortDefault = dlsym(IOKit, "kIOMasterPortDefault");
    NSParameterAssert(kIOMasterPortDefault);
    CFMutableDictionaryRef (*IOServiceNameMatching)(const char *name) = dlsym(IOKit, "IOServiceNameMatching");
    NSParameterAssert(IOServiceNameMatching);
    mach_port_t (*IOServiceGetMatchingService)(mach_port_t masterPort, CFDictionaryRef matching) = dlsym(IOKit, "IOServiceGetMatchingService");
    NSParameterAssert(IOServiceGetMatchingService);
    kern_return_t (*IORegistryEntryCreateCFProperties)(mach_port_t entry, CFMutableDictionaryRef *properties, CFAllocatorRef allocator, UInt32 options) = dlsym(IOKit, "IORegistryEntryCreateCFProperties");
    NSParameterAssert(IORegistryEntryCreateCFProperties);
    kern_return_t (*IOObjectRelease)(mach_port_t object) = dlsym(IOKit, "IOObjectRelease");
    NSParameterAssert(IOObjectRelease);
    
    CFMutableDictionaryRef properties = NULL;
    
    mach_port_t service = IOServiceGetMatchingService(*kIOMasterPortDefault, IOServiceNameMatching("charger"));
    IORegistryEntryCreateCFProperties(service, &properties, kCFAllocatorDefault, 0);
    
    IOObjectRelease(service);
    service = 0;
    
    NSDictionary *dictionary = (__bridge NSDictionary *)properties;
    NSData *batteryIDData = [dictionary objectForKey:@"battery-id"];
    
    CFRelease(properties);
    properties = NULL;
    
    dlclose(IOKit);
    
    return [NSString stringWithUTF8String:[batteryIDData bytes]];
}

/* You could use self.traitCollection.forceTouchCapability, but this is more reliable in my opinion. It also can detect if the user has disabled the option in Settings. */
- (BOOL)forceTouchIsAvailableAndEnabled {
    void *AccessibilityUtilities = dlopen("/System/Library/PrivateFrameworks/AccessibilityUtilities.framework/AccessibilityUtilities", RTLD_LAZY);
    NSParameterAssert(AccessibilityUtilities);
    
    BOOL (*AXForceTouchAvailableAndEnabled)(void) = dlsym(AccessibilityUtilities, "AXForceTouchAvailableAndEnabled");
    NSParameterAssert(AXForceTouchAvailableAndEnabled);
    
    dlclose(AccessibilityUtilities);
    
    return AXForceTouchAvailableAndEnabled();
}

/* Useful if you'd like to get the orientation of the device while outside of the app! */
- (BKSInterfaceOrientation)currentOrientation {
    void *BackBoardServices = dlopen("/System/Library/PrivateFrameworks/BackBoardServices.framework/BackBoardServices", RTLD_LAZY);
    NSParameterAssert(BackBoardServices);
    
    BKSInterfaceOrientation (*BKHIDServicesGetNonFlatDeviceOrientation)(void) = dlsym(BackBoardServices, "BKHIDServicesGetNonFlatDeviceOrientation");
    NSParameterAssert(BKHIDServicesGetNonFlatDeviceOrientation);
    
    dlclose(BackBoardServices);
    
    return BKHIDServicesGetNonFlatDeviceOrientation();
}

- (BOOL)cellularDataIsEnabled {
    void *CoreTelephony = dlopen("/System/Library/Frameworks/CoreTelephony.framework/CoreTelephony", RTLD_LAZY);
    NSParameterAssert(CoreTelephony);
    
    BOOL (*CTRegistrationGetCellularDataIsEnabled)(void) = dlsym(CoreTelephony, "CTRegistrationGetCellularDataIsEnabled");
    NSParameterAssert(CTRegistrationGetCellularDataIsEnabled);
    
    dlclose(CoreTelephony);
    
    return CTRegistrationGetCellularDataIsEnabled();
}

@end