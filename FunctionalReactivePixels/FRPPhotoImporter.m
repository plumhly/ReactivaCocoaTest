//
//  FRPPhotoImporter.m
//  FunctionalReactivePixels
//
//  Created by libo on 2017/7/14.
//  Copyright © 2017年 sigma-td. All rights reserved.
//

#import "FRPPhotoImporter.h"
#import "AppDelegate.h"
#import "FRPPhotoModel.h"

@interface FRPPhotoImporter ()



@end

@implementation FRPPhotoImporter

+ (RACSignal *)importPhotos {
    RACReplaySubject *subject = [RACReplaySubject subject];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [[session dataTaskWithRequest:[self popularReques] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data) {
            id result = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            [subject sendNext:[[[result[@"photos"] rac_sequence] map:^id(NSDictionary *photoDic) {
                FRPPhotoModel *model = [FRPPhotoModel new];
                [self configModel:model withDictionary:photoDic];
                [self downloadThumbnilForPhotoModel:model];
                return model;
            }] array]];
            [subject sendCompleted];
        } else {
            [subject sendError:error];
        }
        
    }] resume];
    return  subject;
}

+ (NSURLRequest *)popularReques {
   return  [((AppDelegate *)[UIApplication sharedApplication].delegate).apiHelper  urlRequestForPhotoFeature:PXAPIHelperPhotoFeaturePopular resultsPerPage:100 page:0 photoSizes:PXPhotoModelSizeThumbnail sortOrder:PXAPIHelperSortOrderRating except:PXPhotoModelCategoryNude];
}

+ (void)configModel:(FRPPhotoModel *)model withDictionary:(NSDictionary *)dic {
    model.name = dic[@"name"];
    model.identifier = dic[@"id"];
    model.photographerName = dic[@"user"][@"username"];
    model.rating = dic[@"rating"];
    model.thumbnilUrl = [self urlForSize:3 inArray:dic[@"images"]];
    if (dic[@"comments_count"]) {
        model.fullsizedURL = [self urlForSize:4 inArray:dic[@"images"]];
    }
}

+ (NSString *)urlForSize:(NSUInteger)size inArray:(NSArray *)array {
    return  [[[[array rac_sequence] filter:^BOOL(NSDictionary *value) {
        return [value[@"size"] integerValue] == size;
    }] map:^id(id value) {
        return value[@"url"];
    }] array].firstObject;
}

+ (void)downloadThumbnilForPhotoModel:(FRPPhotoModel *)model {
    NSAssert(model.thumbnilUrl, @"thumbnil must not be nil");
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [[session dataTaskWithURL:[NSURL URLWithString:model.thumbnilUrl] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        model.thumbnilData = data;
    }] resume];
    
}

@end
