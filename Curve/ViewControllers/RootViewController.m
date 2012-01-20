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
    NSMutableArray *curvex = [[NSMutableArray alloc] initWithObjects: [NSNumber numberWithFloat:100],
                              [NSNumber numberWithFloat:300],
                              [NSNumber numberWithFloat:150],
                              [NSNumber numberWithFloat:50.5],
                              [NSNumber numberWithFloat:10.4],
                              [NSNumber numberWithFloat:310],
                              [NSNumber numberWithFloat:160],
                              [NSNumber numberWithFloat:165],
                              [NSNumber numberWithFloat:170],
                              [NSNumber numberWithFloat:143], nil];
    NSMutableArray *curvey = [[NSMutableArray alloc] initWithObjects: [NSNumber numberWithFloat:100],
                             [NSNumber numberWithFloat:430],
                             [NSNumber numberWithFloat:140],
                             [NSNumber numberWithFloat:45],
                             [NSNumber numberWithFloat:30],
                             [NSNumber numberWithFloat:200],
                             [NSNumber numberWithFloat:160],
                             [NSNumber numberWithFloat:165],
                             [NSNumber numberWithFloat:170],
                             [NSNumber numberWithFloat:200], nil];    
    
    curveMath *curve1 = [[curveMath alloc] initWithName:@"Curve #1" withXPoints:curvex andwithYPoints:curvey];
    
    curvex = [[NSMutableArray alloc] init];
    for (int i=0; i<40; i++) {
        NSNumber *num = [NSNumber numberWithFloat:i];
        [curvex addObject:num];
    }
    curvey = [[NSMutableArray alloc] init];
    for (int i=0; i<40; i++) {
        NSNumber *num = [NSNumber numberWithFloat:i*11];
        [curvey addObject:num];
    }
    curveMath *curve2 = [[curveMath alloc] initWithName:@"Curve #2" withXPoints:curvex andwithYPoints:curvey];
    for (int i=0; i<45; i++) {
        NSNumber *num = [NSNumber numberWithFloat:rand()];
        [curvex addObject:num];
    }
    for (int i=0; i<45; i++) {
        NSNumber *num = [NSNumber numberWithFloat:rand()];
        [curvey addObject:num];
    }
    curveMath *curve3 = [[curveMath alloc] initWithName:@"Curve #3" withXPoints:curvex andwithYPoints:curvey];
    
    curvex = [[NSMutableArray alloc] init];
    for (int i=0; i<100; i++) {
        NSNumber *num = [NSNumber numberWithFloat:rand()];
        [curvex addObject:num];
    }
    curvey = [[NSMutableArray alloc] init];
    for (int i=0; i<100; i++) {
        NSNumber *num = [NSNumber numberWithFloat:rand()];
        [curvey addObject:num];
    }
    curveMath *curve4 = [[curveMath alloc] initWithName:@"Curve #4" withXPoints:curvex andwithYPoints:curvey];
    
    curvex = [[NSMutableArray alloc] initWithObjects: [NSNumber numberWithFloat:256],
              [NSNumber numberWithFloat:257],
              [NSNumber numberWithFloat:259],
              [NSNumber numberWithFloat:260],
              [NSNumber numberWithFloat:261],
              [NSNumber numberWithFloat:261],
              [NSNumber numberWithFloat:262],
              [NSNumber numberWithFloat:265],
              [NSNumber numberWithFloat:270],
              [NSNumber numberWithFloat:270],
              [NSNumber numberWithFloat:273],
              [NSNumber numberWithFloat:273],
              [NSNumber numberWithFloat:277],
              [NSNumber numberWithFloat:277],
              [NSNumber numberWithFloat:278],
              [NSNumber numberWithFloat:284],
              [NSNumber numberWithFloat:288],              
              [NSNumber numberWithFloat:288],
              [NSNumber numberWithFloat:288],
              [NSNumber numberWithFloat:288],
              [NSNumber numberWithFloat:288],
              [NSNumber numberWithFloat:294],
              [NSNumber numberWithFloat:296],
              [NSNumber numberWithFloat:300], nil];
    curvey = [[NSMutableArray alloc] initWithObjects:[NSNumber numberWithFloat:262],
              [NSNumber numberWithFloat:260],
              [NSNumber numberWithFloat:262],
              [NSNumber numberWithFloat:255],
              [NSNumber numberWithFloat:260],
              [NSNumber numberWithFloat:262],
              [NSNumber numberWithFloat:270],
              [NSNumber numberWithFloat:266],
              [NSNumber numberWithFloat:270],
              [NSNumber numberWithFloat:267],
              [NSNumber numberWithFloat:285],
              [NSNumber numberWithFloat:276],
              [NSNumber numberWithFloat:273],
              [NSNumber numberWithFloat:276],
              [NSNumber numberWithFloat:278],
              [NSNumber numberWithFloat:280],
              [NSNumber numberWithFloat:288],
              [NSNumber numberWithFloat:287],              
              [NSNumber numberWithFloat:282],
              [NSNumber numberWithFloat:281],
              [NSNumber numberWithFloat:292],
              [NSNumber numberWithFloat:293],
              [NSNumber numberWithFloat:284],
              [NSNumber numberWithFloat:286], nil];
    
    
    curveMath *curve5 = [[curveMath alloc] initWithName:@"Curve #5" withXPoints:curvex andwithYPoints:curvey];
    curveMath *curve6 = [[curveMath alloc] initWithName:@"Curve #6"];
    curveMath *curve7 = [[curveMath alloc] initWithName:@"Curve #7"];
    curveMath *curve8 = [[curveMath alloc] initWithName:@"Curve #8"];
    curveMath *curve9 = [[curveMath alloc] initWithName:@"Curve #9"];
    
    
    [curve9 addPointX:[NSNumber numberWithInt:0] andPointY:[NSNumber numberWithInt:100]];
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
    [curve9 addPointX:[NSNumber numberWithInt:190] andPointY:[NSNumber numberWithInt:2000]];
    
    
    curveLists.curveListObjects =[[NSMutableArray alloc] initWithObjects: curve1, curve2, curve3, curve4, curve5, curve6, curve7, curve8, curve9, nil];
}
@end
