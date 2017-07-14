//
//  FRPGalleryViewController.m
//  FunctionalReactivePixels
//
//  Created by sigma-td on 2017/7/13.
//  Copyright © 2017年 sigma-td. All rights reserved.
//

#import "FRPGalleryViewController.h"
#import "FRPGalleryFlowLayout.h"
#import "FRPCollectionViewCell.h"
#import "FRPPhotoImporter.h"
#import "FRPFullSizePhotoViewControler.h"

@interface FRPGalleryViewController ()<FRPFullSizePhotoViewControllerDelegate>

@property (nonatomic, strong) NSArray *photos;

@end

@implementation FRPGalleryViewController

static NSString * const reuseIdentifier = @"Cell";


- (instancetype)init
{
    FRPGalleryFlowLayout *flowLayout = [[FRPGalleryFlowLayout alloc]init];
    self = [self initWithCollectionViewLayout:flowLayout];
    if (!self) {
        return nil;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Popular on 500px";
    
    [self.collectionView registerClass:[FRPCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    @weakify(self)
    [RACObserve(self, photos) subscribeNext:^(id x) {
        @strongify(self);
        [self.collectionView reloadData];
    }];
    [self loadPhoto];
    // Do any additional setup after loading the view.
}

- (void)loadPhoto {
    [[FRPPhotoImporter importPhotos] subscribeNext:^(id x) {
        self.photos = x;
    } error:^(NSError *error) {
        NSLog(@"load photos error: %@", error);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.photos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FRPCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    [cell setModel:self.photos[indexPath.item]];
    // Configure the cell
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    FRPFullSizePhotoViewControler *controller = [[FRPFullSizePhotoViewControler alloc] initWithModels:self.photos currentIndex:indexPath.item];
    controller.delegate = self;
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark <FRPFullSizePhotoViewControllerDelegate>


- (void)userDidScroll:(FRPFullSizePhotoViewControler *)controller toIndex:(NSInteger)index {
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:YES];
}

@end
