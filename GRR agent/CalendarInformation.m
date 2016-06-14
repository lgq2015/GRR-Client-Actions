
#import "CalendarInformation.h"

@implementation CalendarInformation

- (instancetype)init
{
    self = [super init];
    if (self) {
        EKEventStore *store = [[EKEventStore alloc] init];        
        [store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
            if (!granted)
            {
                NSLog(@"no access to calendar");
            }
            else
            {
                NSLog(@"access to calendar granted");
            }
        }];
    }
    return self;
}

- (NSString *) getCalendar
{   
    EKEventStore *store = [[EKEventStore alloc] init];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    // Start date
    NSDateComponents *oneYearAgoComponents = [[NSDateComponents alloc] init];
    oneYearAgoComponents.year = -1;
    NSDate *oneYearAgo = [calendar dateByAddingComponents:oneYearAgoComponents
                                                   toDate:[NSDate date]
                                                  options:0];
    
    // End date
    NSDateComponents *oneYearFromNowComponents = [[NSDateComponents alloc] init];
    oneYearFromNowComponents.year = 1;
    NSDate *oneYearFromNow = [calendar dateByAddingComponents:oneYearFromNowComponents
                                                       toDate:[NSDate date]
                                                      options:0];
    
    // Create the predicate from the event store's instance method
    NSPredicate *predicate = [store predicateForEventsWithStartDate:oneYearAgo
                                                            endDate:oneYearFromNow
                                                          calendars:nil];
    
    // Fetch all events that match the predicate
    NSArray *events = [store eventsMatchingPredicate:predicate];
    
    for(NSString *string in events)
    {
        NSLog(@"%@", string);
    }
    
    return @"see console log";
}

@end
