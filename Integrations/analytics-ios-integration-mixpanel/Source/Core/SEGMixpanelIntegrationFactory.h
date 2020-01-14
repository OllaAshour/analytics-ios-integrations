#import <Analytics/SEGIntegrationFactory.h>
#import <Foundation/Foundation.h>

@interface SEGMixpanelIntegrationFactory : NSObject<SEGIntegrationFactory>

+ (instancetype)instance;
+ (instancetype)createWithLaunchOptions:(NSString *)token launchOptions:(NSDictionary *)launchOptions;

@property NSDictionary *launchOptions;

@end
