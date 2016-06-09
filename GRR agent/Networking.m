
#import "Networking.h"

#define POST @"POST";
#define GET @"GET";

@implementation Networking

- (void) startPostRequest
{
    [NSTimer scheduledTimerWithTimeInterval:10.0
                                     target:self
                                   selector:@selector(timerFired:)
                                   userInfo:nil
                                    repeats:YES];

}

- (void)timerFired:(NSTimer *)timer
{    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration: config];
    
    NSURL *url = [NSURL URLWithString:@"http://posttestserver.com/post.php"];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    NSString * params =@"name=Done&age=24&loc=finnland";
    [urlRequest setHTTPMethod: @"POST"];
    [urlRequest setHTTPBody: [params dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSessionDataTask * dataTask =[session dataTaskWithRequest:urlRequest
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                    NSLog(@"Response:%@ %@\n", response, error);
                                                    if(error == nil)
                                                    {
                                                        NSString * text = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
                                                        NSLog(@"Data = %@",text);
                                                    }
                                                }];
    [dataTask resume];
}


@end
