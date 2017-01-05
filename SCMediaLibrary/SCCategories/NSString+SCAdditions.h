//
//  Created 9/6/13.
//  Copyright (c) 2013 tcentertainment. All rights reserved.
//

@interface NSString (SCAdditions)

- (NSString *)stringByMatchingRegex:(NSString *)regex capture:(NSUInteger)capture;

@end
