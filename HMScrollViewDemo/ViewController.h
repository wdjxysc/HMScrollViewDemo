//
//  ViewController.h
//  HMScrollViewDemo
//
//  Created by Wang Eric on 12-5-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TapDetectingImageView.h"

@interface ViewController : UIViewController<UIScrollViewDelegate, TapDetectingImageViewFotParentViewDelegate> {
    IBOutlet UIScrollView *scrollView;
	IBOutlet UIPageControl *pageControl;
	NSMutableArray *imageViews;
    IBOutlet UILabel *spotNameLabel;
    IBOutlet UILabel *scoreLabel;
    int currentPage;
    BOOL pageControlUsed;
    NSArray *titles;
    NSArray *subtitles;
}

@property (nonatomic, retain) NSMutableArray *imageViews;
@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) UIPageControl *pageControl;
@property (nonatomic, retain) UILabel *spotNameLabel;
@property (nonatomic, retain) UILabel *scoreLabel;
@property int currentPage;
@property BOOL pageControlUsed;
@property (nonatomic, retain) NSArray *titles;
@property (nonatomic, retain) NSArray *subtitles;

- (void)initScrollView;
- (void)loadScrollViewWithPage:(int)page;
- (void)scrollViewDidScroll:(UIScrollView *)sender;
- (void)createAllEmptyPagesForScrollView: (int) pages;

@end
