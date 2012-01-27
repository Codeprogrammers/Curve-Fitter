//
//  EditCurveViewController.m
//  Curve
//
//  Created by Bradley Clemetson on 12/15/11.
//  Copyright (c) 2011 Codeprogrammers for Gonzaga University. All rights reserved.
//

/*
 * lots of problems here.. 
 * ####1st things to do are as follows:######
 * 1) fix this function: "- (UITableViewCell *)tableView:(UITableView *)tableView 
 *              cellForRowAtIndexPath:(NSIndexPath *)indexPath"
 *   a) specifically change the additon of a point to only be possible when editing
 *       this will automatically fix many bugs and eliminate excess code.
 *   b) see example for help if get stuck on this.
 * 2) clean up this complete mess haha..
 */

#import "EditCurveViewController.h"
#import "PointXY.h"

static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 162;

@implementation EditCurveViewController

@synthesize modalNavigationBar/*, cancelButton, editButton, doneButton*/;
@synthesize curveName, curveXYPoints, pointCell;
@synthesize currentCurve;
@synthesize editingCurve;

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
    //Edit button:
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStyleBordered target:self action:@selector(EditTable:)];
	[self.navigationItem setRightBarButtonItem:editButton];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its 
    
//    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addItem:)];
//    self.navigationItem.rightBarButtonItem = addButton;
    
    curveLists = [CurveArray shared];
    
    if(editingCurve == NO)
    {
        modalNavigationBar.topItem.title = @"New Curve";
        currentCurve = [[curveMath alloc] init];
//        doneButton.enabled = NO;
        self.curveXYPoints.frame = CGRectMake(0, 45, 320, 416); 
    }
    else
    {
        modalNavigationBar.topItem.title = currentCurve.curveName;
        curveName.text = currentCurve.curveName;
        modalNavigationBar.hidden = YES;
        self.curveXYPoints.frame = CGRectMake(0, 0, 320, 460); 
    }
}

- (IBAction)cancelPressed:(id)sender
{
    NSLog(@"Cancel Pressed");
    [super dismissModalViewControllerAnimated:YES];
}

- (IBAction)donePressed:(id)sender
{
    NSLog(@"Done Pressed");
    if(editingCurve == NO)
    {
        [curveLists.curveListObjects addObject: currentCurve];
    }
    [super dismissModalViewControllerAnimated:YES];
    [self release];
}

/*- (IBAction)shouldAllowDone:(id)sender
{
    if([curveName.text length] <= 0)
        doneButton.enabled = NO;
    else
        doneButton.enabled = YES;
}*/
- (IBAction)updateTitle:(id)sender
{
    if([curveName.text length] <= 0)
        modalNavigationBar.topItem.title = @"New Curve";
    else
    {
        modalNavigationBar.topItem.title = curveName.text;
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (BOOL)textView:(UITextView *)txtView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text 
    {
    if( [text rangeOfCharacterFromSet:[NSCharacterSet newlineCharacterSet]].location == NSNotFound )
    {
        return YES;
    }
    
    [txtView resignFirstResponder];
    return NO;
}

//TableView Specific information
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger)section
{//this may be wrong..#####
    // Return the number of rows in the section.
/*    if (editingCurve == NO) 
        return 1;
    else
        return [currentCurve.dataPoints count] + 1;//*/
    int count = [currentCurve.dataPoints count];
	if(self.editing) count++;
	return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    //this function causing problems with editing/adding a new point..###########
    static NSString *CellIdentifier = @"Cell";
    
    //NSLog(@"Creating Cell Row: %i", indexPath.row + 1);
    PointCell *cell = (PointCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil)
    {
        [[NSBundle mainBundle] loadNibNamed:@"PointCell" owner:self options:nil];
        cell = pointCell;
        //self.pointCell = nil;
    //partial fix for editing/adding new point:
        //cell.xPoint.text = [NSString stringWithFormat:@"0"];
        //cell.yPoint.text = [NSString stringWithFormat:@"1"];
        //[self.pointCell.xPoint setText:[NSString stringWithFormat:@"0"]];
        //[self.pointCell.yPoint setText:[NSString stringWithFormat:@"0"]];
    }
    if(indexPath.row == ([self.currentCurve.dataPoints count]))
    {

    }
    else
    if (self.editingCurve == YES)
    {
        cell.xPoint.text = [NSString stringWithFormat:@"%.12g", [[currentCurve.dataPoints objectAtIndex: [indexPath row]] pointX]];
        cell.yPoint.text = [NSString stringWithFormat:@"%.12g", [[currentCurve.dataPoints objectAtIndex: [indexPath row]] pointY]];
//        cell.xPoint.tag = indexPath.row + 1;
//        cell.yPoint.tag = indexPath.row + 1;
    }
//
    int count = 0;
	if(self.editing && indexPath.row != 0)
		count = 1;
    NSString * nsLog = [NSString stringWithFormat:@"%i,%i",indexPath.row,(indexPath.row-count)];
	NSLog(nsLog);
	// Set up the cell...
	if(indexPath.row == ([currentCurve.dataPoints count]) && self.editing)
	{
//        [self.pointCell.xPoint setText:[NSString stringWithFormat:@"0"]];
//        [self.pointCell.yPoint setText:[NSString stringWithFormat:@"0"]];
        //cell.xPoint.text = @"ADD";
        //cell.yPoint.text = @"ADD";
		return cell;
	}
//
    //These two line require iOS 4.2
    cell.xPoint.keyboardType = UIKeyboardTypeDecimalPad;
    cell.yPoint.keyboardType = UIKeyboardTypeDecimalPad;
    
//    cell.xPoint.text = [currentCurve.dataPoints objectAtIndex:indexPath.row];
//    cell.yPoint.text = [currentCurve.dataPoints objectAtIndex:indexPath.row];
    return cell;
}

- (IBAction)curveNameDidFinishedit:(id)sender
{
    currentCurve.curveName = self.curveName.text;
}


- (IBAction)updatePoint:(id)sender
{
    //problems here too.. ########
    NSLog(@"Point has been called");
    if([sender isKindOfClass:[UITextField class]])
    {
        NSNumberFormatter *string2NSNumber = [[NSNumberFormatter alloc] init];
        [string2NSNumber setFormatterBehavior: NSNumberFormatterBehavior10_4];
        [string2NSNumber setFormatterBehavior:NSNumberFormatterDecimalStyle];
        
        NSLog(@"The Sender of this object is a UITextFeild!!");
        //((UITextField *) sender).text = @"Hello WORLD!";
        NSLog(@"Text to insert: %@", ((UITextField *) sender).text);
        //[curveLists.curveListObjects replaceObjectAtIndex:((UITextField *) sender).tag withObject:((UITextField *) sender).text];
        [curveLists.curveListObjects replaceObjectAtIndex:((UITextField *) sender).tag withObject:[string2NSNumber numberFromString: ((UITextField *) sender).text]];
    }
}

/*- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [Table setEditing:editing animated:YES];
    if (editing) {
        addButton.enabled = NO;
    } else {
        addButton.enabled = YES;
    }
}//*/
/*
- (IBAction)AddButtonAction:(id)sender
{
    ///////
    PointXY * newPoint; 
    [newPoint setPointX:0 andPointY:0];
	[currentCurve.dataPoints addObject:newPoint];
	[Table reloadData];
}
- (IBAction)DeleteButtonAction:(id)sender
{
	[currentCurve.dataPoints removeLastObject];
	[Table reloadData];
}//*/

- (IBAction) EditTable:(id)sender
{
	if(self.editing)
	{
		[super setEditing:NO animated:NO]; 
		[Table setEditing:NO animated:NO];
		[Table reloadData];                     
		[self.navigationItem.rightBarButtonItem setTitle:@"Edit"];
		[self.navigationItem.rightBarButtonItem setStyle:UIBarButtonItemStylePlain];
	}
	else
	{
		[super setEditing:YES animated:YES]; 
		[Table setEditing:YES animated:YES];
		[Table reloadData];
		[self.navigationItem.rightBarButtonItem setTitle:@"Done"];
		[self.navigationItem.rightBarButtonItem setStyle:UIBarButtonItemStyleDone];
	}
}

// The editing style for a row is the kind of button displayed to the left of the cell when in editing mode.
- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    // No editing style if not editing or the index path is nil.
    if (self.editing == NO || !indexPath) return UITableViewCellEditingStyleNone;
    // Determine the editing style based on whether the cell is a placeholder for adding content or already 
    // existing content. Existing content can be deleted.  
    //NSUInteger count = ([currentCurve.dataPoints count] + 1);
    //if(self.editingCurve) return UITableViewCellEditingStyleInsert;
    if (self.editing && (indexPath.row == ([currentCurve.dataPoints count]))) {
		return UITableViewCellEditingStyleInsert;
	} else {
		return UITableViewCellEditingStyleDelete;
	}
    return UITableViewCellEditingStyleNone;
}

-(void) tableView: (UITableView *)tableView commitEditingStyle: (UITableViewCellEditingStyle) editingStyle forRowAtIndexPath: (NSIndexPath *)indexPath
//This method performs deletions
{
    //Delete:   //works great
    if(editingStyle == UITableViewCellEditingStyleDelete) {
        NSLog(@"Delete Point");
        [currentCurve.dataPoints removeObjectAtIndex:indexPath.row];
     //   [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    } else
    //Insert:   //should work but never called, see above function^^ 
    if(editingStyle == UITableViewCellEditingStyleInsert) {
        NSLog(@"Insert Point");
        PointXY * newPoint; 
        [newPoint setPointX:0 andPointY:0];
        [currentCurve.dataPoints insertObject:newPoint atIndex:[currentCurve.dataPoints count]];
     //   [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationRight];//*/
    }
    
    [tableView reloadData];
}

#pragma mark Row reordering
// Determine whether a given row is eligible for reordering or not.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

#pragma mark -
#pragma mark UITextFieldDelegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
	return YES;
}

@end
