
#import "LocationManager.h"

@interface LocationManager() <CLLocationManagerDelegate>

@property CLLocationManager *locationManager;
@property CLLocation *currentLocation;

@end

@implementation LocationManager 

- (instancetype)init
{
    self = [super init];
    if (self) {
        _locationManager = [CLLocationManager new];
        _locationManager.delegate = self;
        _locationManager.distanceFilter = kCLDistanceFilterNone;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        // [_locationManager requestAlwaysAuthorization];
        [_locationManager requestWhenInUseAuthorization];
        [_locationManager startUpdatingLocation];
    }
    return self;
}

- (NSString *) getGPSCoordinates
{
    NSString *gpsCoordinates = @"";
    gpsCoordinates = [gpsCoordinates stringByAppendingString:[NSString stringWithFormat: @"longitude: %f, ", _currentLocation.coordinate.longitude]];
    gpsCoordinates = [gpsCoordinates stringByAppendingString:[NSString stringWithFormat: @"latitude: %f", _currentLocation.coordinate.latitude]];
    return gpsCoordinates;
}


- (NSString *) getFullLocation
{
    NSString *fullLocation = [NSString stringWithFormat: @"%@,", _currentLocation];
    return fullLocation;
}


- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    _currentLocation = [locations lastObject];
}


-(NSString *) getGPSInformation
{
    BOOL isGPSActivated = [CLLocationManager locationServicesEnabled];
    return [NSString stringWithFormat: @"%@", isGPSActivated ? @"Yes" : @"No"];
}


@end
