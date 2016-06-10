
#import "Misc.h"

@implementation Misc

- (NSString *) getCurrentTime
{
    NSDate *now = [NSDate date];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"hh:mm:ss";
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    
    NSString *time = [dateFormatter stringFromDate:now];
    NSLog(@"Current time: %@", time);
    
    return time;
}

- (NSString *) getLanguage
{
    NSLog(@"Language: %@", [[NSLocale currentLocale] objectForKey:NSLocaleLanguageCode]);
    return [[NSLocale currentLocale] objectForKey:NSLocaleLanguageCode];
}

- (NSString *) getCountry
{
    NSLog(@"Country: %@", [[NSLocale currentLocale] objectForKey:NSLocaleCountryCode]);
    return [[NSLocale currentLocale] objectForKey:NSLocaleCountryCode];
}

@end
