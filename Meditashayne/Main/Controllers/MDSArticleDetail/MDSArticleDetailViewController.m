//
//  MDSArticleDetailViewController.m
//  Meditashayne
//
//  Created by 杨淳引 on 16/2/3.
//  Copyright © 2016年 shayneyeorg. All rights reserved.
//

#import "MDSArticleDetailViewController.h"
#import "SVProgressHUD.h"

@interface MDSArticleDetailViewController ()

@property (strong, nonatomic) NSManagedObjectID *objectID;//当前正在编辑的随笔的id(新建随笔则无值)
@property (weak, nonatomic) AppDelegate *appDelegate;

@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UITextView *contentField;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentFieldBottomInset;//随笔内容框与底部的距离
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *seperatorLineHeight;


@end

@implementation MDSArticleDetailViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configBackBtn];
    [self configHideKeyboardBtn];
    [self configDetails];
    [self setPopGestureEnabled:NO];
    
    [self addKeyboardNotification];
}

- (void)dealloc {
    MDSLog(@"dealloc");
    
    [self removeKeyboardNotification];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Private

- (void)setPopGestureEnabled:(BOOL)isEnabled {
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = isEnabled;
    }
}

- (void)configDetails {
    self.appDelegate = kApp;
    self.seperatorLineHeight.constant = 0.5;
}

- (void)configBackBtn {
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 44, 44);
    [backBtn setTitle:@"<返回" forState:UIControlStateNormal];
    [backBtn setTitleColor:RGB(50, 50, 50) forState:UIControlStateNormal];
    backBtn.titleLabel.font = [UIFont systemFontOfSize:16.f];
    [backBtn addTarget:self action:@selector(popBack:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backItem;
}

- (void)configHideKeyboardBtn {
    UIButton *hideKeyboardBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    hideKeyboardBtn.frame = CGRectMake(0, 0, 44, 44);
    [hideKeyboardBtn setTitle:@"收起" forState:UIControlStateNormal];
    [hideKeyboardBtn setTitleColor:RGB(50, 50, 50) forState:UIControlStateNormal];
    hideKeyboardBtn.titleLabel.font = [UIFont systemFontOfSize:16.f];
    [hideKeyboardBtn addTarget:self action:@selector(hideKeyboard:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *hideKeyboardItem = [[UIBarButtonItem alloc] initWithCustomView:hideKeyboardBtn];
    self.navigationItem.rightBarButtonItem = hideKeyboardItem;
}

- (void)popBack:(id)sender {
    if (!self.titleField.text.length) {
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
        [SVProgressHUD showErrorWithStatus:@"标题不可为空"];
        [self.titleField becomeFirstResponder];
        
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)hideKeyboard:(id)sender {
    [self.view endEditing:YES];
}

#pragma mark - UITextFieldAction

- (IBAction)editingChanged:(id)sender {
    [self setPopGestureEnabled:YES];
    
    NSString *newStr = [(UITextField *)sender text];
    if (!newStr.length) {
        [self setPopGestureEnabled:NO];
    }
}

#pragma mark - Keyboard Notification

- (void)addKeyboardNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)removeKeyboardNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    //获取键盘的y值
    NSDictionary *userInfo = [notification userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [value CGRectValue];
    CGFloat keyboardHeight = keyboardRect.size.height + 5;
    
    //如果键盘挡住了随笔内容，将内容框缩短
    self.contentFieldBottomInset.constant = keyboardHeight;
}

- (void)keyboardWillHide:(NSNotification *)notification {
    //将随笔内容框恢复原本高度
    self.contentFieldBottomInset.constant = 8;
}

#pragma mark - Core Data

//新增数据
- (void)addArticle {
    NSString *title = self.titleField.text;
    NSString *content = self.contentField.text;
    
    Article *article = [NSEntityDescription insertNewObjectForEntityForName:@"Article" inManagedObjectContext:self.appDelegate.managedObjectContext];
    
    article.title = title;
    article.content = [content dataUsingEncoding:NSUTF8StringEncoding];
    article.createTime = [NSDate date];
    
    NSError *error = nil;
    if ([self.appDelegate.managedObjectContext save:&error]) {
        if (error) MDSLog(@"新增时发生错误:%@,%@",error,[error userInfo]);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

//修改数据
- (void)alterArticle {
    Article *article = [self.appDelegate.managedObjectContext objectWithID:self.objectID];
    article.title = self.titleField.text;
    article.content = [self.contentField.text dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *error = nil;
    if ([self.appDelegate.managedObjectContext save:&error]) MDSLog(@"修改成功");
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
