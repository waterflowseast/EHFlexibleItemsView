//
//  EHFlexibleItemsView.h
//  WFEDemo
//
//  Created by Eric Huang on 16/12/7.
//  Copyright © 2016年 Eric Huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EHItemViewCommon/EHTypeDefs.h>

@class EHFlexibleItemsView;

@protocol EHFlexibleItemsViewDelegate <NSObject>

@optional
- (void)didTapItemAtIndex:(NSInteger)index rowIndex:(NSInteger)rowIndex columnIndex:(NSInteger)columnIndex inView:(EHFlexibleItemsView *)view;

@end

@class EHFlexibleLayout;

@interface EHFlexibleItemsView : UIView

@property (nonatomic, assign) BOOL allowsAnimationWhenTap;
@property (nonatomic, assign) NSTimeInterval animationDuration;
@property (nonatomic, copy) void (^animationBlock)(UIView *itemView, NSTimeInterval animationDuration, EHAnimationCompletionBlock animationCompletion);
@property (nonatomic, assign) id<EHFlexibleItemsViewDelegate> delegate;

@property (nonatomic, strong, readonly) EHFlexibleLayout *layout;

- (instancetype)initWithItems:(NSArray <UIView *> *)items itemWidths:(NSArray <NSNumber *> *)itemWidths itemHeight:(CGFloat)itemHeight totalWidth:(CGFloat)totalWidth insets:(UIEdgeInsets)insets interitemSpacing:(CGFloat)interitemSpacing lineSpacing:(CGFloat)lineSpacing;

- (instancetype)initWithItems:(NSArray <UIView *> *)items layout:(EHFlexibleLayout *)layout;

- (void)resetWithItems:(NSArray <UIView *> *)items itemWidths:(NSArray <NSNumber *> *)itemWidths itemHeight:(CGFloat)itemHeight totalWidth:(CGFloat)totalWidth insets:(UIEdgeInsets)insets interitemSpacing:(CGFloat)interitemSpacing lineSpacing:(CGFloat)lineSpacing;

- (void)resetWithItems:(NSArray <UIView *> *)items layout:(EHFlexibleLayout *)layout;

- (CGFloat)totalHeight;

@end
