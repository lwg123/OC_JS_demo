//
//  Person.m
//  jsdemo
//
//  Created by weiguang on 2017/3/16.
//  Copyright © 2017年 weiguang. All rights reserved.
//

#import "Person.h"

@implementation Person

- (NSString *)getFullName {
    return [NSString stringWithFormat:@"%@ %@", self.firstName,self.lastName];
}

+ (instancetype)createWithFirstName:(NSString *)firstName lastName:(NSString *)lastName{

    Person *person = [[Person alloc] init];
    person.firstName = firstName;
    person.lastName = lastName;
    return person;
}
    
    
@end
