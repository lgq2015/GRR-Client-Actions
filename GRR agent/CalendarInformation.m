
#import "CalendarInformation.h"



@implementation CalendarInformation

- (NSString *) getCalendar
{   
    EKEventStore *store = [[EKEventStore alloc] init];
    
    [store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {

        NSCalendar *calendar = [NSCalendar currentCalendar];
        
        // start
        NSDateComponents *oneYearAgoComponents = [[NSDateComponents alloc] init];
        oneYearAgoComponents.year = -1;
        NSDate *oneYearAgo = [calendar dateByAddingComponents:oneYearAgoComponents
                                                      toDate:[NSDate date]
                                                     options:0];
        
        // end
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
    }];
    
    return @"see console log";
}

@end
