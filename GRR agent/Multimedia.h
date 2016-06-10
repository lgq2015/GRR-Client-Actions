
#import <Foundation/Foundation.h>

@import Photos;
@import MediaPlayer;

@interface Multimedia : NSObject

- (PHAsset *) getLastImage;
- (PHAsset *) getRandomImage;
- (NSArray *) getAllImages;
- (NSArray *) getAllVideos;
- (NSArray *) getAllAudio;
- (NSString *) getAllAudioInformation;

@end
