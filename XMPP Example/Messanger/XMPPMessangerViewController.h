//
//  XMPPMessangerViewController.h
//  AskedonTable
//
//  Created by Belov Alexandr on 4/22/13.
//  Copyright (c) 2013 Lenhador. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HPGrowingTextView.h"
#import "XMPPDataModel.h"

@interface XMPPMessangerViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, HPGrowingTextViewDelegate, ReceiveMessageDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) HPGrowingTextView *textView;
@property (strong, nonatomic) UIButton *doneBut;
@property (strong, nonatomic) UIView *containerView;
@property (strong, nonatomic) XMPPDataModel *xmppModel;

@end
