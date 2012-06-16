//
//  RootViewController.m
//  Curve
//
//  Created by Bradley Clemetson on 12/10/11.
//  Copyright (c) 2011 Codeprogrammers LLC. All rights reserved.
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


/** Delegate function that removes a specific curve from the CureList.
 @returns nothing
*/
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

/** Loads a Hardcoded list of curve values for debugging purposes till presistent data model
 is created.
 
 @warning This is a debugging method and will be removed upon release.
 @returns nothing
 
*/
-(void) LoadSampleCurves
{  
    
    curveMath *curve1 = [[curveMath alloc] initWithName:@"Curve #1"];
    
    [curve1 addPointX: 300 andPointY: 430];
    [curve1 addPointX: 150 andPointY: 140];
    [curve1 addPointX: 50.5 andPointY: 45];
    [curve1 addPointX: 10.4 andPointY: 30];
    [curve1 addPointX: 310 andPointY: 200];
    [curve1 addPointX:160 andPointY:160];
    [curve1 addPointX:143 andPointY:200];
    [curve1 sort];
    [curve1 fitCurve];
    
    curveMath *curve2 = [[curveMath alloc] initWithName:@"Curve #2"];
    for (int i=0; i<45; i++) 
    {
        [curve2 addPointX:rand() andPointY:rand()];
        
    }
    
    curveMath *curve3 = [[curveMath alloc] initWithName:@"Curve #3"];
    for (int i=0; i<100; i++) 
    {
        [curve3 addPointX:rand() andPointY:rand()];
    }
    
    curveMath *curve4 = [[curveMath alloc] initWithName:@"Curve #4"];
    
    [curve4 addPointX:257 andPointY:260];
    [curve4 addPointX:259 andPointY:262];
    [curve4 addPointX:260 andPointY:255];
    [curve4 addPointX:261 andPointY:255];
    [curve4 addPointX:262 andPointY:255];
    [curve4 sort];
    
    curveMath *curve5 = [[curveMath alloc] initWithName:@"Curve #5"];
    [curve5 addPointX:1 andPointY:1];
    
    curveMath *curve6 = [[curveMath alloc] initWithName:@"Curve #6"];
    [curve6 addPointX:0 andPointY:0];
    
    curveMath *curve7 = [[curveMath alloc] initWithName:@"Curve #7"];
    [curve7 addPointX:0 andPointY:0];
    [curve7 addPointX:1 andPointY:1];
    [curve7 addPointX:2 andPointY:2];
    [curve7 addPointX:3 andPointY:3];
    [curve7 addPointX:4 andPointY:4];
    [curve7 addPointX:5 andPointY:5];
    [curve7 sort];
    
    curveMath *curve8 = [[curveMath alloc] initWithName:@"Curve #8"];
    [curve8 addPointX: -1 andPointY:-1];
    [curve8 addPointX:-2 andPointY:-2];
    [curve8 addPointX:4 andPointY:34];
    [curve8 sort];
    
    curveMath *curve9 = [[curveMath alloc] initWithName:@"Curve #9"];
    
    [curve9 addPointX:0 andPointY:100];
    [curve9 addPointX:10 andPointY:200];
    [curve9 addPointX:20 andPointY:300];
    [curve9 addPointX:30 andPointY:500];
    [curve9 addPointX: -2 andPointY:560];
    [curve9 sort];
    
    curveLists.curveListObjects =[[NSMutableArray alloc] initWithObjects: curve1, curve2, curve3, curve4, curve5, curve6, curve7, curve8, curve9, nil];
}
@end
