
//
//  CompanyVC.m
//  NavCtrl
//
//  Created by Jesse Sahli on 2/7/17.
//  Copyright © 2017 Aditya Narayan. All rights reserved.
//

#import "CompanyVC.h"

@interface CompanyVC ()

@property (nonatomic, retain) CompanyModelController *companyMC;
@property (nonatomic, retain) AddEditViewController *addEditVC;
@property (nonatomic, retain) ProductVC *productVC;

@end

//  CompanyVC : UIViewController<UITableViewDelegate, UITableViewDataSource>
@implementation CompanyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Creates the shared instance of the data model controller
    self.companyMC = [CompanyModelController sharedInstance];
    
    // Creates the navigation buttons and sets the color of the navigation bar
    [self customizeNavigationBar];

    // Allows the cells to be clicked while in editing mode
    self.tableView.allowsSelectionDuringEditing = TRUE;
    
    [self toggleCompanyView];
}

- (void)customizeNavigationBar {
    self.title = @"Stock Tracker";
    
    // Changes the navigation bar colors to match given design
    self.navigationController.navigationBar.barTintColor =
    [UIColor colorWithRed:128.0/255 green:179.0/255 blue:66.0/255 alpha:1.0];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    // Creates the edit and add buttons on the top. Links to their action functions
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Edit"
                                   style:UIBarButtonItemStylePlain
                                   target:self
                                   action:@selector(toggleEditMode)];
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc]
                                initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                  target:self
                                  action:@selector(enterAddMode)];
    
    self.navigationItem.rightBarButtonItem = addButton;
    self.navigationItem.leftBarButtonItem = editButton;
    [editButton release];
    [addButton release];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    // Check to see which view to show the user
    [self toggleCompanyView];
    
    [self.tableView reloadData];
    
    // Create a notificaiton observer that will check when the stock prices have been updated
    // Calls for tableView to reload the data when it recieves the notification
    [[NSNotificationCenter defaultCenter] addObserverForName:@"stockPricesUpdated"
                                                      object:nil
                                                       queue:nil
                                                  usingBlock:^(NSNotification * _Nonnull note) {
                                                     [self.tableView reloadData]; }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:@"imageFetchSuccess"
                                                      object:nil
                                                       queue:nil
                                                  usingBlock:^(NSNotification * _Nonnull note) {
                                                      [self.tableView reloadData]; }];
    
    // Create timer for stock prices
    NSTimeInterval refreshRate = 60.0;
    self.stockTimer = [NSTimer scheduledTimerWithTimeInterval:refreshRate
                                                       target:self.companyMC
                                                     selector:@selector(getStockPrices)
                                                     userInfo:nil
                                                      repeats:YES];
    
    [self.companyMC getStockPrices]; // call it once immediately
    //[self.tableView reloadData];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    // removes timers and notifications
    [self.stockTimer invalidate];
    [[NSNotificationCenter defaultCenter] removeObserver:@"stockPricesUpdated"];
}

- (void)enterAddMode {
    _addEditVC = [[AddEditViewController alloc] init];
    self.addEditVC.title = @"Add Company"; // very important for logic of addEditVC
    
    // CHANGE ANIMATION TYPE HERE
    /*
    CATransition *transition = [CATransition animation];
    transition.duration = 0.5;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    transition.type = kCATransitionFade; //kCATransitionMoveIn; //, kCATransitionPush, kCATransitionReveal, kCATransitionFade
    transition.subtype = kCATransitionFromTop; //kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
    [self.navigationController.view.layer addAnimation:transition forKey:nil]; */

    [self.navigationController pushViewController:self.addEditVC animated:YES];
}

- (void)toggleEditMode {
    if ([self.companyMC.companyList count] == 0) {
        return;
    }

    if (self.tableView.editing) {
        [self.tableView setEditing:NO animated:YES];
        self.navigationItem.leftBarButtonItem.title = @"Edit";
    } else {
        [self.tableView setEditing:YES animated:NO];
        self.navigationItem.leftBarButtonItem.title = @"Done";
    }
}

// Add Company button that is only shown on the initial blank page
- (IBAction)addButtonDidTouchUpInside:(UIButton *)sender {
    [self enterAddMode];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.companyMC.companyList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                       reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    // 1 - Get the company by calling the correct row
    // 2 - Create the text label by accessing the name and ticker properties
    // 3 - get the image by accessing the image string property
    // 4 - create the detail text label by accessing the stock price property
    Company *comp = [self.companyMC.companyList objectAtIndex:[indexPath row]];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ (%@)", comp.name, comp.ticker];
    cell.showsReorderControl = TRUE;
    
    cell.imageView.image = (comp.companyLogoFilepath == nil) ?
    [UIImage imageNamed:comp.name] :
    [UIImage imageWithContentsOfFile:comp.companyLogoFilepath];
    
    float price = [comp.stockPrice floatValue];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"$%0.2f", price];
    if (price == 0) {
        cell.detailTextLabel.text = @"Loading...";
    }
    cell.detailTextLabel.textColor = UIColor.grayColor;
    
    // Uncomment this next line if you would like the cell separator bars to reach the end
     tableView.separatorInset = UIEdgeInsetsZero;
    
    // Creates custom frame for the imageView on the table view cell.
    CGSize itemSize = CGSizeMake(50, 50); // Makes a CGSize Object
    UIGraphicsBeginImageContext(itemSize); // we are outside of drawrect?
    CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.width); // creates a CGRect
    [cell.imageView.image drawInRect:imageRect];
    cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return cell;
}

// This method increases the height of the table cells.
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView
moveRowAtIndexPath:(NSIndexPath *)fromIndexPath
       toIndexPath:(NSIndexPath *)toIndexPath {
     Company *company = [self.companyMC.companyList objectAtIndex:fromIndexPath.row];
     [company retain];
     [self.companyMC moveCompany:company FromIndex:fromIndexPath ToIndex:toIndexPath];
     //[self.companyMC.companyList removeObjectAtIndex:fromIndexPath.row];
     //[self.companyMC.companyList insertObject:company atIndex:toIndexPath.row];
     [company release];     
 }

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
 forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.companyMC removeCompany:[self.companyMC.companyList objectAtIndex:[indexPath row]]];
        // Removes cell in table view
        [self.tableView deleteRowsAtIndexPaths:@[indexPath]
                              withRowAnimation:UITableViewRowAnimationFade];
    }
    [self toggleCompanyView];
}

// If the companyList array in the data model object is empty, then show the empty view
- (void)toggleCompanyView {
    if ([self.companyMC.companyList count] != 0) {
        self.emptyView.hidden = TRUE;
    } else {
        self.emptyView.hidden = FALSE;
    }
}

- (void)enterEditCompanyMode:(Company*)company {
    _addEditVC = [[AddEditViewController alloc] init];
    self.addEditVC.title = @"Edit Company";
    self.addEditVC.company = company;
    
    // CHANGE ANIMATION TYPE HERE
    /*
     CATransition *transition = [CATransition animation];
     transition.duration = 0.5;
     transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
     transition.type = kCATransitionFade; //kCATransitionMoveIn; //, kCATransitionPush, kCATransitionReveal, kCATransitionFade
     transition.subtype = kCATransitionFromTop; //kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
     [self.navigationController.view.layer addAnimation:transition forKey:nil]; */
    
    [self.navigationController pushViewController:self.addEditVC animated:TRUE];
}

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    Company *comp = self.companyMC.companyList[indexPath.row];
    comp.order = indexPath.row;
    
    if (self.tableView.editing) {
        // If the table view is in editing mode, save the company that the user selected
        // And then send that company and index path to 'enterEditCompanyMode'
        [self enterEditCompanyMode:comp];
    } else {
        // If table view is not in editing mode, create new product view controller
        // and pass along the company selected. It is important to change the title
        // So that the view controller can decide what it has to be showing
        _productVC = [[ProductVC alloc] init]; // must be matched with dealloc call
        self.productVC.company = comp;
        self.productVC.title = comp.name;
        [self.navigationController pushViewController:self.productVC animated:YES];
    }
}

- (void)dealloc {
    [_tableView release];
    [_emptyView release];
    [_companyMC release];
    [_addEditVC release];
    [_stockTimer release];
    [_productVC release];
    [super dealloc];
}


@end
