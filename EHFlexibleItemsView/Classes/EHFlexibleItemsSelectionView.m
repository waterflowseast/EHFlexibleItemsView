//
//  EHFlexibleItemsSelectionView.m
//  WFEDemo
//
//  Created by Eric Huang on 16/12/19.
//  Copyright © 2016年 Eric Huang. All rights reserved.
//

#import "EHFlexibleItemsSelectionView.h"
#import "EHFlexibleLayout.h"

@interface EHFlexibleItemsSelectionView ()

@property (nonatomic, assign, readwrite) NSInteger selectedIndex;
@property (nonatomic, strong, readwrite) NSMutableSet *selectedIndexes;

@end

@implementation EHFlexibleItemsSelectionView

@synthesize delegate = delegate_;

- (instancetype)initWithItems:(NSArray<UIView<EHItemViewDelegate> *> *)items itemWidths:(NSArray<NSNumber *> *)itemWidths itemHeight:(CGFloat)itemHeight totalWidth:(CGFloat)totalWidth insets:(UIEdgeInsets)insets interitemSpacing:(CGFloat)interitemSpacing lineSpacing:(CGFloat)lineSpacing {
    self = [super initWithItems:items itemWidths:itemWidths itemHeight:itemHeight totalWidth:totalWidth insets:insets interitemSpacing:interitemSpacing lineSpacing:lineSpacing];
    if (self) {
        _maxSelectionsAllowed = items.count;
        _selectedIndex = -1;
    }
    
    return self;
}

- (instancetype)initWithItems:(NSArray<UIView<EHItemViewDelegate> *> *)items layout:(EHFlexibleLayout *)layout {
    self = [super initWithItems:items layout:layout];
    if (self) {
        _maxSelectionsAllowed = items.count;
        _selectedIndex = -1;
    }
    
    return self;
}

- (void)resetWithItems:(NSArray<UIView<EHItemViewDelegate> *> *)items itemWidths:(NSArray<NSNumber *> *)itemWidths itemHeight:(CGFloat)itemHeight totalWidth:(CGFloat)totalWidth insets:(UIEdgeInsets)insets interitemSpacing:(CGFloat)interitemSpacing lineSpacing:(CGFloat)lineSpacing {
    for (UIView <EHItemViewDelegate> *item in items) {
        [self didTapView:item toSelected:NO];
    }

    [super resetWithItems:items itemWidths:itemWidths itemHeight:itemHeight totalWidth:totalWidth insets:insets interitemSpacing:interitemSpacing lineSpacing:lineSpacing];
    _maxSelectionsAllowed = items.count;
    _selectedIndex = -1;
    _selectedIndexes = nil;
}

- (void)resetWithItems:(NSArray<UIView<EHItemViewDelegate> *> *)items layout:(EHFlexibleLayout *)layout {
    for (UIView <EHItemViewDelegate> *item in items) {
        [self didTapView:item toSelected:NO];
    }
    
    [super resetWithItems:items layout:layout];
    _maxSelectionsAllowed = items.count;
    _selectedIndex = -1;
    _selectedIndexes = nil;
}

- (void)makeIndexSelected:(NSInteger)index {
    if (self.allowsMultipleSelection) {
        return;
    }
    
    self.selectedIndex = index;
    for (int i = 0; i < self.layout.itemWidths.count; i++) {
        [self didTapView:[self itemViewAtIndex:i] toSelected:(i == index)];
    }
}

- (void)makeIndexesSelected:(NSSet<NSNumber *> *)indexes {
    if (!self.allowsMultipleSelection || indexes.count > self.maxSelectionsAllowed) {
        return;
    }
    
    self.selectedIndexes = [NSMutableSet setWithSet:indexes];
    for (int i = 0; i < self.layout.itemWidths.count; i++) {
        [self didTapView:[self itemViewAtIndex:i] toSelected:([indexes containsObject:@(i)])];
    }
}

#pragma mark - private methods

- (void)didTapItemAtIndex:(NSInteger)index {
    if (!self.allowsMultipleSelection) {
        // single selection
        
        if (self.selectedIndex < 0) {
            [self didTapView:[self itemViewAtIndex:index] toSelected:YES];
            self.selectedIndex = index;
        } else if (self.selectedIndex != index) {
            [self didTapView:[self itemViewAtIndex:self.selectedIndex] toSelected:NO];
            [self didTapView:[self itemViewAtIndex:index] toSelected:YES];
            self.selectedIndex = index;
        } else if (self.allowsToCancelWhenSingleSelection) {
            [self didTapView:[self itemViewAtIndex:index] toSelected:NO];
            self.selectedIndex = -1;
        } else {
            return;
        }
    } else {
        // multiple selections
        
        if ([self.selectedIndexes containsObject:@(index)]) {
            [self didTapView:[self itemViewAtIndex:index] toSelected:NO];
            [self.selectedIndexes removeObject:@(index)];
        } else if (self.selectedIndexes.count < self.maxSelectionsAllowed) {
            [self didTapView:[self itemViewAtIndex:index] toSelected:YES];
            [self.selectedIndexes addObject:@(index)];
        } else {
            if ([self.delegate respondsToSelector:@selector(didTapExceedingLimitInView:maxSelectionsAllowed:)]) {
                [self.delegate didTapExceedingLimitInView:self maxSelectionsAllowed:self.maxSelectionsAllowed];
            }
            
            return;
        }
    }
    
    [self copyVersionOfDidTapItemAtIndex:index];
}

- (void)copyVersionOfDidTapItemAtIndex:(NSInteger)index {
    NSInteger rowIndex = [self.layout rowIndexForIndex:index];
    NSInteger columnIndex = [self.layout columnIndexForIndex:index];
    
    if (!self.allowsAnimationWhenTap) {
        if ([self.delegate respondsToSelector:@selector(didTapItemAtIndex:rowIndex:columnIndex:inView:)]) {
            [self.delegate didTapItemAtIndex:index rowIndex:rowIndex columnIndex:columnIndex inView:self];
        }
        
        return;
    }
    
    // animation!
    UIView *itemView = [self itemViewAtIndex:index];
    
    CGFloat duration = self.animationDuration > 0 ? self.animationDuration : 0.4;
    
    if (self.animationBlock) {
        __weak typeof(self) weakSelf = self;
        
        self.animationBlock(itemView, duration, ^(BOOL finished) {
            __strong typeof(self) strongSelf = weakSelf;
            
            if (finished && [strongSelf.delegate respondsToSelector:@selector(didTapItemAtIndex:rowIndex:columnIndex:inView:)]) {
                [strongSelf.delegate didTapItemAtIndex:index rowIndex:rowIndex columnIndex:columnIndex inView:strongSelf];
            }
        });
        
        return;
    }

    [UIView
     animateKeyframesWithDuration:duration
     delay:0
     options:UIViewKeyframeAnimationOptionCalculationModeLinear
     animations:^{
         [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:0.5 animations:^{
             itemView.transform = CGAffineTransformMakeScale(1.1, 1.1);
         }];
         
         [UIView addKeyframeWithRelativeStartTime:0.5 relativeDuration:0.5 animations:^{
             itemView.transform = CGAffineTransformMakeScale(1.0, 1.0);
         }];
     } completion:^(BOOL finished) {
         if (finished && [self.delegate respondsToSelector:@selector(didTapItemAtIndex:rowIndex:columnIndex:inView:)]) {
             [self.delegate didTapItemAtIndex:index rowIndex:rowIndex columnIndex:columnIndex inView:self];
         }
     }];
}

- (void)didTapView:(UIView <EHItemViewDelegate> *)view toSelected:(BOOL)selected {
    if ([view respondsToSelector:@selector(didTapToSelected:)]) {
        [view didTapToSelected:selected];
    }
}

- (UIView <EHItemViewDelegate> *)itemViewAtIndex:(NSInteger)index {
    UIView *itemView = [self viewWithTag:index];
    
    // if it's myself, find it in my subviews
    if ([self isEqual:itemView]) {
        for (UIView *subView in self.subviews) {
            itemView = [subView viewWithTag:index];
            
            if (itemView) {
                break;
            }
        }
    }
    
    return (UIView <EHItemViewDelegate> *)itemView;
}

#pragma mark - getters & setters

- (NSMutableSet *)selectedIndexes {
    if (!_selectedIndexes) {
        _selectedIndexes = [[NSMutableSet alloc] init];
    }
    
    return _selectedIndexes;
}

@end
