//
//  FRPFullSizePhotoViewControler.h
//  FunctionalReactivePixels
//
//  Created by sigma-td on 2017/7/14.
//  Copyright © 2017年 sigma-td. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FRPFullSizePhotoViewControler;

@protocol FRPFullSizePhotoViewControllerDelegate <NSObject>

- (void)userDidScroll:(FRPFullSizePhotoViewControler *)controller toIndex: (NSInteger)index;

@end

@interface FRPFullSizePhotoViewControler : UIViewController


@property (nonatomic, strong) NSArray *photos;
@property (nonatomic, weak) id<FRPFullSizePhotoViewControllerDelegate> delegate;


- (instancetype)initWithModels:(NSArray *)models currentIndex:(NSInteger)index;




@end
