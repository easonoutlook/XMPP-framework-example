//
//  XMPPMessangerViewController.m
//  AskedonTable
//
//  Created by Belov Alexandr on 4/22/13.
//  Copyright (c) 2013 Lenhador. All rights reserved.
//

#import "XMPPMessangerViewController.h"
#import "NSXMLElement+XMPP.h"
#import "CChatTableCell.h"
#import "String.h"

@interface XMPPMessangerViewController ()
@property (nonatomic) NSMutableArray *messages;
@end

@implementation XMPPMessangerViewController

@synthesize xmppModel;
@synthesize messages;
@synthesize tableView, textView, doneBut, containerView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    containerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 40, 320, 40)];
    
	textView = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(6, 0, 240, 40)];
    textView.contentInset = UIEdgeInsetsMake(0, 5, 0, 5);
    
	textView.minNumberOfLines = 1;
	textView.maxNumberOfLines = 5;
	textView.returnKeyType = UIReturnKeyDefault; //just as an example
	textView.font = [UIFont systemFontOfSize:15.0f];
	textView.delegate = self;
    textView.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(5, 0, 5, 0);
    textView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:containerView];
	
    UIImage *rawEntryBackground = [UIImage imageNamed:@"MessageEntryInputField.png"];
    UIImage *entryBackground = [rawEntryBackground stretchableImageWithLeftCapWidth:13 topCapHeight:22];
    UIImageView *entryImageView = [[UIImageView alloc] initWithImage:entryBackground];
    entryImageView.frame = CGRectMake(5, 0, 248, 40);
    entryImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    UIImage *rawBackground = [UIImage imageNamed:@"MessageEntryBackground.png"];
    UIImage *background = [rawBackground stretchableImageWithLeftCapWidth:13 topCapHeight:22];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:background];
    imageView.frame = CGRectMake(0, 0, containerView.frame.size.width, containerView.frame.size.height);
    imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    textView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    // view hierachy
    [containerView addSubview:imageView];
    [containerView addSubview:textView];
    [containerView addSubview:entryImageView];
    
    UIImage *sendBtnBackground = [[UIImage imageNamed:@"MessageEntrySendButton.png"] stretchableImageWithLeftCapWidth:13 topCapHeight:0];
    UIImage *selectedSendBtnBackground = [[UIImage imageNamed:@"MessageEntrySendButton.png"] stretchableImageWithLeftCapWidth:13 topCapHeight:0];
    
	doneBut = [UIButton buttonWithType:UIButtonTypeCustom];
	[doneBut addTarget:self action:@selector(resignTextView) forControlEvents:UIControlEventTouchUpInside];
	doneBut.frame = CGRectMake(containerView.frame.size.width - 69, 8, 63, 27);
    doneBut.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
	[doneBut setTitle:@"Done" forState:UIControlStateNormal];
    
    [doneBut setTitleShadowColor:[UIColor colorWithWhite:0 alpha:0.4] forState:UIControlStateNormal];
    doneBut.titleLabel.shadowOffset = CGSizeMake (0.0, -1.0);
    doneBut.titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    
    [doneBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[doneBut addTarget:self action:@selector(resignTextView) forControlEvents:UIControlEventTouchUpInside];
    [doneBut setBackgroundImage:sendBtnBackground forState:UIControlStateNormal];
    [doneBut setBackgroundImage:selectedSendBtnBackground forState:UIControlStateSelected];
	[containerView addSubview:doneBut];
    containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    
    xmppModel = [[XMPPDataModel alloc] initWithDelegate:self];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) newMessage:(NSString *)msg
{
    NSMutableDictionary *messageDictionary = [[NSMutableDictionary alloc] init];
    
    [messageDictionary setObject:[msg substituteEmoticons] forKey:@"msg"];
    [messageDictionary setObject:@"Приславший" forKey:@"sender"];
    [messageDictionary setObject:[NSString getCurrentTime] forKey:@"time"];
    
    [messages addObject:messageDictionary];
            
    [tableView reloadData];
        
    NSIndexPath *topIndexPath = [NSIndexPath indexPathForRow:messages.count-1
                                                       inSection:0];
        
    [tableView scrollToRowAtIndexPath:topIndexPath
                          atScrollPosition:UITableViewScrollPositionMiddle 
                                  animated:YES];
}

- (void)resignTextView
{
    NSString *msgText = textView.text;
    
    if(msgText.length > 0 && xmppModel.fromJid != nil)
    {
        [xmppModel sendMsgWithString:msgText];
        
        [textView setText:@""];
        NSMutableDictionary *messageDictionary = [[NSMutableDictionary alloc] init];
        
        [messageDictionary setObject:[msgText substituteEmoticons] forKey:@"msg"];
        [messageDictionary setObject:@"you" forKey:@"sender"];
        [messageDictionary setObject:[NSString getCurrentTime] forKey:@"time"];
        [self.messages addObject:messageDictionary];
        [tableView reloadData];
    }
    [textView resignFirstResponder];

}

#pragma mark -
#pragma mark TableView delegate methods


static CGFloat padding = 20.0;

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(!messages)
    {
        messages = [[NSMutableArray alloc] init];
    }
	return [messages count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	
	NSDictionary *s = (NSDictionary *) [self.messages objectAtIndex:indexPath.row];
	
	static NSString *cellID = @"MessageCellIdentifier";
	
	CChatTableCell *cell = (CChatTableCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
	
	if (cell == nil)
    {
		cell = [[CChatTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
	}
    
	NSString *sender = [s objectForKey:@"sender"];
	NSString *message = [s objectForKey:@"msg"];
	NSString *time = [s objectForKey:@"time"];
	
	CGSize  textSize = { 260.0, 10000.0 };
	CGSize size = [message sizeWithFont:[UIFont boldSystemFontOfSize:13]
					  constrainedToSize:textSize
						  lineBreakMode:NSLineBreakByWordWrapping];
	
	size.width += (padding/2);
	
	cell.messageContentView.text = message;
	cell.accessoryType = UITableViewCellAccessoryNone;
	cell.userInteractionEnabled = NO;
	
    
	UIImage *bgImage = nil;
	
    //Если отправители сообщения мы сами, то левое выравнивание
	if ([sender isEqualToString:@"you"])
    {
		bgImage = [[UIImage imageNamed:@"orange.png"] stretchableImageWithLeftCapWidth:24  topCapHeight:15];
		
		[cell.messageContentView setFrame:CGRectMake(padding, padding*2, size.width, size.height)];
		
		[cell.bgImageView setFrame:CGRectMake( cell.messageContentView.frame.origin.x - padding/2,
											  cell.messageContentView.frame.origin.y - padding/2,
											  size.width+padding,
											  size.height+padding)];
        
	}
    else
    {
		bgImage = [[UIImage imageNamed:@"aqua.png"] stretchableImageWithLeftCapWidth:24  topCapHeight:15];
		
		[cell.messageContentView setFrame:CGRectMake(320 - size.width - padding,
													 padding*2,
													 size.width,
													 size.height)];
		
		[cell.bgImageView setFrame:CGRectMake(cell.messageContentView.frame.origin.x - padding/2,
											  cell.messageContentView.frame.origin.y - padding/2,
											  size.width+padding,
											  size.height+padding)];
	}
	
	cell.bgImageView.image = bgImage;
	cell.senderAndTimeLabel.text = [NSString stringWithFormat:@"%@ %@", sender, time];
    
    //report_memory();
    
	return cell;
	
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSDictionary *dict = (NSDictionary *)[self.messages objectAtIndex:indexPath.row];
	NSString *msg = [dict objectForKey:@"msg"];
	
	CGSize  textSize = { 260.0, 10000.0 };
	CGSize size = [msg sizeWithFont:[UIFont boldSystemFontOfSize:13]
				  constrainedToSize:textSize
					  lineBreakMode: NSLineBreakByWordWrapping];
	
	size.height += padding*2;
	
	CGFloat height = size.height < 65 ? 65 : size.height;
	return height;
	
}


-(void) keyboardWillShow:(NSNotification *)note{
    // get keyboard size and loctaion
	CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // Need to translate the bounds to account for rotation.
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
    
	// get a rect for the textView frame
	CGRect containerFrame = containerView.frame;
    containerFrame.origin.y = self.view.bounds.size.height - (keyboardBounds.size.height + containerFrame.size.height);
	// animations settings
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
	
	// set views with new info
	containerView.frame = containerFrame;
	
	// commit animations
	[UIView commitAnimations];
}

-(void) keyboardWillHide:(NSNotification *)note
{
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
	
	// get a rect for the textView frame
	CGRect containerFrame = containerView.frame;
    containerFrame.origin.y = self.view.bounds.size.height - containerFrame.size.height;
	
	// animations settings
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
	// set views with new info
	containerView.frame = containerFrame;
	
	// commit animations
	[UIView commitAnimations];
}

- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height
{
    float diff = (growingTextView.frame.size.height - height);
    
	CGRect r = containerView.frame;
    r.size.height -= diff;
    r.origin.y += diff;
	containerView.frame = r;
}

@end
