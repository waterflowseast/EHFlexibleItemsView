//
//  EHFlexibleLayout.h
//  WFEDemo
//
//  Created by Eric Huang on 16/12/6.
//  Copyright © 2016年 Eric Huang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EHFlexibleLayout : NSObject

@property (nonatomic, strong, readonly) NSArray <NSNumber *> *itemWidths;
@property (nonatomic, assign, readonly) CGFloat itemHeight;

@property (nonatomic, assign, readonly) CGFloat totalWidth;
@property (nonatomic, assign, readonly) UIEdgeInsets insets;

@property (nonatomic, assign, readonly) CGFloat interitemSpacing;
@property (nonatomic, assign, readonly) CGFloat lineSpacing;

- (instancetype)initWithItemWidths:(NSArray <NSNumber *> *)itemWidths itemHeight:(CGFloat)itemHeight totalWidth:(CGFloat)totalWidth insets:(UIEdgeInsets)insets interitemSpacing:(CGFloat)interitemSpacing lineSpacing:(CGFloat)lineSpacing;

- (CGFloat)totalHeight;

- (NSInteger)itemsCountAtRow:(NSInteger)row;
- (NSInteger)numberOfRows;

- (NSInteger)columnIndexForIndex:(NSInteger)index;
- (NSInteger)rowIndexForIndex:(NSInteger)index;

- (CGFloat)xForIndex:(NSInteger)index;
- (CGFloat)yForIndex:(NSInteger)index;

- (NSInteger)columnIndexForLocation:(CGPoint)location;
- (NSInteger)rowIndexForLocation:(CGPoint)location;
- (NSInteger)indexForLocation:(CGPoint)location;

@end
