// for updates see https://gist.github.com/anthonya1999/708bb747c1e7e4827b04b76f53ef7f28

#import <UIKit/UIKit.h>
#include <dlfcn.h>

static const CFStringRef kMGDieID = CFSTR("DieId");

typedef NS_ENUM(NSInteger, BKSInterfaceOrientation) {
    BKSInterfaceOrientationPortrait = 1,
    BKSInterfaceOrientationPortraitUpsideDown = 2,
    BKSInterfaceOrientationLandscapeRight = 3,
    BKSInterfaceOrientationLandscapeLeft = 4
};

@interface UIDevice (Extensions)

- (NSString *)dieID;
- (NSString *)batteryID;
- (BOOL)forceTouchIsAvailableAndEnabled;
- (BKSInterfaceOrientation)currentOrientation;
- (BOOL)cellularDataIsEnabled;

@end