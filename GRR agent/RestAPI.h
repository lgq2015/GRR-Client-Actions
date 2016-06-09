
#import <Foundation/Foundation.h>

@class RestAPI;

@protocol RestAPIDelegate
- (void) getReceivedData:(NSMutableData *)data sender:(RestAPI *) sender;

@end

@interface RestAPI : NSObject

-(void) httpRequest: (NSMutableURLRequest *) request;

@property (nonatomic, weak) id <RestAPIDelegate> delegate;

@end
