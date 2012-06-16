//
//  GraphDetailViewController.h
//  Curve
//
//  Created by Bradley C. on 1/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GraphDetailViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>
{
    NSMutableArray *lineColors;
    NSMutableArray *lineStyles;
    NSMutableArray *graphStyles;
    
    UITableView *graphOptionsTable;
    UIActionSheet *pickerActions;
    
}

@property (nonatomic, retain) IBOutlet UITableView *graphicsOptionsTable;
@property (nonatomic, retain) UIActionSheet *pickerActions;


-(void)dismissSheet;
@end
