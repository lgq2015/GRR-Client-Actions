// git try

#import "ViewController.h"

@import AssetsLibrary;

@interface ViewController()

- (IBAction)getContactsButton:(UIButton *)sender;
- (IBAction)getDeviceInformationButton:(UIButton *)sender;
- (IBAction)getNetworkInformationButton:(UIButton *)sender;
- (IBAction)getAppsButton:(UIButton *)sender;
- (IBAction)getThirdPartyAppsButton:(UIButton *)sender;
- (IBAction)getCalendarInformationButton:(UIButton *)sender;
- (IBAction)getFotosButton:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UILabel *showContacts;
@property (weak, nonatomic) IBOutlet UILabel *showDeviceInformation;
@property (weak, nonatomic) IBOutlet UILabel *showNetworkInformation;
@property (weak, nonatomic) IBOutlet UILabel *showApps;
@property (weak, nonatomic) IBOutlet UILabel *showCalendarInformation;
@property (weak, nonatomic) IBOutlet UIImageView *showFotos;

@property (weak, nonatomic) IBOutlet UIScrollView *ScrollView;

@property (nonatomic, strong) DeviceInformation *getDeviceInformation;
@property (nonatomic, strong) ContactInformation *getContactInformation;
@property (nonatomic, strong) LocationManager *getLocationInformation;
@property (nonatomic, strong) NetworkInformation *getNetworkInformation;
@property (nonatomic, strong) AppInformation *getAppInformation;
@property (nonatomic, strong) MessagesInformation *getMessages;
@property (nonatomic, strong) CalendarInformation *getCalendarInformation;
@property (nonatomic, strong) Multimedia *getMedia;
@property (nonatomic, strong) PhoneBookInformation *getPBInformation;
@property (nonatomic, strong) NotesInformation *getNotesInformation;
@property (nonatomic, strong) Misc *getMisc;

@property (nonatomic, strong) Networking *startNetworking;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _getDeviceInformation = [[DeviceInformation alloc]init];
    _getContactInformation = [[ContactInformation alloc]init];
    _getLocationInformation = [[LocationManager alloc]init];
    _getNetworkInformation = [[NetworkInformation alloc]init];
    _getAppInformation = [[AppInformation alloc]init];
    _getMessages = [[MessagesInformation alloc]init];
    _getCalendarInformation = [[CalendarInformation alloc]init];
    _getMedia = [[Multimedia alloc]init];
    _getPBInformation = [[PhoneBookInformation alloc]init];
    _getNotesInformation = [[NotesInformation alloc]init];
    _getMisc = [[Misc alloc]init];
    
    _startNetworking = [[Networking alloc]init];
}


-(void)viewDidLayoutSubviews
{
    // height of app UI @ scrolling
    _ScrollView.contentSize = CGSizeMake(0, 2000);
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)getContactsButton:(UIButton *)sender
{
    CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    if (status == CNAuthorizationStatusDenied || status == CNAuthorizationStatusRestricted)
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"This app previously was refused permissions to contacts; Please go to settings and grant permission to this app so it can use contacts" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alert animated:TRUE completion:nil];
        return;
    }
    
    NSString *contactsInformation = @"";
    
    // get all names
    NSString *contactNames = @"";
    contactNames = [_getContactInformation getContactNames];
    NSLog(@"contactNames: %@", contactNames);
    
    // get all names with phonenumber
    
    NSString *contactNamesWithPhonenumber = @"";
    contactNamesWithPhonenumber = [_getContactInformation getContactNamesAndPhonenumber];
    contactsInformation = [contactsInformation stringByAppendingString:[NSString stringWithFormat: @"%@", contactNamesWithPhonenumber]];
    NSLog(@"contactNames/wPhonenumber: %@", contactNamesWithPhonenumber);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.showContacts.text = contactsInformation;
    });
}


- (IBAction)getDeviceInformationButton:(UIButton *)sender
{
    if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied)
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"This app previously was refused permissions to location service; Please go to settings and grant permission to this app so it can use location service" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault  handler:nil]];
        [self presentViewController:alert animated:TRUE completion:nil];
    }
    
    NSString *deviceInformation = @"";
    
    // time
    [_getMisc getCurrentTime];
    
    // get device model
    NSString *deviceModel = @"";
    deviceModel = [_getDeviceInformation getDeviceModel];
    deviceInformation = [deviceInformation stringByAppendingString:[NSString stringWithFormat: @"device: %@\n", deviceModel]];
    NSLog(@"device: %@", deviceModel);
    
    // name identifying the device
    NSString *deviceName = [_getDeviceInformation getDeviceName];
    deviceInformation = [deviceInformation stringByAppendingString:[NSString stringWithFormat: @"name: %@\n", deviceName]];
    NSLog(@"name: %@", deviceName);
    
    // current version of the operating system
    NSString *systemVersion = [_getDeviceInformation getSystemVersion];
    deviceInformation = [deviceInformation stringByAppendingString:[NSString stringWithFormat: @"systemversion: %@\n", systemVersion]];
    NSLog(@"systemVersion: %@", systemVersion);
    
    // get gps informations
    NSString *isGPSActivated = [_getLocationInformation getGPSInformation];
    deviceInformation = [deviceInformation stringByAppendingString:[NSString stringWithFormat: @"GPS activated %@\n", isGPSActivated]];
    NSLog(@"GPS activated: %@", isGPSActivated);
    
    // only get if location service enabled
    if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusAuthorizedWhenInUse || [CLLocationManager authorizationStatus]==kCLAuthorizationStatusAuthorizedAlways)
    {
        // get gps coordinates
        NSString *gpsCoordinates = @"";
        gpsCoordinates = [_getLocationInformation getGPSCoordinates];
        deviceInformation = [deviceInformation stringByAppendingString:[NSString stringWithFormat: @"GPS coordinates: %@\n", gpsCoordinates]];
        NSLog(@"GPS coordinates: %@", gpsCoordinates);
        
        /*
        // get full location
        NSString *fullLocation = [_getLocationInformation getFullLocation];
        deviceInformation = [deviceInformation stringByAppendingString:[NSString stringWithFormat: @"%@\n", fullLocation]];
        NSLog(@"full location: %@", fullLocation);
        */
    }
    
    // get apple identifier for advertisers (IDFA)
    NSString *appleIDFA = [_getDeviceInformation getAppleIDFA];
    deviceInformation = [deviceInformation stringByAppendingString:[NSString stringWithFormat: @"Apple IDFA: %@\n", appleIDFA]];
    NSLog(@"Apple IDFA: %@", appleIDFA);
    
    // get UDID
    NSString *UDID = [_getDeviceInformation getUUID];
    deviceInformation = [deviceInformation stringByAppendingString:[NSString stringWithFormat: @"Apple UUID: %@\n", UDID]];
    NSLog(@"Apple UUID: %@", UDID);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.showDeviceInformation.text = deviceInformation;
    });
}


- (IBAction)getNetworkInformationButton:(UIButton *)sender
{
    NSString *networkInformation = @"";
    
    // log all ip addresses
    [_getNetworkInformation getIPAddress:YES];
    
    // get ip of gateway from webservice
    NSString *ipAddressGateway = [_getNetworkInformation getIPFromWebservice];
    networkInformation = [networkInformation stringByAppendingString:[NSString stringWithFormat: @"ip address gateway: %@\n", ipAddressGateway]];
    NSLog(@"ip address gateway: %@", ipAddressGateway);
    
    // get mac address
    NSString *macAddress = [_getNetworkInformation getMacAddress];
    networkInformation = [networkInformation stringByAppendingString:[NSString stringWithFormat: @"mac address: %@\n", macAddress]];
    NSLog(@"mac address: %@", macAddress);
    
    // get ip address of device
    NSString *ipAddressDevice = [_getNetworkInformation getIPAddressOfDevice];
    networkInformation = [networkInformation stringByAppendingString:[NSString stringWithFormat: @"ip address device: %@\n", ipAddressDevice]];
    NSLog(@"ip address device: %@", ipAddressDevice);
    
    // get SSID
    NSString *SSID = [_getNetworkInformation getSSID];
    networkInformation = [networkInformation stringByAppendingString:[NSString stringWithFormat: @"SSID: %@\n", SSID]];
    NSLog(@"SSID: %@", SSID);
    
    // get carrier name
    NSString *carrierName = [_getNetworkInformation getCarrier];
    networkInformation = [networkInformation stringByAppendingString:[NSString stringWithFormat: @"carrier name: %@\n", carrierName]];
    NSLog(@"carrier name: %@", carrierName);

    // get bluetooth status
    NSString *bluetoothStatus = [_getNetworkInformation getBluetoothStatus];
    networkInformation = [networkInformation stringByAppendingString:[NSString stringWithFormat: @"bluetoothstatus: %@\n", bluetoothStatus]];
    NSLog(@"bluetoothstatus: %@", bluetoothStatus);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.showNetworkInformation.text = networkInformation;
    });
}

- (IBAction)getAppsButton:(UIButton *)sender
{
    NSString *appInformation = @"";
    
    // get list of apps
    NSString *listOfApps = [_getAppInformation getAllApps];
    appInformation = [appInformation stringByAppendingString:[NSString stringWithFormat: @"all apps: %@\n", listOfApps]];
    NSLog(@"all apps: %@\n", listOfApps);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.showApps.text = appInformation;
    });
}

- (IBAction)getThirdPartyAppsButton:(UIButton *)sender
{
     NSString *appInformation = @"";
    
    //get list of third party apps
    NSString *listOfThirdPartyApps = [_getAppInformation getThirdPartyApps];
    appInformation = [appInformation stringByAppendingString:[NSString stringWithFormat: @"third party apps: %@\n", listOfThirdPartyApps]];
    NSLog(@"third party apps: %@\n", listOfThirdPartyApps);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.showApps.text = appInformation;
    });
}

- (IBAction)getCalendarInformationButton:(UIButton *)sender
{
    EKAuthorizationStatus authorizationStatus = [EKEventStore authorizationStatusForEntityType:EKEntityTypeEvent];
    
    if (authorizationStatus == EKAuthorizationStatusDenied)
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"This app previously was refused permissions to calendar; Please go to settings and grant permission to this app so it can use calendar" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alert animated:TRUE completion:nil];
        return;
    }
    
    NSString *calendarInformation = @"";
    
    //get array of all events
    NSString *getEvents = [_getCalendarInformation getCalendar];
    calendarInformation = [calendarInformation stringByAppendingString:[NSString stringWithFormat: @"all events: %@\n", getEvents]];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.showCalendarInformation.text = calendarInformation;
    });
}

- (IBAction)getFotosButton:(UIButton *)sender
{
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status != PHAuthorizationStatusAuthorized)
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"This app previously was refused permissions to media; Please go to settings and grant permission to this app so it can use media" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alert animated:TRUE completion:nil];
        return;
    }
    
    [_getMedia getAllAudio];
    [_getMedia getAllVideos];
    [_getMedia getAllImages];
    
    PHAsset *lastImageAsset = [_getMedia getRandomImage];
    
    [[PHImageManager defaultManager]requestImageForAsset:lastImageAsset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeDefault options:nil resultHandler:^(UIImage *result, NSDictionary *info){
        if ([info objectForKey:PHImageErrorKey] == nil && ![[info objectForKey:PHImageResultIsDegradedKey] boolValue]) {
            [self.showFotos setImage:result];
        }
    }];    
}


@end
