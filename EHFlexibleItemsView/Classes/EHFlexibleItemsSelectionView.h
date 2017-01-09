//
//  EHFlexibleItemsSelectionView.h
//  WFEDemo
//
//  Created by Eric Huang on 16/12/19.
//  Copyright © 2016年 Eric Huang. All rights reserved.
//

#import "EHFlexibleItemsView.h"
#import <EHItemViewCommon/EHItemViewDelegate.h>
#import <EHItemViewCommon/EHItemViewSelectionDelegate.h>

@interface EHFlexibleItemsSelectionView : EHFlexibleItemsView

@property (nonatomic, assign) BOOL allowsMultipleSelection;
@property (nonatomic, assign) BOOL allowsToCancelWhenSingleSelection;
@property (nonatomic, assign) NSUInteger maxSelectionsAllowed;
@property (nonatomic, assign) id<EHFlexibleItemsViewDelegate, EHItemViewSelectionDelegate> delegate;

@property (nonatomic, assign, readonly) NSInteger selectedIndex;
@property (nonatomic, strong, readonly) NSMutableSet *selectedIndexes;

- (instancetype)initWithItems:(NSArray<UIView <EHItemViewDelegate> *> *)items itemWidths:(NSArray<NSNumber *> *)itemWidths itemHeight:(CGFloat)itemHeight totalWidth:(CGFloat)totalWidth insets:(UIEdgeInsets)insets interitemSpacing:(CGFloat)interitemSpacing lineSpacing:(CGFloat)lineSpacing;

- (instancetype)initWithItems:(NSArray<UIView <EHItemViewDelegate> *> *)items layout:(EHFlexibleLayout *)layout;

- (void)resetWithItems:(NSArray<UIView <EHItemViewDelegate> *> *)items itemWidths:(NSArray<NSNumber *> *)itemWidths itemHeight:(CGFloat)itemHeight totalWidth:(CGFloat)totalWidth insets:(UIEdgeInsets)insets interitemSpacing:(CGFloat)interitemSpacing lineSpacing:(CGFloat)lineSpacing;

- (void)resetWithItems:(NSArray<UIView <EHItemViewDelegate> *> *)items layout:(EHFlexibleLayout *)layout;

- (void)makeIndexSelected:(NSInteger)index;
- (void)makeIndexesSelected:(NSSet <NSNumber *> *)indexes;

@end
