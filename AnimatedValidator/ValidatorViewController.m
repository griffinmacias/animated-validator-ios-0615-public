//
//  ValidatorViewController.m
//  AnimatedValidator
//
//  Created by Al Tyus on 5/12/14.
//  Copyright (c) 2014 al-tyus.com. All rights reserved.
//

#import "ValidatorViewController.h"
#import "Constants.h"

@interface ValidatorViewController ()<UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet UITextField *emailTextField;
@property (nonatomic, weak) IBOutlet UITextField *emailConfirmTextField;
@property (nonatomic, weak) IBOutlet UITextField *phoneTextField;
@property (nonatomic, weak) IBOutlet UITextField *passwordTextField;
@property (nonatomic, weak) IBOutlet UITextField *passwordConfirmTextField;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leadingEmailConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *trailingEmailConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *trailingEmailConfirmConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leadingEmailConfirmConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leadingPhoneConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *trailingPhoneConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *trailingPasswordConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leadingPasswordConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leadingPasswordConfirmConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *trailingPasswordConfirmConstraint;

@end

@implementation ValidatorViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.emailTextField.delegate = self;
    self.emailConfirmTextField.delegate = self;
    self.phoneTextField.delegate = self;
    self.passwordTextField.delegate = self;
    self.passwordConfirmTextField.delegate = self;
    
    self.submitButton.accessibilityLabel = SUBMITBUTTON;
    self.emailTextField.accessibilityLabel = EMAILTEXTFIELD;
    self.emailConfirmTextField.accessibilityLabel = EMAILCONFIRMTEXTFIELD;
    self.phoneTextField.accessibilityLabel = PHONETEXTFIELD;
    self.passwordTextField.accessibilityLabel = PASSWORDTEXTFIELD;
    self.passwordConfirmTextField.accessibilityLabel = PASSWORDCONFIRMTEXTFIELD;
    
}

- (void)animateTextfield:(UITextField *)textField Leading:(NSLayoutConstraint *)leadingSpace Trailing:(NSLayoutConstraint *)trailingSpace
{
    [UIView animateWithDuration:1 delay:0 options:0 animations:^{
        
        textField.backgroundColor = [UIColor redColor];
        leadingSpace.constant = -16;
        trailingSpace.constant = -16;
        
        [self.view layoutIfNeeded];
        
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:1 animations:^{
            
            textField.backgroundColor = [UIColor whiteColor];
            leadingSpace.constant = 4;
            trailingSpace.constant = 4;
            
            [self.view layoutIfNeeded];
            
        }];
    }];

}

-(void)allFieldAreVerify
{
    if (self.passwordTextField.text && self.passwordTextField.text.length > 0 &&
        self.passwordConfirmTextField.text && self.passwordConfirmTextField.text.length > 0 &&
        self.emailTextField.text && self.emailTextField.text.length > 0 &&
        self.emailConfirmTextField.text && self.emailConfirmTextField.text.length > 0 &&
        self.phoneTextField.text && self.phoneTextField.text.length > 0)
    {
        self.submitButton.hidden = NO;
        self.submitButton.enabled = YES;
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    if (textField == self.emailTextField) {
        if (![self isValidEmail:textField.text]) {
            
            [self animateTextfield:self.emailTextField Leading:self.leadingEmailConstraint Trailing:self.trailingEmailConstraint];
            
            return NO;
        } else {
           
            [self.emailConfirmTextField becomeFirstResponder];
        }
    }
    
    if (textField == self.emailConfirmTextField) {
        if (![self.emailConfirmTextField.text isEqualToString:self.emailTextField.text]) {
            
            [self animateTextfield:self.emailConfirmTextField Leading:self.leadingEmailConfirmConstraint Trailing:self.trailingEmailConfirmConstraint];

            return NO;
        } else {
     
            [self.phoneTextField becomeFirstResponder];
        }
    }
    
    if (textField == self.phoneTextField) {
        if (!([self isNumeric:textField.text] && self.phoneTextField.text.length >= 7)) {
            
            [self animateTextfield:self.phoneTextField Leading:self.leadingPhoneConstraint Trailing:self.trailingPhoneConstraint];
            
            return NO;
        } else {
            
            [self.passwordTextField becomeFirstResponder];
        }
    }
    
    if (textField == self.passwordTextField) {
        if (self.passwordTextField.text.length < 6) {
            
            [self animateTextfield:self.passwordTextField Leading:self.leadingPasswordConstraint Trailing:self.trailingPasswordConstraint];
            
            return NO;
        } else {
           
            [self.passwordConfirmTextField becomeFirstResponder];
        }
    }
    
    if (textField == self.passwordConfirmTextField) {
        if (![self.passwordTextField.text isEqualToString:self.passwordConfirmTextField.text]) {
            
            [self animateTextfield:self.passwordConfirmTextField Leading:self.leadingPasswordConfirmConstraint Trailing:self.trailingPasswordConfirmConstraint];
            
            return NO;
        } else {
          
            [self.passwordConfirmTextField resignFirstResponder];
        }
    }
    
    [self allFieldAreVerify];
    return YES;
}

-(BOOL)isValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = NO; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

-(BOOL)isNumeric:(NSString*)inputString
{
    NSCharacterSet *character =[[NSCharacterSet characterSetWithCharactersInString:@"+0123456789"] invertedSet];
    NSString *filtered = [[inputString componentsSeparatedByCharactersInSet:character] componentsJoinedByString:@""];
    return [inputString isEqualToString:filtered];
}



@end
