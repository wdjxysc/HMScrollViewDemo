//
//  ViewController.m
//  HMScrollViewDemo
//
//  Created by Wang Eric on 12-5-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "DetailedView.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize imageViews;
@synthesize scrollView;
@synthesize pageControl;
@synthesize spotNameLabel;
@synthesize scoreLabel;
@synthesize currentPage;
@synthesize pageControlUsed;
@synthesize titles;
@synthesize subtitles;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [super viewDidLoad];
    [self initScrollView];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)initScrollView {
    self.titles = [NSArray arrayWithObjects:@"Page 1", @"Page 2", @"Page 3", @"Page 4", @"Page 5",nil];
    self.subtitles= [NSArray arrayWithObjects:
                     @"★ ★ ★", @"★ ★ ★ ☆",
                     @"★ ★ ★ ★", @"★ ★ ★ ★ ☆",
                     @"★ ★ ★ ★ ★",
                     nil];
    
    
    int kNumberOfPages = 5;
    
    // in the meantime, load the array with placeholders which will be replaced on demand
    NSMutableArray *views = [[NSMutableArray alloc] init];
    for (unsigned i = 0; i < kNumberOfPages; i++) {
        [views addObject:[NSNull null]];
    }
    self.imageViews = views;
    
    // a page is the width of the scroll view
    scrollView.pagingEnabled = YES;
    scrollView.clipsToBounds = NO;
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * kNumberOfPages, scrollView.frame.size.height);
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.scrollsToTop = NO;
    scrollView.delegate = self;
    currentPage = 0;
    
    pageControl.numberOfPages = kNumberOfPages;
    pageControl.currentPage = 0;
    pageControl.backgroundColor = [UIColor whiteColor];
    
    [self createAllEmptyPagesForScrollView: kNumberOfPages];
    
    // pages are created on demand
    // load the visible page
    // load the page on either side to avoid flashes when the user starts scrolling
    [self loadScrollViewWithPage:0];
    [self loadScrollViewWithPage:1];
    currentPage = 0;
    [scrollView setContentOffset:CGPointMake(0, 0)];
}

- (void)createAllEmptyPagesForScrollView: (int) pages {
    if (pages < 0) {
        return;
    }
    
    for (int page = 0; page < pages; page++) {
        CGRect frame = scrollView.frame;
        
        UIButton *backgroundButton =  [UIButton buttonWithType:UIButtonTypeRoundedRect];
        backgroundButton.frame = CGRectMake(frame.size.width * page + 5, 0, 270, 258);
        //CGRectMake(frame.size.width * page + 8, 0, 293, 258);    
        [backgroundButton setEnabled:false];
        [scrollView addSubview:backgroundButton];
        
        UILabel *name = [[UILabel alloc] initWithFrame:
                         CGRectMake(frame.size.width * page + 47, 4, 186, 21)];
        [name setTextAlignment:UITextAlignmentCenter];
        name.font = [UIFont fontWithName:[[UIFont fontNamesForFamilyName:@"Helvetica"] objectAtIndex:1]
                                    size:17];
        UILabel *score = [[UILabel alloc] initWithFrame:
                          CGRectMake(frame.size.width * page + 69, 26, 142, 16)];
        [score setTextAlignment:UITextAlignmentCenter];
        score.font = [UIFont fontWithName:[[UIFont fontNamesForFamilyName:@"Helvetica"] objectAtIndex:1] 
                                     size:13];
        name.text = [self.titles objectAtIndex:page];
        score.text = [self.subtitles objectAtIndex:page];
        
        
        [scrollView addSubview:name];
        [scrollView addSubview:score];
        
        UIButton *detailButton =  [UIButton buttonWithType:UIButtonTypeInfoDark];
        detailButton.frame = CGRectMake(frame.size.width * page + 242, 16, 29, 31);    
        [detailButton addTarget:self
                         action:@selector(doTabImageViewAction)
               forControlEvents:UIControlEventTouchUpInside]; 
        [scrollView addSubview:detailButton];
        
        UIActivityIndicatorView *actIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:
                                                 UIActivityIndicatorViewStyleWhiteLarge];
        [actIndicator setCenter:CGPointMake(frame.size.width * page + 140, 131)];
        [scrollView addSubview:actIndicator];
        [actIndicator startAnimating];
    }
}

- (void)loadScrollViewWithPage:(int)page {
	int kNumberOfPages = 5;
	
    if (page < 0) {
        return;
    }
    if (page >= kNumberOfPages) {
        return;
    }
    
    //currentPage = page;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        TapDetectingImageView *tempView = [imageViews objectAtIndex:page];
        if ((NSNull *)tempView == [NSNull null]) {
            //NSString* imgURL = [[self.recommendSpots objectAtIndex:page] faceImg];
            UIImage* image = [UIImage imageNamed:@"img.gif"]; 
            /*if ([imgURL isEqualToString:@"nil"]) {
             image = [UIImage imageNamed: @"Default.png"];
             } else {
             NSData* imageData = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:imgURL]];
             image = [[UIImage alloc] initWithData:imageData];
             }*/
            
            tempView = [[TapDetectingImageView alloc] initWithImage:image];
            tempView.parentView = self;
            [imageViews replaceObjectAtIndex:page withObject:tempView];
        }
        
        if (tempView) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (nil == tempView.superview) {
                    CGRect frame = scrollView.frame;
                    frame.origin.x = frame.size.width * page;
                    frame.origin.y = 0;
                    tempView.frame = CGRectMake(frame.size.width * page + 14, 50, 253, 200);
                    [scrollView addSubview:tempView];
                    //[scrollView setContentOffset:CGPointMake(frame.size.width * page, 0)];
                }
                //[scrollView setContentOffset:CGPointMake(scrollView.frame.size.width * page, 0)];
            });
        }
        else {
            //NSLog(@"impossible download image");
        }
    }); 
}


- (void)scrollViewDidScroll:(UIScrollView *)sender {
    CGFloat pageWidth = self.scrollView.frame.size.width;
    int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    if (page < 0 || page >= 5) {
        return;
    }
    pageControl.currentPage = page;
    if (pageControlUsed) {
        // do nothing - the scroll was initiated from the page control, not the user dragging
        return;
    }
}

// At the begin of scroll dragging, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    pageControlUsed = NO;
}

// At the end of scroll animation, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat pageWidth = self.scrollView.frame.size.width;
    int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    pageControl.currentPage = page;
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
    currentPage = page;
    pageControlUsed = NO;
}

- (BOOL)touchesShouldBegin:(NSSet *)touches withEvent:(UIEvent *)event inContentView:(UIView *)view 
{ 
    return YES; 
} 
- (BOOL)touchesShouldCancelInContentView:(UIView *)view 
{ 
    return NO; 
} 

//for TapDetectingImageViewDelegate
- (void)doTabImageViewAction {
    DetailedView *detailView = [[DetailedView alloc]initWithNibName:@"DetailedView" bundle:nil];
    detailView.hidesBottomBarWhenPushed = YES;
    detailView.page = self.currentPage + 1;
    [[self navigationController] pushViewController:detailView animated:YES];
    //[self.parentView pushViewAction:objectDetailView];
}

@end
