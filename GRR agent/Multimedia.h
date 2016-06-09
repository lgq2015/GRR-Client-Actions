
#import <Foundation/Foundation.h>

@import Photos;

@interface Multimedia : NSObject

-(PHAsset *) getLastImage;
-(PHAsset *) getRandomImage;
-(NSArray *) getAllImages;

@end
