//
//  FRPPhotoModel.h
//  FunctionalReactivePixels
//
//  Created by libo on 2017/7/14.
//  Copyright © 2017年 sigma-td. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FRPPhotoModel : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSNumber *identifier;
@property (strong, nonatomic) NSString *photographerName;
@property (strong, nonatomic) NSNumber *rating;
@property (strong, nonatomic) NSString *thumbnilUrl;
@property (strong, nonatomic) NSString *fullsizedURL;
@property (strong, nonatomic) NSData *fullsizedData;


@end
