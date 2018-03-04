
//
//  CompanyVC.m
//  NavCtrl
//
//  Created by Jesse Sahli on 2/7/17.
//  Copyright © 2017 Aditya Narayan. All rights reserved.
//

#import "CompanyVC.h"



@interface CompanyVC ()


@end


//  CompanyVC : UIViewController<UITableViewDelegate, UITableViewDataSource>
@implementation CompanyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Allows the cells to be clicked while in editing mode
    self.tableView.allowsSelectionDuringEditing = TRUE;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this VC.
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc]initWithTitle:@"Edit"
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(toggleEditMode)];
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(enterAddMode)];
    
    self.navigationItem.leftBarButtonItem = addButton;
    // Adds the edit button to the right side of the navigation bar
    self.navigationItem.rightBarButtonItem = editButton;
    [editButton release];
  
    // add list of companies to the property in this class using class method on Company Model C.
    self.companyList = [NSMutableArray alloc];
    
    self.companyMC = [CompanyModelController sharedInstance];
    self.companyList = [self.companyMC loadSampleCompanies];
    
    // call for all stock prices here. we need to send the TICKER SYMBOLS , maybe in an array, and get an array back of the stock prices.
    NSMutableArray *tickerSymbols = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.companyList.count; i++) {
        [tickerSymbols addObject:self.companyList[i].ticker];
    }
    
    // need to fix this because of the delegation of view controllers
    //NSArray *stockPrices = [companyMC getStockPrices:tickerSymbols];
    [self.companyMC getStockPrices:tickerSymbols];
  
    /* OLD CODE GIVEN IN SAMPLE PROJECT
    self.companyList = @[@"Apple",
                         @"Samsung",
                         @"Microsoft",
                         @"Google",
                         @"Amazon"];
    */
  
    self.title = @"Stock Tracker";
    
    [tickerSymbols release];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

- (void)enterAddMode {
    self.addEditVC = [[AddEditViewController alloc] init];
    
    // self.addEditVC.company = SET COMPANY HERE
    
    // ADJUST HERE
    self.addEditVC.title = @"Add Company";
    
    /*
    // Creates custom back button that is different than the title of the previous VC
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:nil
                                                                  action:nil]; */
    // self.navigationItem.backBarButtonItem = backButton;
    //[self.navigationController setModalPresentationStyle:UIModalPresentationCurrentContext];
    self.addEditVC.add = TRUE;
    [self presentViewController:self.addEditVC animated:YES completion:nil];
}

- (void)toggleEditMode {
    if (self.tableView.editing) {
        [self.tableView setEditing:NO animated:YES];
        self.navigationItem.rightBarButtonItem.title = @"Edit";
    } else {
        [self.tableView setEditing:YES animated:NO];
        self.navigationItem.rightBarButtonItem.title = @"Done";
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [self.companyList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    Company *comp = [self.companyList objectAtIndex:[indexPath row]];
    cell.textLabel.text = [comp name];
    cell.showsReorderControl = true;
    cell.imageView.image = comp.image;
    cell.detailTextLabel.text = comp.stockPrice;
    
    // This line will eventually add the stock price
    // cell.detailTextLabel.text = @"Hello";
    
    // Uncomment this next line if you would like the cell separator bars to reach the end
    // tableView.separatorInset = UIEdgeInsetsZero;
    
    /*cell.imageView.image = [comp image];
    cell.imageView.frame = CGRectMake(0.0, 0.0, 30, 30);
    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
    cell.imageView.constraints = */
    
    CGSize itemSize = CGSizeMake(30, 30); // Makes a CGSize Object
    UIGraphicsBeginImageContext(itemSize); // we are outside of drawrect?
    CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.width); // creates a CGRect
    [cell.imageView.image drawInRect:imageRect];
    cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
  
    /* OLD CODE FROM ORIGINAL CODE */
    //cell.textLabel.text = [self.companyList objectAtIndex:[indexPath row]];
    
    return cell;
}

// This method increases the height of the table cells.
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */


 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView
moveRowAtIndexPath:(NSIndexPath *)fromIndexPath
       toIndexPath:(NSIndexPath *)toIndexPath {
     
     Company *company = [self.companyList objectAtIndex:fromIndexPath.row];
     [company retain];
     [self.companyList removeObjectAtIndex:fromIndexPath.row];
     [self.companyList insertObject:company atIndex:toIndexPath.row];
     [company release];
 }

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
 forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.companyList removeObjectAtIndex:[indexPath row]];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath]
                              withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)enterEditCompanyMode:(Company*)company AndPath:(NSIndexPath*)path {
    self.addEditVC = [[AddEditViewController alloc] init];
    self.addEditVC.title = @"Edit Company";
    self.addEditVC.fromProductController = FALSE;
    self.addEditVC.add = FALSE;
    self.addEditVC.company = company;
    self.addEditVC.indexPath = path;
    [self presentViewController:self.addEditVC animated:YES completion:nil];
}

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.tableView.editing) {
        Company *company = [self.companyList objectAtIndex:[indexPath row]];
        [self enterEditCompanyMode:company AndPath:indexPath];
    } else {
        self.productViewController = [[ProductVC alloc] init]; // must be matched with dealloc call
        self.productViewController.company = self.companyList[indexPath.row];
        self.productViewController.title = @"Products";
        
        // Creates custom back button that is different than the title of the previous VC
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                                                       style:UIBarButtonItemStylePlain
                                                                      target:nil
                                                                      action:nil];
        self.navigationItem.backBarButtonItem = backButton;
        [self.navigationController
         pushViewController:self.productViewController
         animated:YES];
    }

}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)dealloc {
    [_tableView release];
    [_companyList release];
    //[_tableView release];
    [super dealloc];
}
@end
