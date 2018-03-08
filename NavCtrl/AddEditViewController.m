//
//  AddEditViewController.m
//  NavCtrl
//
//  Created by Eduard Lev on 3/2/18.
//  Copyright © 2018 Aditya Narayan. All rights reserved.
//

#import "AddEditViewController.h"


@interface AddEditViewController ()

@property (nonatomic, assign) UITextField *nameTextField;
@property (nonatomic, assign) UITextField *tickerTextField;
@property (nonatomic, assign) UITextField *urlTextField;

@property (nonatomic) UIBarButtonItem *saveButton;

@property (nonatomic, retain) CompanyModelController *companyModelController;

@end

@implementation AddEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImage *backImage = [UIImage imageNamed:@"btn-navBack"];
    // Creates custom back button with arrow image
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                   initWithImage:backImage
                                   style:UIBarButtonItemStylePlain
                                   target:self
                                   action:@selector(back)];
    self.navigationItem.leftBarButtonItem = backButton;

    // Creates the white background on the view.
    self.view.backgroundColor = UIColor.whiteColor;
    
    // Sets local properties to determine in later logic what kind of data to show
    self.add = [self.title containsString:@"Add"]? TRUE : FALSE;
    self.fromProductController = [self.title containsString:@"Product"]? TRUE : FALSE;
        
    // adds the save button programmatically to the navigation bar
    self.saveButton = [[UIBarButtonItem alloc]
                       initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                       target:self
                       action:@selector(saveButtonDidTap)];
    self.saveButton.enabled = FALSE; // ALWAYS DISABLE THE BUTTON INITIALLY
    self.navigationItem.rightBarButtonItem = self.saveButton;
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self createTextFields];
    if ([self validateTextFields]) {
        self.navigationItem.rightBarButtonItem.enabled = TRUE;
    }
    
    // Adds notifications that check if the keyboard is shown or if keyboard was hidden
    // Should be removed in later methods, see 'viewDidDisappear:'
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardDidHideNotification object:nil];
    
    self.companyModelController = [CompanyModelController sharedInstance];
}

// When the view disappears, remove the observers for keyboard notifications from this object
-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidHideNotification
                                                  object:nil];
}

// Creates frames for all text fields, and then calls 'createTextField' with that field to populate
-(void)createTextFields {
    _nameTextField = [[UITextField alloc] initWithFrame:CGRectMake(30, 200, 300, 40)];
    [self createTextField:self.nameTextField];
    [self.nameTextField addTarget:self action:@selector(textFieldDidChange:)
                 forControlEvents:UIControlEventEditingChanged];
    _tickerTextField = [[UITextField alloc] initWithFrame:CGRectMake(30, 260, 300, 40)];
    [self createTextField:self.tickerTextField];
    [self.tickerTextField addTarget:self action:@selector(textFieldDidChange:)
                   forControlEvents:UIControlEventEditingChanged];
    _urlTextField= [[UITextField alloc] initWithFrame:CGRectMake(30, 320, 300, 40)];
    [self createTextField:self.urlTextField];
    [self.urlTextField addTarget:self action:@selector(textFieldDidChange:)
                forControlEvents:UIControlEventEditingChanged];
}

/**
 *  Function creates text fields and fills them in accordingly depending on if this view controller
 *  is meant to add a company or product, or to edit a company or product.
 *
 */
- (void)createTextField:(UITextField*)field {
    // If the VC is for adding, enter the correct placeholders
    // If the VC is for editing, enter the correct placeholders
    if (self.add) {
        if (field == self.nameTextField) {
            field.placeholder = self.fromProductController ? @"Enter Product Name" :
            @"Enter Company Name";
        } else if (field == self.tickerTextField) {
            field.placeholder = self.fromProductController ? @"Enter Product Logo URL" :
            @"Enter Company Stock Ticker Abbreviation";
        } else if (field == self.urlTextField) {
            field.placeholder = self.fromProductController ? @"Enter Product Website URL" :
            @"Enter Company Logo URL";
        }
    } else { // If the VC is for editing, put in the text that matches the current product
        if (field == self.nameTextField) {
            field.text = self.fromProductController ?
            self.product.name :
            self.company.name;
        } else if (field == self.tickerTextField) {
            field.text = self.fromProductController ?
            self.product.productLogoURL :
            self.company.ticker;
        } else if (field == self.urlTextField) {
            field.text = self.fromProductController ?
            self.product.productWebsiteURL :
            self.company.companyLogoURL;
        }
    }
    
    // Creates a text field similar to the one in Storyboard, and sets self to the delegate
    field.font = [UIFont systemFontOfSize:20];
    field.autocorrectionType = UITextAutocorrectionTypeNo;
    field.keyboardType = UIKeyboardTypeDefault;
    field.returnKeyType = UIReturnKeyDone;
    field.clearButtonMode = UITextFieldViewModeWhileEditing;
    field.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    field.delegate = self;
    
    // Creates a border on the bottom of the text field
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
    
    // Adds the border to the view, then releases local variable from memory
    [self.view addSubview:field];
    [field release];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)cancelButtonDidTap {
    CATransition* transition = [CATransition animation];
    transition.duration = .25;
    transition.type = @"genieEffect";
    transition.subtype = kCATransitionFromTop;
    [self.presentingViewController.view.layer addAnimation:transition forKey:nil];
    
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)saveButtonDidTap {
    NSString *name = self.nameTextField.text;
    NSString *ticker = self.tickerTextField.text; // logoURL for Product!
    NSString *url = self.urlTextField.text;
    
    if ([self.title isEqualToString:@"Add Product"]) {
        // ticker text field has logo URL for Product
            if (![self checkIfProductExists:name]) {
                Product *newProduct = [[Product alloc] initWithName:name
                                                            LogoURL:ticker
                                                         WebsiteURL:url];
                [self.companyModelController addProduct:newProduct ToCompany:self.company];
                [newProduct release];
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                UIAlertController* alert =
                [UIAlertController alertControllerWithTitle:@"Error"
                                                    message:@"Product already exists"
                                             preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction* defaultAction =
                [UIAlertAction actionWithTitle:@"OK"
                                         style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction * action) {}];
                [alert addAction:defaultAction];
                [self presentViewController:alert animated:YES completion:nil];
            }
    } else if ([self.title isEqualToString:@"Edit Product"]) {
        
        // 1 - remove product from the data model
        // 2 - set the stored product in this VC with new properties
        // 3 - add edited product to the data model
        [self.companyModelController removeProduct:self.product FromCompany:self.company]; // 1
        self.product.name = name; // 2
        self.product.productLogoURL = ticker; // 2
        self.product.productWebsiteURL = url; // 2
        [self.companyModelController addProduct:self.product ToCompany:self.company]; // 3
        [self.navigationController popViewControllerAnimated:YES];
        
    } else if ([self.title isEqualToString:@"Add Company"]) {
            if (![self checkIfCompanyExists:name]) {
                Company *newCompany = [[Company alloc] initWithName:name
                                                             Ticker:ticker
                                                         AndLogoURL:url];
                [self.companyModelController addCompany:newCompany];
                [newCompany release];
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                UIAlertController* alert =
                [UIAlertController alertControllerWithTitle:@"Error"
                                                    message:@"Company already exists"
                                             preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction* defaultAction =
                [UIAlertAction actionWithTitle:@"OK"
                                         style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction * action) {}];
                [alert addAction:defaultAction];
                [self presentViewController:alert animated:YES completion:nil];
            }
    } else if ([self.title isEqualToString:@"Edit Company"]) {
        // 1 - remove company from the data model
        // 2 - set the stored company in this VC with new properties
        // 3 - add edited company to the data model
        int index = [self.companyModelController removeCompany:self.company]; // 1
        Company *temporaryCompany = [[Company alloc] initWithName:name
                                                           Ticker:ticker
                                                       AndLogoURL:url];
        [self.companyModelController insertCompany:temporaryCompany AtIndex:index]; // 3
        [temporaryCompany release];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (BOOL)checkIfProductExists:(NSString*)name {
    if ([self.company.products count] > 0) {
        for (int i = 0; i < [self.company.products count]; i++) {
            if ([[self.company.products[i] name] isEqualToString:name]) {
                return true;
            }
        }
    }
    return false;
}


- (BOOL)checkIfCompanyExists:(NSString*)name {
    if ([self.companyModelController.companyList count] > 0) {
        for (int i = 0; i < [self.companyModelController.companyList count]; i++) {
            if ([[self.companyModelController.companyList[i] name] isEqualToString:name]) {
                return true;
            }
        }
    }
    return false;
}

#pragma mark - Keyboard Methods

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
    NSLog(@"keyboard Did Hide");
    
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
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    NSLog(@"text Field Should Begin Editing");
    return true;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    NSLog(@"text Field Should End Editing");
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
    /*
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
         
     }];*/
    
    if ([self validateTextFields]) {
        self.saveButton.enabled = TRUE;
    } else {
        self.saveButton.enabled = FALSE;
    }
    return true;
}


- (void)textFieldDidChange :(UITextField *) textField{
        self.navigationItem.rightBarButtonItem.enabled = [self validateTextFields] ? TRUE : FALSE;
}

/*
 * Checks if the text fields are all filled in with strings of length > 0.
 * If so, then the save button is enabled.
 *
 */
-(BOOL)validateTextFields {
    NSString *name = self.nameTextField.text; // name of product or company
    NSString *tickerORURL = self.tickerTextField.text; // company ticker or product logo URL
    NSString *url = self.urlTextField.text; // company logo URL or product website URL
    
    return (name.length>0)&&(tickerORURL.length>0)&&(url.length>0);
    
    /*
    bool correctName = (name.length > 0); // check if the name length is greater than 0
    
    bool correctURL;
    NSRange range = NSMakeRange(0, 8); // string "https://" is 8 characters long
    NSString *firstPartOfURL = [url substringWithRange:range];
    correctURL = [firstPartOfURL isEqualToString:@"https://"] ? TRUE : FALSE;
    
    return (correctURL)&&(correctName); */
}

-(void)dealloc {
    self.fromProductController = 0;
    [_company release];
    [_companyModelController release];
    [_product release];
    [_indexPath release];
    [super dealloc];
}

@end
