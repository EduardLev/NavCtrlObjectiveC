//
//  ProductVC.m
//  NavCtrl
//
//  Created by Jesse Sahli on 2/7/17.
//  Copyright © 2017 Aditya Narayan. All rights reserved.
//

#import "ProductVC.h"

@interface ProductVC ()

@end

@implementation ProductVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Allows the cells to be clicked while in editing mode
    self.tableView.allowsSelectionDuringEditing = TRUE;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this VC.
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc]initWithTitle:@"Edit"
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(toggleEditMode)];
    
    UIBarButtonItem *addButton= [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(enterAddMode)];
                      
    // Adds the edit button to the right side of the navigation bar
    self.navigationItem.rightBarButtonItems = @[editButton, addButton];
    [editButton release];
    [addButton release];
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

-(void)enterAddMode {
    self.addEditVC = [[AddEditViewController alloc] init];
    
    // self.addEditVC.company = SET PRODUCT HERE
    
    // ADJUST HERE
    self.addEditVC.title = @"Add Product";
    
    self.addEditVC.fromProductController = TRUE;
    self.addEditVC.add = TRUE;
    
    /*
     // Creates custom back button that is different than the title of the previous VC
     UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back"
     style:UIBarButtonItemStylePlain
     target:nil
     action:nil]; */
    // self.navigationItem.backBarButtonItem = backButton;
    //[self.navigationController setModalPresentationStyle:UIModalPresentationCurrentContext];
    [self presentViewController:self.addEditVC animated:YES completion:nil];
}

-(void)enterEditProductMode:(Product*)product AndPath:(NSIndexPath*)path {
    self.addEditVC = [[AddEditViewController alloc] init];
    self.addEditVC.title = @"Edit Product";
    self.addEditVC.fromProductController = TRUE;
    self.addEditVC.add = FALSE;
    self.addEditVC.product = product;
    self.addEditVC.company = self.company;
    self.addEditVC.indexPath = path;
    [self presentViewController:self.addEditVC animated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSLog(@"%@",self.company);
    
    /* OLD CODE FROM ORIGINAL
    if ([self.title isEqualToString:@"Apple mobile devices"]) {
        self.products = @[@"iPad", @"iPod Touch",@"iPhone"];
    } else {
        self.products = @[@"Galaxy S4", @"Galaxy Note", @"Galaxy Tab"];
    }*/
    
    [self.tableView reloadData];
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
    return [self.company.products count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    // Configure the cell...
    
    Product *product = [self.company.products objectAtIndex:[indexPath row]];
    cell.textLabel.text = [product name];
    cell.showsReorderControl = true;
    
    CGSize itemSize = CGSizeMake(30, 30); // Makes a CGSize Object
    UIGraphicsBeginImageContext(itemSize); // we are outside of drawrect?
    CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.width); // creates a CGRect
    [[product image] drawInRect:imageRect];
    cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    /* OLD CODE FROM ORIGINAL
    cell.textLabel.text = [self.products objectAtIndex:[indexPath row]]; */
    return cell;
}

// This method increases the height of the table cells.
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.company.products removeObjectAtIndex:[indexPath row]];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath]
                              withRowAnimation:UITableViewRowAnimationFade];
    }
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

 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */


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
moveRowAtIndexPath:(NSIndexPath *)fromIndexPath
      toIndexPath:(NSIndexPath *)toIndexPath {
    
    Product *product = [self.company.products objectAtIndex:fromIndexPath.row];
    [product retain];
    [self.company.products removeObjectAtIndex:fromIndexPath.row];
    [self.company.products insertObject:product atIndex:toIndexPath.row];
    [product release];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.tableView.editing) {
        // show add edit VC with data filled in.
        Product *product = [self.company.products objectAtIndex:[indexPath row]];
        [self enterEditProductMode:product AndPath:indexPath];
    } else {
        self.webVC = [[WebViewController alloc] init];
        self.webVC.title = @"Browse";
        [self.navigationController pushViewController:self.webVC animated:YES];
    }
    
}

- (void)dealloc {
    [_webVC release];
    [_company release];
    [_tableView release];
    [super dealloc];
}
@end
