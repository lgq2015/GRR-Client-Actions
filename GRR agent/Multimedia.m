
#import "Multimedia.h"

@implementation Multimedia

-(PHAsset *) getLastImage
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

-(PHAsset *) getRandomImage
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
    
    return randomImageAsset;
}

-(NSArray *) getAllImages
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
    
    NSArray *assetArray = [fetchResult objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, numberOfImages-1)]];
    return assetArray;
}


@end
