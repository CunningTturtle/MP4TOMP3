//
//  AppManager.m
//  MP4TOMP3
//
//  Created by iOS on 2019/3/25.
//  Copyright © 2019 iOS. All rights reserved.
//

#import "AppManager.h"


static AppManager *sectionInstance;

@implementation AppManager


+ (id)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sectionInstance = [super allocWithZone:zone];
    });
    return sectionInstance;
}
+ (AppManager *)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sectionInstance = [[self alloc] init];
    });
    return sectionInstance;
}


-(void)setUserof:(NSString *)userof {
    if (_userof!=userof) {
        _userof = userof;
    }
}

-(void)setUseropen:(NSString *)useropen {
    if (_useropen!=useropen) {
        _useropen = useropen;
    }
}


@end
