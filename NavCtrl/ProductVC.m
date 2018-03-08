//
//  ProductVC.m
//  NavCtrl
//
//  Created by Jesse Sahli on 2/7/17.
//  Copyright © 2017 Aditya Narayan. All rights reserved.
//

#import "ProductVC.h"

@interface ProductVC ()

@property (nonatomic, retain) CompanyModelController *companyMC;

@end

@implementation ProductVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter] addObserverForName:@"imageFetchSuccess"
                                                      object:nil
                                                       queue:nil
                                                  usingBlock:^(NSNotification * _Nonnull note) {
                                                      [self.tableView reloadData]; }];
    
    self.topImageView.image = (self.company.companyLogoFilepath == nil) ? [UIImage imageNamed:self.company.name] :
        [UIImage imageWithContentsOfFile:self.company.companyLogoFilepath];
    
    // Creates the shared instance of the data model controller
    self.companyMC = [CompanyModelController sharedInstance];
    
    // Allows the cells to be clicked while in editing mode
    self.tableView.allowsSelectionDuringEditing = TRUE;
    
    UIBarButtonItem *addButton= [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                             target:self
                             action:@selector(enterAddMode)];
    self.navigationItem.rightBarButtonItem = addButton;
    [addButton release];
    
    // Sets the top label to be the company name
    self.topLabelText.text = [NSString stringWithFormat:@"%@ (%@)",
                              self.company.name,self.company.ticker];
    
    [self toggleProductView];
    
    UIImage *backImage = [UIImage imageNamed:@"btn-navBack"];
    // Creates custom back button with arrow image
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                   initWithImage:backImage
                                   style:UIBarButtonItemStylePlain
                                   target:self
                                   action:@selector(back)];
    self.navigationItem.leftBarButtonItem = backButton;
}

// Called when back button is pressed
- (void)back {
    // INSERT ANIMATION HERE
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)toggleProductView {
    if ([self.company.products count] != 0) {
        self.emptyView.hidden = TRUE;
    } else {
        self.emptyView.hidden = FALSE;
    }
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

- (void)enterAddMode {
    _addEditVC = [[AddEditViewController alloc] init];
    self.addEditVC.title = @"Add Product"; // very important for logic of addEditVC
    self.addEditVC.company = self.company;
    
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

- (IBAction)addProductButtonDidTouchUpInside:(UIButton *)sender {
    [self enterAddMode];
}

/*
-(void)enterEditProductMode:(Product*)product {
    self.addEditVC = [[AddEditViewController alloc] init];
    self.addEditVC.title = @"Edit Product"; // important for logic on addEditVC
    self.addEditVC.product = product; // the product will be whatever was selected in table view
    self.addEditVC.company = self.company; // the company will be what this VC has saved

    // CHANGE ANIMATION TYPE HERE
     CATransition *transition = [CATransition animation];
     transition.duration = 0.5;
     transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
     transition.type = kCATransitionFade; //kCATransitionMoveIn; //, kCATransitionPush, kCATransitionReveal, kCATransitionFade
     transition.subtype = kCATransitionFromTop; //kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
     [self.navigationController.view.layer addAnimation:transition forKey:nil];
    
    [self.navigationController pushViewController:self.addEditVC animated:YES];
}*/

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self toggleProductView];
        
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
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSLog(@"%d",[self.company.products count]);

    return [self.company.products count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc]
                 initWithStyle:UITableViewCellStyleDefault
                 reuseIdentifier:CellIdentifier] autorelease];
    }
    // Configure the cell...
    // 1 - Get the product by calling the correct row
    Product *product = [self.company.products objectAtIndex:[indexPath row]];
    cell.textLabel.text = [product name];
    cell.showsReorderControl = true;
    tableView.separatorInset = UIEdgeInsetsZero;
    
    UIImage *image = ([product.productLogoFilePath isEqual: @""]) ?
    [UIImage imageNamed:product.name] :
    [UIImage imageWithContentsOfFile:product.productLogoFilePath];
    
    if (image == nil) {
        image = [UIImage imageNamed:product.name];
    }
    CGSize itemSize = CGSizeMake(50, 50); // Makes a CGSize Object
    UIGraphicsBeginImageContext(itemSize); // we are outside of drawrect?
    CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.width); // creates a CGRect
    [image drawInRect:imageRect];
    cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
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
        [self.companyMC removeProduct:[self.company.products objectAtIndex:[indexPath row]] FromCompany:self.company];
        //[self.company.products removeObjectAtIndex:[indexPath row]];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath]
                              withRowAnimation:UITableViewRowAnimationFade];
    }
    
    [self toggleProductView];
}

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
        // nothing here
    } else {
        // If table view is not in editing mode, create new web view controller
        // and pass along the product selected.
        _webVC = [[WebViewController alloc] init];
        self.webVC.product = [self.company.products objectAtIndex:[indexPath row]];
        self.webVC.company = self.company;
        self.webVC.title = @"Product Link";
        [self.navigationController pushViewController:self.webVC animated:YES];
        }
}


- (void)dealloc {
    [_webVC release];
    [_company release];
    [_tableView release];
    [_topImageView release];
    [_topLabelText release];
    [_emptyView release];
    [_companyMC release];
    [_addEditVC release];
    [super dealloc];
}

@end
