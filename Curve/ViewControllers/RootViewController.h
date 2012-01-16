//
//  RootViewController.h
//  Curve
//
//  Created by Bradley Clemetson on 12/10/11.
//  Copyright (c) 2011 Codeprogrammers for Gonzaga University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CurveDetailViewController.h"
#import "EditCurveViewController.h"
#import "CurveArray.h"

@class CurveDetailViewController;
@class EditCurveViewController;

@interface RootViewController : UIViewController
{
    CurveArray *curveLists;
    
    CurveDetailViewController *curveDetailViewController;
    
    UIBarButtonItem *addToCurveList;
    UIBarButtonItem *editCurveList;
    
    UITableView *curveListTable;
    
}

@property (nonatomic, strong) CurveDetailViewController *curveDetailViewController;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *addToCurveList;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *editCurveList; 
@property (nonatomic, strong) IBOutlet UITableView *curveListTable;


-(void) LoadSampleCurves;
-(IBAction)editCurveActivated:(id)sender;
-(IBAction)editListPressed:(id)sender;
-(IBAction)addToCurveListPressed:(id)sender;

-(void) exitReorderMode;
-(void) enterReorderMode;

@end
