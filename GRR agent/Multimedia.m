
#import "Multimedia.h"

@implementation Multimedia

- (instancetype)init
{
    self = [super init];
    if (self) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status)
         {
             if (status == PHAuthorizationStatusAuthorized)
             {
                 NSLog(@"access to fotos granted");
             }
             else
             {
                 NSLog(@"no access to fotos");
             }
         }];
    }
    return self;
}

- (PHAsset *) getLastImage
{
    PHFetchOptions *fetchOptions = [PHFetchOptions new];
    
    fetchOptions.fetchLimit = 1;
    fetchOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    PHFetchResult *fetchResult = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:fetchOptions];
    
    if (fetchResult == nil)
    {
        return nil;
    }
    
    PHAsset *lastImageAsset = [fetchResult lastObject];
    return lastImageAsset;
}

- (PHAsset *) getRandomImage
{
    PHFetchOptions *fetchOptions = [PHFetchOptions new];
    
    PHFetchResult *getImageCount = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:fetchOptions];
    int numberOfImages = [getImageCount count];
    
    fetchOptions.fetchLimit = numberOfImages;
    fetchOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    PHFetchResult *fetchResult = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:fetchOptions];
    if (fetchResult == nil)
    {
        return nil;
    }
    //get random asset for testing
    PHAsset *randomImageAsset = [fetchResult objectAtIndex:arc4random_uniform(numberOfImages)];

    // get photo info from this asset
    NSLog(@"filename: %@",[randomImageAsset valueForKey:@"filename"]);
    NSLog(@"creation date: %@",[randomImageAsset valueForKey:@"creationDate"]);
    
    
    PHImageRequestOptions * imageRequestOptions = [[PHImageRequestOptions alloc] init];
    imageRequestOptions.synchronous = YES;
    [[PHImageManager defaultManager]
     requestImageDataForAsset:randomImageAsset
     options:imageRequestOptions
     resultHandler:^(NSData *imageData, NSString *dataUTI,
                     UIImageOrientation orientation,
                     NSDictionary *info)
     {
         if ([info objectForKey:@"PHImageFileURLKey"])
         {
             NSURL *path = [info objectForKey:@"PHImageFileURLKey"];
             NSLog(@"filepath: %@", path);
         }
         // more info
         // NSLog(@"fileinfo: %@", info);
     }];
    
    // NSLog(@"Random image");
    return randomImageAsset;
}

- (NSArray *) getAllImages
{
    PHFetchOptions *fetchOptions = [PHFetchOptions new];
    PHFetchResult *getImageCount = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:fetchOptions];
    int numberOfImages = [getImageCount count];
    
    fetchOptions.fetchLimit = numberOfImages;
    fetchOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    PHFetchResult *fetchResult = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:fetchOptions];
    
    if (numberOfImages == 0)
    {
        NSLog(@"no audio");
        return nil;
    }
    
    NSArray *assetArray = [fetchResult objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, numberOfImages-1)]];
    NSLog(@"got all images");
    return assetArray;
}

- (NSArray *) getAllVideos
{
    PHFetchOptions *fetchOptions = [PHFetchOptions new];
    PHFetchResult *getVideoCount = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeVideo options:fetchOptions];
    int numberOfVideos = [getVideoCount count];
    
    fetchOptions.fetchLimit = numberOfVideos;
    fetchOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    PHFetchResult *fetchResult = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:fetchOptions];
    
    if (numberOfVideos == 0)
    {
        NSLog(@"no videos");
        return nil;
    }
    
    NSArray *assetArray = [fetchResult objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, numberOfVideos-1)]];
    NSLog(@"got all videos");
    return assetArray;
}

// within PHAssetLibrary
- (NSArray *) getAllAudio
{
    PHFetchOptions *fetchOptions = [PHFetchOptions new];
    PHFetchResult *getAudioCount = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeAudio options:fetchOptions];
    int numberOfAudio = [getAudioCount count];
    
    fetchOptions.fetchLimit = numberOfAudio;
    fetchOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    PHFetchResult *fetchResult = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:fetchOptions];
    
    if (numberOfAudio == 0)
    {
        NSLog(@"no audio");
        return nil;
    }
    
    NSArray *assetArray = [fetchResult objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, numberOfAudio-1)]];
    NSLog(@"got all audio");
    return assetArray;
}

- (NSString *) getAllAudioInformation
{
    NSMutableString *audioInfo = [[NSMutableString alloc] initWithString:@"Albums:"];
    [audioInfo appendFormat:@"\n count: %i",[[[MPMediaQuery albumsQuery] collections] count]];
    for (MPMediaItemCollection *collection in [[MPMediaQuery albumsQuery] collections]) {
        [audioInfo appendFormat:@"\n%@",[[collection representativeItem] valueForProperty:MPMediaItemPropertyAlbumTitle]];
    }
    
    [audioInfo appendString:@"\n\nArtist:"];
    [audioInfo appendFormat:@"\ncount: %i",[[[MPMediaQuery artistsQuery] collections] count]];
    for (MPMediaItemCollection *collection in [[MPMediaQuery artistsQuery] collections]) {
        [audioInfo appendFormat:@"\n%@",[[collection representativeItem] valueForProperty:MPMediaItemPropertyArtist]];
    }
    
    [audioInfo appendString:@"\n\nSongs:"];
    [audioInfo appendFormat:@"\ncount: %i",[[[MPMediaQuery songsQuery] collections] count]];
    for (MPMediaItemCollection *collection in [[MPMediaQuery artistsQuery] collections]) {
        // [audioInfo appendFormat:@"\n%@",[[collection representativeItem] valueForProperty:MPMediaItemPropertyTitle]];
    }
    
    NSLog(@"%@",audioInfo);
    return @"see console log";
}

@end
