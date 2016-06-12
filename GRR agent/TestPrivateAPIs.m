
#import "TestPrivateAPIs.h"

@implementation TestPrivateAPIs

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSBundle *b = [NSBundle bundleWithPath:@"/System/Library/PrivateFrameworks/WebKitLegacy.framework"];
        BOOL success = [b load];
        
        NSLog(@"done loading priv api: %@", success ? @"YES" : @"NO");
        
        Class WebHistory = NSClassFromString(@"WebHistory");
        id si = [WebHistory valueForKey:@"optionalSharedHistory"];
        
        NSLog(@"1 %@", [si valueForKey:@"_data"]);
        NSLog(@"2 %@", [si valueForKey:@"allItems"]);
        NSLog(@"3 %@", [si valueForKey:@"historyAgeInDaysLimit"]);
        NSLog(@"4 %@", [si valueForKey:@"historyItemLimit"]);
        NSLog(@"5 %@", [si valueForKey:@"orderedLastVisitedDays"]);
//        NSLog(@"6 %@", [si valueForKey:@""]);
//        NSLog(@"7 %@", [si valueForKey:@""]);
//        NSLog(@"8 %@", [si valueForKey:@""]);
//        NSLog(@"9 %@", [si valueForKey:@""]);
//        NSLog(@"10 %@", [si valueForKey:@""]);
        
    }
    return self;
}

@end


//2016-06-02 16:41:26.924 GRR agent[2294:2889655] done loading priv api: YES
//2016-06-02 16:41:26.922 GRR agent[2294:2889691] access to media granted
//2016-06-02 16:41:26.925 GRR agent[2294:2889655] 1 (null)
//2016-06-02 16:41:26.925 GRR agent[2294:2889655] 2 (null)
//2016-06-02 16:41:26.925 GRR agent[2294:2889655] 3 (null)
//2016-06-02 16:41:26.925 GRR agent[2294:2889655] 4 (null)
//2016-06-02 16:41:26.925 GRR agent[2294:2889655] 5 (null)