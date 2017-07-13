//
//  FRPGalleryFlowLayout.m
//  FunctionalReactivePixels
//
//  Created by sigma-td on 2017/7/13.
//  Copyright © 2017年 sigma-td. All rights reserved.
//

#import "FRPGalleryFlowLayout.h"

@implementation FRPGalleryFlowLayout

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.itemSize = CGSizeMake(145, 145);
        self.minimumLineSpacing = 10;
        self.minimumInteritemSpacing = 10;
        self.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    }
    return self;
}


@end
