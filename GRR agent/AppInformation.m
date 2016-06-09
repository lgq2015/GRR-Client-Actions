
#import "AppInformation.h"

@interface AppInformation()

@property (nonatomic, strong) NSString* listOfAllApps;
@property (nonatomic, strong) NSString* listOfThirdPartyApps;


@end

@implementation AppInformation

- (instancetype)init
{
    self = [super init];
    if (self) {
        Class LSApplicationWorkspace_class = objc_getClass("LSApplicationWorkspace");
        NSObject *workspace = [LSApplicationWorkspace_class performSelector:@selector(defaultWorkspace)];
        NSString *allApps = [[workspace performSelector:@selector(allApplications)]componentsJoinedByString:@", "];
        
        NSMutableArray *components = [[NSMutableArray alloc]initWithArray:[allApps componentsSeparatedByString:@"Applications/"]];
        NSMutableArray *thirdPartyComponents = [[NSMutableArray alloc]init];
        
        int i;
        for(i=1;i<[components count];i++)
        {
            NSString *afterAppNameCache = [components objectAtIndex:i];
            NSArray *subStrings = [afterAppNameCache componentsSeparatedByString:@"Application/"];
            if([subStrings count]>1)
            {
                int a;
                for(a=0;a<[subStrings count];a++)
                {
                    if(a>0)
                    {
                        NSArray *removeCode = [[subStrings objectAtIndex:a] componentsSeparatedByString:@"/"];
                        [components addObject:[removeCode objectAtIndex:1]];
                        [thirdPartyComponents addObject:[removeCode objectAtIndex:1]];
                    }
                    else{
                        [components addObject:[subStrings objectAtIndex:a]];
                    }
                }
            }
        }
        
        allApps = @"";
        NSString *thirdPartyApps = @"";
        
        int k;
        for(k=1;k<[thirdPartyComponents count];k++)
        {
            NSString *afterAppNameCache = [thirdPartyComponents objectAtIndex:k];
            NSArray *doThis = [afterAppNameCache componentsSeparatedByString:@".app"];
            thirdPartyApps = [thirdPartyApps stringByAppendingString: [NSString stringWithFormat: @", %@", [doThis objectAtIndex:0]]];
        }
        
        int j;
        for(j=1;j<[components count];j++)
        {
            NSString *afterAppNameCache = [components objectAtIndex:j];
            NSArray *doThis = [afterAppNameCache componentsSeparatedByString:@".app"];
            allApps = [allApps stringByAppendingString: [NSString stringWithFormat: @", %@", [doThis objectAtIndex:0]]];
        }
        
        allApps = [allApps substringFromIndex:2];
        thirdPartyApps = [thirdPartyApps substringFromIndex:2];
        _listOfThirdPartyApps = thirdPartyApps;
        _listOfAllApps = allApps;
        
    }
    return self;
}

- (NSString *) getAllApps
{
    return _listOfAllApps;
}


- (NSString *) getThirdPartyApps
{
    return _listOfThirdPartyApps;
}
@end
