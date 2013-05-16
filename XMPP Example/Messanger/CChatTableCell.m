//
//  CChatTableCell.m
//  AskedonTable
//
//  Created by Belov Alexandr on 2/8/13.
//  Copyright (c) 2013 Lenhador. All rights reserved.
//

#import "CChatTableCell.h"

@implementation CChatTableCell

@synthesize senderAndTimeLabel, messageContentView, bgImageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        senderAndTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 300, 20)];
		senderAndTimeLabel.textAlignment = NSTextAlignmentCenter;
		senderAndTimeLabel.font = [UIFont systemFontOfSize:11.0];
		senderAndTimeLabel.textColor = [UIColor lightGrayColor];
		[self.contentView addSubview:senderAndTimeLabel];
		
		bgImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
		[self.contentView addSubview:bgImageView];
		
		messageContentView = [[UITextView alloc] init];
		messageContentView.backgroundColor = [UIColor clearColor];
		messageContentView.editable = NO;
		messageContentView.scrollEnabled = NO;
		[messageContentView sizeToFit];
		[self.contentView addSubview:messageContentView];
    }
    return self;
}

/*
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}*/

@end
