//
//  GraphDetailViewController.m
//  Curve
//
//  Created by Bradley C. on 1/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GraphDetailViewController.h"

@implementation GraphDetailViewController
@synthesize pickerActions;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
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
    
    lineStyles = [[NSMutableArray alloc] init];
    [lineStyles addObject:@"Solid"];
    [lineStyles addObject:@"Dashed"];
    
    lineColors = [[NSMutableArray alloc] init];
	[lineColors addObject:@"Blue"];
	[lineColors addObject:@"Brown"];
	[lineColors addObject:@"Green"];
	[lineColors addObject:@"Orange"];
	[lineColors addObject:@"Purple"];
	[lineColors addObject:@"Red"];
	[lineColors addObject:@"White"];
    [lineColors addObject:@"Yellow"];
    
    graphStyles = [[NSMutableArray alloc] init];
    [graphStyles addObject:@"Dark Gradient"];
    [graphStyles addObject:@"Plain Black"];
    [graphStyles addObject:@"Plain White"];
    [graphStyles addObject:@"Slate"];
    [graphStyles addObject:@"Stocks"];
    
    // Do any additional setup after loading the view from its nib.
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
    return YES;
}

- (NSInteger)numberOfSectionsInTableView: (UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) 
    {
        cell = [[UITableViewCell alloc] 
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CellIdentifier];
    }
    
    if(indexPath.row == 0)
    cell.textLabel.text = @"Graph Line Style";
    else
    if(indexPath.row == 1)
        cell.textLabel.text = @"Graph Point Style";
    else
    if(indexPath.row == 2)
        cell.textLabel.text = @"Graph Theme";
    else
        cell.textLabel.text = @"Graph Options!";  
    //[curveLists.curveListObjects objectAtIndex: [indexPath row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    
       /* //self.curveDetailViewController = [[CurveDetailViewController alloc] init];
        
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
        */
    pickerActions = [[UIActionSheet alloc] initWithTitle:nil 
                                                             delegate:nil
                                                    cancelButtonTitle:nil
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:nil];
    
    [pickerActions setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
    
    CGRect pickerFrame = CGRectMake(0, 40, 0, 0);
    
    UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:pickerFrame];
    pickerView.showsSelectionIndicator = YES;
    
    pickerView.dataSource = self;
    pickerView.delegate = self;
    
    [pickerActions addSubview:pickerView];
    [pickerView release];
    
    UISegmentedControl *closeButton = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObject:@"Done"]];
    closeButton.momentary = YES; 
    closeButton.frame = CGRectMake(260, 7.0f, 50.0f, 30.0f);
    closeButton.segmentedControlStyle = UISegmentedControlStyleBar;
    closeButton.tintColor = [UIColor blackColor];
    [closeButton addTarget:self action:@selector(dismissSheet) forControlEvents:UIControlEventValueChanged];
    [pickerActions addSubview:closeButton];
    [closeButton release];
    
    [pickerActions showInView:[[UIApplication sharedApplication] keyWindow]];
    
    [pickerActions setBounds:CGRectMake(0, 0, 320, 485)];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    
}

-(void)dismissSheet
{
    if (pickerActions)
    {
        [pickerActions dismissWithClickedButtonIndex:0 animated:YES];
    }
}


#pragma mark -
#pragma mark Picker View Methods


//Sets the number of wheels
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
	
	return 3;
}

//Sets the number of items per wheel
- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component 
{
    if(component == 0)
    {
        return [lineStyles count];
    }
    else
	if(component == 1)
    {
        return [lineColors count];
    }
    else
    if(component == 2)
    {
        return 7;
    }
    else
    return 0;
}

//A datasource method that sets the items in each wheel
//Component specifies the wheel
//Row sets each row item
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{ 

	if(component == 1) 
    {
        return [lineColors objectAtIndex:row];
    } 
    else
    if(component == 2)
    {
        return [NSString stringWithFormat: @"%d", ((row+1) * 4)];
	}
    else
    {
        return [lineStyles objectAtIndex:row];
    }
}


- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component 
{
	
	//NSLog(@"Selected Color: %@. Index of selected color: %i", [lineColors objectAtIndex:row], row);
}

@end
