//
//  DetailedView.h
//  HMScrollViewDemo
//
//  Created by Wang Eric on 12-5-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailedView : UIViewController {
    IBOutlet UILabel *titleLabel;
    int page;
}
@property (nonatomic, retain) UILabel *titleLabel;
@property int page;


@end
