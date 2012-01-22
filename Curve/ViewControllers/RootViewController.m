//
//  RootViewController.m
//  Curve
//
//  Created by Bradley Clemetson on 12/10/11.
//  Copyright (c) 2011 Codeprogrammers for Gonzaga University. All rights reserved.
//

#include <stdlib.h>

#import "RootViewController.h"
#import "CurveDetailViewController.h"
#import "EditCurveViewController.h"

#import "curveMath.h"
#import "PointXY.h"

@implementation RootViewController

@synthesize curveDetailViewController;
@synthesize curveListTable;
@synthesize addToCurveList, editCurveList;


- (CurveDetailViewController *) curveDetailViewController
{
    if(!curveDetailViewController)
    {
        curveDetailViewController = [[CurveDetailViewController alloc] init];
    }
    return curveDetailViewController;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = editCurveList;
    self.navigationItem.rightBarButtonItem = addToCurveList;
    
    curveLists = [CurveArray shared];
    
    
    //!!!!This is sample Data!!!!!! Load real data
    [self LoadSampleCurves];
    self.title = @"Curves";
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    //!!!!This is sample Data!!!!!! Load real data
    //self.curveList = nil;
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

-(IBAction)addToCurveListPressed:(id)sender
{
    
    EditCurveViewController *editCurveViewController;
    editCurveViewController = [[EditCurveViewController alloc] init];
    
    editCurveViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    editCurveViewController.editingCurve = NO;
    
    if((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone))
    {
        [self presentModalViewController: editCurveViewController animated: YES];
    }
    else
    {
        [self.navigationController pushViewController: editCurveViewController animated:YES];
        editCurveViewController.contentSizeForViewInPopover = CGSizeMake(320.0, 445.0);
    }
    
}

-(IBAction)editCurveActivated:(id)sender
{

}

//These are TableView Specific information


- (NSInteger)numberOfSectionsInTableView: (UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [curveLists.curveListObjects count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    curveMath *tmp;
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) 
    {
        cell = [[UITableViewCell alloc] 
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell.
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    //kinda hackish
    tmp = [curveLists.curveListObjects objectAtIndex: [indexPath row]];
    cell.textLabel.text = tmp.curveName;
    [curveLists.curveListObjects objectAtIndex: [indexPath row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if([curveListTable isEditing])
    {
        NSLog(@"editcurve Activated!!!");
        EditCurveViewController *editCurveViewController;
        editCurveViewController = [[EditCurveViewController alloc] init];
        
        
        if((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad))
            editCurveViewController.contentSizeForViewInPopover = CGSizeMake(320.0, 445.0);
        
        
        editCurveViewController.currentCurve = [curveLists.curveListObjects objectAtIndex:indexPath.row];
        editCurveViewController.title = editCurveViewController.currentCurve.curveName;
        editCurveViewController.editingCurve = YES;
        [self.navigationController pushViewController: editCurveViewController animated:YES];
        
    }
    else
    {
        //self.curveDetailViewController = [[CurveDetailViewController alloc] init];
        
        self.curveDetailViewController.selectedCurve = [curveLists.curveListObjects objectAtIndex:indexPath.row];
        self.curveDetailViewController.title = curveDetailViewController.selectedCurve.curveName;
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        {
            [self.curveDetailViewController refreshCurve];
            [self.navigationController pushViewController: self.curveDetailViewController animated:YES];
        }
        else
        {
            [self.curveDetailViewController refreshCurve];
        }
    }
}

-(IBAction)editListPressed:(id)sender
//Update the nav bar button and enable editing - drag view icons slide in
{
    [self enterReorderMode];
}
-(void) enterReorderMode
{
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    self.editButtonItem.style = UIBarButtonItemStyleDone;
    self.editButtonItem.title = @"Done";
    self.editButtonItem.action = @selector(exitReorderMode);
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
	[self.curveListTable setEditing:YES animated: YES];
}

-(void) exitReorderMode
//Update the nab bar button and disable editing - drag view icons slide out
{
    self.navigationItem.rightBarButtonItem.enabled = YES;
    
    self.editButtonItem.style = UIBarButtonItemStylePlain;
    self.editButtonItem.title = @"Edit";
    self.editButtonItem.action = @selector(enterReorderMode);
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
	[self.curveListTable setEditing:NO animated: YES];
	//[self.tableView endUpdates];
    
}

//Implement the reordering
- (void)tableView:(UITableView *)tableView 
    moveRowAtIndexPath:(NSIndexPath *)fromIndexPath 
	  toIndexPath:(NSIndexPath *)toIndexPath
{
	//Get the string from the cell that's being dragged
	curveMath *stringToMove = [[curveLists.curveListObjects objectAtIndex:
							   fromIndexPath.row] retain];
	//Swap it out from the old location
    [curveLists.curveListObjects removeObjectAtIndex:fromIndexPath.row];
	//Swap it in at the new location
    [curveLists.curveListObjects insertObject:stringToMove
					  atIndex:toIndexPath.row];
	//No longer needed
    [stringToMove release];
}

-(void) tableView: (UITableView *)tableView commitEditingStyle: (UITableViewCellEditingStyle) editingStyle forRowAtIndexPath: (NSIndexPath *)indexPath
//This method performs deletions
{
	NSLog(@"Delete");
	[curveLists.curveListObjects removeObjectAtIndex: [indexPath row]];
	[tableView  deleteRowsAtIndexPaths:[NSArray arrayWithObject: indexPath] withRowAnimation:UITableViewRowAnimationLeft];
	[tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.curveListTable reloadData];
}

-(void) LoadSampleCurves
{
    //Curve #1:
    curveMath *curve1 = [[curveMath alloc] initWithName:@"Curve #1"];
    [curve1 addPointX:100 andPointY:100];
    [curve1 addPointX:300 andPointY:430];
    [curve1 addPointX:150 andPointY:140];
    [curve1 addPointX:50.5 andPointY:45];
    [curve1 addPointX:10.4 andPointY:30];
    [curve1 addPointX:310 andPointY:200];
    [curve1 addPointX:160 andPointY:160];
    [curve1 addPointX:165 andPointY:165];
    [curve1 addPointX:170 andPointY:170];
    [curve1 addPointX:143 andPointY:200];
    
    //Curve #2:
    curveMath *curve2 = [[curveMath alloc] initWithName:@"Curve #2"];
    
    //Curve #3:
    curveMath *curve3 = [[curveMath alloc] initWithName:@"Curve #3"];
    
    //Curve #4:
    curveMath *curve4 = [[curveMath alloc] initWithName:@"Curve #4"];
    
    //Curve #5:
    curveMath *curve5 = [[curveMath alloc] initWithName:@"Curve #5"];
    [curve5 addPointX:256 andPointY:262];
    [curve5 addPointX:257 andPointY:260];
    [curve5 addPointX:259 andPointY:262];
    [curve5 addPointX:260 andPointY:255];
    [curve5 addPointX:261 andPointY:260];
    [curve5 addPointX:261 andPointY:262];
    [curve5 addPointX:262 andPointY:270];
    [curve5 addPointX:265 andPointY:266];
    [curve5 addPointX:270 andPointY:270];
    [curve5 addPointX:270 andPointY:267];
    [curve5 addPointX:273 andPointY:285];
    [curve5 addPointX:273 andPointY:276];
    [curve5 addPointX:277 andPointY:273];
    [curve5 addPointX:277 andPointY:276];
    [curve5 addPointX:278 andPointY:278];
    [curve5 addPointX:284 andPointY:280];
    [curve5 addPointX:288 andPointY:288];
    [curve5 addPointX:288 andPointY:287];
    [curve5 addPointX:288 andPointY:282];
    [curve5 addPointX:288 andPointY:281];
    [curve5 addPointX:288 andPointY:292];
    [curve5 addPointX:294 andPointY:293];
    [curve5 addPointX:296 andPointY:284];
    [curve5 addPointX:300 andPointY:286];
    
    //Curve #6:
    curveMath *curve6 = [[curveMath alloc] initWithName:@"Curve #6"];
    
    //Curve #7:
    curveMath *curve7 = [[curveMath alloc] initWithName:@"Curve #7"];
    
    //Curve #8:
    curveMath *curve8 = [[curveMath alloc] initWithName:@"Curve #8"];
        
    //Curve #9:
    curveMath *curve9 = [[curveMath alloc] initWithName:@"Curve #9"];
    [curve9 addPointX:0 andPointY:100];
    [curve9 addPointX:10 andPointY:200];
    [curve9 addPointX:20 andPointY:300];
    [curve9 addPointX:30 andPointY:500];
    [curve9 addPointX: -2 andPointY:560];
    
/*
    [curve9 addPointX:[NSNumber numberWithInt:10] andPointY:[NSNumber numberWithInt:200]];
    [curve9 addPointX:[NSNumber numberWithInt:20] andPointY:[NSNumber numberWithInt:300]];
    [curve9 addPointX:[NSNumber numberWithInt:30] andPointY:[NSNumber numberWithInt:400]];
    [curve9 addPointX:[NSNumber numberWithInt:40] andPointY:[NSNumber numberWithInt:500]];
    [curve9 addPointX:[NSNumber numberWithInt:50] andPointY:[NSNumber numberWithInt:600]];
    [curve9 addPointX:[NSNumber numberWithInt:60] andPointY:[NSNumber numberWithInt:700]];
    [curve9 addPointX:[NSNumber numberWithInt:70] andPointY:[NSNumber numberWithInt:800]];
    [curve9 addPointX:[NSNumber numberWithInt:80] andPointY:[NSNumber numberWithInt:900]];
    [curve9 addPointX:[NSNumber numberWithInt:90] andPointY:[NSNumber numberWithInt:1000]];
    [curve9 addPointX:[NSNumber numberWithInt:100] andPointY:[NSNumber numberWithInt:1100]];
    [curve9 addPointX:[NSNumber numberWithInt:110] andPointY:[NSNumber numberWithInt:1200]];
    [curve9 addPointX:[NSNumber numberWithInt:120] andPointY:[NSNumber numberWithInt:1300]];
    [curve9 addPointX:[NSNumber numberWithInt:130] andPointY:[NSNumber numberWithInt:1400]];
    [curve9 addPointX:[NSNumber numberWithInt:140] andPointY:[NSNumber numberWithInt:1500]];
    [curve9 addPointX:[NSNumber numberWithInt:150] andPointY:[NSNumber numberWithInt:1600]];
    [curve9 addPointX:[NSNumber numberWithInt:160] andPointY:[NSNumber numberWithInt:1700]];
    [curve9 addPointX:[NSNumber numberWithInt:170] andPointY:[NSNumber numberWithInt:1800]];
    [curve9 addPointX:[NSNumber numberWithInt:180] andPointY:[NSNumber numberWithInt:1900]];
    [curve9 addPointX:[NSNumber numberWithInt:190] andPointY:[NSNumber numberWithInt:2000]];//*/
    
    curveLists.curveListObjects =[[NSMutableArray alloc] initWithObjects: curve1, curve2, curve3, curve4, curve5, curve6, curve7, curve8, curve9, nil];
}
@end
