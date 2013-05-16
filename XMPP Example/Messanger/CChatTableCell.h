//
//  CChatTableCell.h
//  AskedonTable
//
//  Created by Belov Alexandr on 2/8/13.
//  Copyright (c) 2013 Lenhador. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CChatTableCell : UITableViewCell

@property (nonatomic) UILabel *senderAndTimeLabel;
@property (nonatomic) UITextView *messageContentView;
@property (nonatomic) UIImageView *bgImageView;

@end
