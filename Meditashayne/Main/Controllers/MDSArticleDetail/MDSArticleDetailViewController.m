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
//@property (weak, nonatomic) AppDelegate *appDelegate;

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
    [self configSaveBtn];
    [self configDetails];
//    [self setPopGestureEnabled:NO];
    
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

//- (void)setPopGestureEnabled:(BOOL)isEnabled {
//    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
//        self.navigationController.interactivePopGestureRecognizer.enabled = isEnabled;
//    }
//}

- (void)configDetails {
    self.seperatorLineHeight.constant = 0.5;
    
    if (self.alteringArticle) {
        //在修改的状态下
        self.titleField.text = self.alteringArticle.title;
        self.contentField.text = [[NSString alloc]initWithData:self.alteringArticle.content encoding:NSUTF8StringEncoding];
        self.objectID = self.alteringArticle.objectID;
        
    } else {
        //新建状态下
        NSDate *now = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setLocale:[NSLocale localeWithLocaleIdentifier:@"zh-CN"]];
        [formatter setDateFormat:@"yyyy-MM-dd "];
        NSString *nowStr = [formatter stringFromDate:now];
        self.titleField.text = nowStr;
    }
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

- (void)configSaveBtn {
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    saveBtn.frame = CGRectMake(0, 0, 44, 44);
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [saveBtn setTitleColor:RGB(50, 50, 50) forState:UIControlStateNormal];
    saveBtn.titleLabel.font = [UIFont systemFontOfSize:16.f];
    [saveBtn addTarget:self action:@selector(saveArticle:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *saveItem = [[UIBarButtonItem alloc] initWithCustomView:saveBtn];
    self.navigationItem.rightBarButtonItem = saveItem;
}

- (void)popBack:(id)sender {
//    if (!self.titleField.text.length) {
//        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
//        [SVProgressHUD showErrorWithStatus:@"标题不可为空"];
//        [self.titleField becomeFirstResponder];
//        
//    } else {
//        [self.navigationController popViewControllerAnimated:YES];
//    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)saveArticle:(id)sender {
    [self.view endEditing:YES];
    
    //判断保存内容是否合法
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    if (!self.titleField.text.length) {
        [SVProgressHUD showErrorWithStatus:@"标题不可为空"];
        [self.titleField becomeFirstResponder];
        return;
        
    } else if (!self.contentField.text.length) {
        [SVProgressHUD showErrorWithStatus:@"内容不可为空"];
        [self.contentField becomeFirstResponder];
        return;
    }
    
    //保存
    if (self.alteringArticle) {
        //修改随笔
        [MDSCoreDataAccess updateArticleWithObjectID:self.objectID title:self.titleField.text content:self.contentField.text];
        [SVProgressHUD showSuccessWithStatus:@"修改成功"];
        
    } else {
        //新增随笔
        [MDSCoreDataAccess addArticleWithTitle:self.titleField.text content:self.contentField.text];
        [SVProgressHUD showSuccessWithStatus:@"保存成功"];
    }
}

#pragma mark - UITextFieldAction

//- (IBAction)editingChanged:(id)sender {
//    [self setPopGestureEnabled:YES];
//    
//    NSString *newStr = [(UITextField *)sender text];
//    if (!newStr.length) {
//        [self setPopGestureEnabled:NO];
//    }
//}

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

@end
