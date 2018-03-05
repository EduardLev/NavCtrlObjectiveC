//
//  AddEditViewController.m
//  NavCtrl
//
//  Created by Eduard Lev on 3/2/18.
//  Copyright © 2018 Aditya Narayan. All rights reserved.
//

#import "AddEditViewController.h"


@interface AddEditViewController ()

@property (nonatomic) UITextField *nameTextField;
@property (nonatomic) UITextField *tickerTextField;
@property (nonatomic) UITextField *urlTextField;

@property (nonatomic) UIBarButtonItem *saveButton;


@end

@implementation AddEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Creates the white background on the view.
    self.view.backgroundColor = UIColor.whiteColor;
    
    // Another way to create the background: Add a subview with a white background to the self.view
    /*UIView *paintView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height)];
    [paintView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview: paintView];
    [paintView release]; */
    
    // Creates the navigation bar at the top
    // Currently only goes up to the safe view
    //UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0.0, 20.0, self.view.frame.size.width, self.view.frame.size.height)];
    
    NSString *title;
    if (self.add) {
        self.fromProductController ? (title = @"Add Product") : (title = @"Add Company");
    } else {
        self.fromProductController ? (title = @"Edit Product") : (title = @"Edit Company");
    }
    //UINavigationItem *navItem = [[UINavigationItem alloc] initWithTitle:title];
    
    
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc]
                                     initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                     target:self
                                     action:@selector(cancelButtonDidTap)];
    
    self.navigationItem.leftBarButtonItem = cancelButton;
    //navItem.leftBarButtonItem = cancelButton;
    
    self.saveButton = [[UIBarButtonItem alloc]
                                   initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                   target:self
                                   action:@selector(saveButtonDidTap)];
    
    self.navigationItem.rightBarButtonItem = self.saveButton;
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    /*
    navItem.rightBarButtonItem = self.saveButton;
    navItem.rightBarButtonItem.enabled = NO;*/

    /*
    [navBar setItems:@[navItem]];
    [self.view addSubview:navBar]; */
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    
    [self createTextFields];
    
    // release all items created in this function
    //[navBar release];
    //[navItem release];
    [cancelButton release];
}

-(void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
}

-(void)createTextFields {
    self.nameTextField = [[UITextField alloc] initWithFrame:CGRectMake(30, 200, 300, 40)];
    [self createTextField:self.nameTextField];
    self.tickerTextField = [[UITextField alloc] initWithFrame:CGRectMake(30, 260, 300, 40)];
    [self createTextField:self.tickerTextField];
    self.urlTextField= [[UITextField alloc] initWithFrame:CGRectMake(30, 320, 300, 40)];
    [self createTextField:self.urlTextField];
}

- (void)createTextField:(UITextField*)field {
    
    if (self.add) {
        if (field == self.nameTextField) {
            field.placeholder = self.fromProductController ? @"Enter Product Name" : @"Enter Company Name";
        } else if (field == self.tickerTextField) {
            field.placeholder = self.fromProductController ? @"Enter Product Price" : @"Enter Company Stock Ticker Abbreviation";
        } else if (field == self.urlTextField) {
            field.placeholder = self.fromProductController ? @"Enter Product URL" : @"Enter Company URL";
        }
    } else {
        if (field == self.nameTextField) {
            field.text = self.fromProductController ? self.product.name : self.company.name;
        } else if (field == self.tickerTextField) {
            // dummy
        } else if (field == self.urlTextField) {
            // dummy
        }
    }
    
    field.font = [UIFont systemFontOfSize:15];
    field.autocorrectionType = UITextAutocorrectionTypeNo;
    field.keyboardType = UIKeyboardTypeDefault;
    field.returnKeyType = UIReturnKeyDone;
    field.clearButtonMode = UITextFieldViewModeWhileEditing;
    field.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    field.delegate = self;
    
    CALayer *border = [CALayer layer];
    CGFloat borderWidth = 1;
    border.borderColor = [UIColor darkGrayColor].CGColor;
    border.frame = CGRectMake(0,
                              field.frame.size.height - borderWidth,
                              field.frame.size.width,
                              field.frame.size.height);
    border.borderWidth = borderWidth;
    [field.layer addSublayer:border];
    field.layer.masksToBounds = YES;
    
    [self.view addSubview:field];
    
    [field release];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)cancelButtonDidTap {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)saveButtonDidTap {
    NSString *name = self.nameTextField.text;
    NSString *ticker = self.tickerTextField.text;
    NSString *url = self.urlTextField.text;
    
    if (self.fromProductController) {
        if (self.add) {
            Product *newProduct = [[Product alloc] initWithName:name];
            ProductVC *productVC = (ProductVC*)self.presentingViewController.childViewControllers[1];
            [productVC.company.products addObject:newProduct];
            [newProduct release];
            [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
        } else {
            self.product.name = name;
            ProductVC *productVC = (ProductVC*)self.presentingViewController.childViewControllers[1];
            [productVC.company.products removeObjectAtIndex:[self.indexPath row]];
            [productVC.company.products insertObject:self.product atIndex:[self.indexPath row]];
            [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
        }
    } else if (self.add) {
        Company *newCompany = [[Company alloc] initWithName:name AndProducts:nil];
        CompanyVC *companyListVC = (CompanyVC*)self.presentingViewController.childViewControllers[0];
        [companyListVC.companyMC.companyList addObject:newCompany];
        [newCompany release];
        [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
    } else {
        self.company.name = name;
        CompanyVC *companyVC = (CompanyVC*)self.presentingViewController.childViewControllers[0];
        [companyVC.companyMC.companyList removeObjectAtIndex:[self.indexPath row]];
        [companyVC.companyMC.companyList insertObject:self.company atIndex:[self.indexPath row]];
        [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
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

-(void)keyboardDidShow:(NSNotification*)notification {
    [UIView animateWithDuration:0.25 animations:^
     {
         CGRect newFrame = [self.nameTextField frame];
         newFrame.origin.y -= 50; // tweak here to adjust the moving position
         [self.nameTextField setFrame:newFrame];
         
         CGRect newFrame2 = [self.tickerTextField frame];
         newFrame2.origin.y -= 50;
         [self.tickerTextField setFrame:newFrame2];
         
         CGRect newFrame3 = [self.urlTextField frame];
         newFrame3.origin.y -= 50;
         [self.urlTextField setFrame:newFrame3];
         
     }completion:^(BOOL finished)
     {
         
     }];
    
}

-(void)keyboardDidHide:(NSNotification*)notification {
    
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    NSLog(@"text Field Should Begin Editing");
    
    
    return true;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    NSLog(@"text Field Should End Editing");
    [UIView animateWithDuration:0.25 animations:^
     {
         CGRect newFrame = [self.nameTextField frame];
         newFrame.origin.y += 50; // tweak here to adjust the moving position
         [self.nameTextField setFrame:newFrame];
         
         CGRect newFrame2 = [self.tickerTextField frame];
         newFrame2.origin.y += 50;
         [self.tickerTextField setFrame:newFrame2];
         
         CGRect newFrame3 = [self.urlTextField frame];
         newFrame3.origin.y += 50;
         [self.urlTextField setFrame:newFrame3];
         
     }completion:^(BOOL finished)
     {
         
     }];
    
    
    return true;
}

// Called when text field is done editing
// When user clicks out
-(void)textFieldDidEndEditing:(UITextField *)textField {
    NSLog(@"text Field Did End Editing");

}

// Called when user selects done on the keyboard
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSLog(@"text field should return");
    [textField resignFirstResponder];
    
    if ([self validateTextFields]) {
        self.saveButton.enabled = TRUE;
    }
    return true;
}

/*
 * Checks if the text fields are all filled in with strings of length > 0.
 * If so, then the save button is enabled.
 *
 */
-(BOOL)validateTextFields {
    if ((self.nameTextField.text.length > 0)&&(self.tickerTextField.text.length > 0)&&(self.urlTextField.text.length > 0)) {
        return true;
    } else {
        return false;
    }
}

-(void)dealloc {
    self.fromProductController = 0;
    [_company release];
    [_saveButton release];
    [super dealloc];
}

@end
