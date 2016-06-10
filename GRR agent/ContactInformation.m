
#import "ContactInformation.h"

@interface ContactInformation()

@property (nonatomic, strong) NSString* contactNames;
@property (nonatomic, strong) NSString* contactNamesAndPhonenumber;

@end

@implementation ContactInformation

- (instancetype)init
{
    self = [super init];
    if (self) {
        CNContactStore *store = [[CNContactStore alloc] init];
        [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (!granted)
            {
                NSLog(@"no access to contacts");
            }
            else
            {
                NSLog(@"access to contacts granted");
            }
        }];
    }
    return self;
}

- (void) scanContactsTable
{
    CNEntityType entityType = CNEntityTypeContacts;
    if( [CNContactStore authorizationStatusForEntityType:entityType] == CNAuthorizationStatusNotDetermined) {
        CNContactStore *contactStore = [[CNContactStore alloc] init];
        [contactStore requestAccessForEntityType:entityType completionHandler:^(BOOL granted, NSError *_Nullable error) {
            if(granted){
                [self getAllContacts];
            }
        }];
    }
    else if( [CNContactStore authorizationStatusForEntityType:entityType]== CNAuthorizationStatusAuthorized) {
        [self getAllContacts];
    }
}


- (void) getAllContacts
{
    NSError* contactError;
    CNContactStore *addressBook = [[CNContactStore alloc]init];
    [addressBook containersMatchingPredicate:[CNContainer predicateForContainersWithIdentifiers: @[addressBook.defaultContainerIdentifier]] error:&contactError];
    NSArray *keysToFetch =@[CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey]; // add more stuff to get
    
    __block NSString *firstName;
    __block NSString *lastName;
    __block NSString *phone;
    __block NSString *fullname;
    __block NSString *fullnameAndPhonenumber;
    _contactNames = @"";
    _contactNamesAndPhonenumber = @"";
    
    CNContactFetchRequest *request = [[CNContactFetchRequest alloc]initWithKeysToFetch:keysToFetch];
    [addressBook enumerateContactsWithFetchRequest:request error:&contactError usingBlock:^(CNContact *__nonnull contact, BOOL *__nonnull stop){
        firstName =  contact.givenName;
        lastName =  contact.familyName;
        phone = [[[contact.phoneNumbers valueForKey:@"value"] valueForKey:@"digits"]componentsJoinedByString:@", "];
        if([lastName length] == 0) {
            lastName = @"not set";
            fullname = firstName;
        }
        else {
            fullname = [firstName stringByAppendingString:[NSString stringWithFormat: @" %@", lastName]];
        }
        if([phone length] == 0) {
            phone = @"no phonenumber set";
            fullnameAndPhonenumber = [fullname stringByAppendingString:[NSString stringWithFormat: @" - %@", phone]];
        }
        else {
            fullnameAndPhonenumber = [fullname stringByAppendingString:[NSString stringWithFormat: @" - %@", phone]];
        }
        NSLog(@"firstname: %@", firstName);
        NSLog(@"lastname: %@", lastName);
        NSLog(@"fullname: %@", fullname);
        NSLog(@"phonenumber: %@", phone);
        NSLog(@"fullname and phonenumber: %@", fullnameAndPhonenumber);
        _contactNames = [_contactNames stringByAppendingString:[NSString stringWithFormat: @", %@", fullname]];
        _contactNamesAndPhonenumber = [_contactNamesAndPhonenumber stringByAppendingString:[NSString stringWithFormat: @", %@", fullnameAndPhonenumber]];
    }];
    
    _contactNames = [_contactNames substringFromIndex:2];
    _contactNamesAndPhonenumber = [_contactNamesAndPhonenumber substringFromIndex:2];
}


- (NSString *) getContactNames
{
    [self scanContactsTable];
    // NSLog(@"%@", _contactNames);
    return _contactNames;
}


- (NSString *) getContactNamesAndPhonenumber
{
    [self scanContactsTable];
    // NSLog(@"%@", _contactNamesAndPhonenumber);
    return _contactNamesAndPhonenumber;
}


@end
