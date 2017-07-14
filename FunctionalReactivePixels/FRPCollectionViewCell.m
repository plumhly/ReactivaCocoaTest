//
//  FRPCollectionViewCell.m
//  FunctionalReactivePixels
//
//  Created by sigma-td on 2017/7/14.
//  Copyright © 2017年 sigma-td. All rights reserved.
//

#import "FRPCollectionViewCell.h"
#import "FRPPhotoModel.h"

@interface FRPCollectionViewCell ()

@property (nonatomic, weak) UIImageView *imageView;
@property (nonatomic, strong) RACDisposable *subscription;

@end

@implementation FRPCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor darkGrayColor];
        
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:self.bounds];
        imgView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [self.contentView addSubview:imgView];
        self.imageView = imgView;
    }
    return self;
}

-(void)setModel:(FRPPhotoModel *)model {
    self.subscription = [[[RACObserve(model, thumbnilData) filter:^BOOL(id value) {
        return  value != nil;
    }]
    map:^id(id value) {
        return [UIImage imageWithData:value];
    }] setKeyPath:@keypath(self.imageView, image) onObject:self.imageView];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    [self.subscription  dispose];
    self.subscription = nil;
}

@end
