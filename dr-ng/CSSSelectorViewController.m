//
// Created by Mikkel Gravgaard on 21/01/14.
// Copyright (c) 2014 Betafunk. All rights reserved.
//

#import "CSSSelectorViewController.h"
#import "ReactiveCocoa.h"
#import "HTMLReader.h"

static NSString *const kURL = @"http://www.dr.dk/playlister/p6beat/2014-1-20";

@interface CSSSelectorViewController ()
@property(nonatomic, copy) NSString *html;
@end

@implementation CSSSelectorViewController {

}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSError *error;
    self.html = [NSString stringWithContentsOfURL:[NSURL URLWithString:kURL] encoding:kCFStringEncodingUTF8 error:&error];
    NSCAssert(!error, @"error: %@",error);

    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 60, self.view.frame.size.width, 50)];
    textField.backgroundColor = [UIColor yellowColor] ;
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    [self.view addSubview:textField];

    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 120,100,50)];
    btn.backgroundColor = [UIColor greenColor];
    [btn setTitle:@"eval" forState:UIControlStateNormal];
    [self.view addSubview:btn];

    btn.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        HTMLDocument *document = [HTMLDocument documentWithString:self.html];
        @try {
            NSArray *array = [document nodesMatchingSelector:textField.text];
            NSLog(@"%@ returned %d nodes:",textField.text, array.count);
            [array enumerateObjectsUsingBlock:^(HTMLElementNode *node, NSUInteger idx, BOOL *stop) {
                NSLog(@"%@",node.innerHTML);
            }];

        } @catch(NSException *e) {
            NSLog(@"error: %@",e);
        }

        return [RACSignal empty];
    }];
}




@end