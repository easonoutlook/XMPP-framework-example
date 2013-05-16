//
//  String.m
//  AskedonTable
//
//  Created by Администратор on 2/8/13.
//  Copyright (c) 2013 Lenhador. All rights reserved.
//

#import "String.h"

@implementation NSString (Utils)

+ (NSString *) getCurrentTime
{    
	NSDate *nowUTC = [NSDate date];
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
	[dateFormatter setDateStyle:NSDateFormatterMediumStyle];
	[dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
	return [dateFormatter stringFromDate:nowUTC];
	
}

- (NSString *) substituteEmoticons
{
	NSString *res = [self stringByReplacingOccurrencesOfString:@":)" withString:@"\ue415"];
	res = [res stringByReplacingOccurrencesOfString:@":(" withString:@"\ue403"];
	res = [res stringByReplacingOccurrencesOfString:@";-)" withString:@"\ue405"];
	res = [res stringByReplacingOccurrencesOfString:@":-x" withString:@"\ue418"];
	return res;
}

@end
