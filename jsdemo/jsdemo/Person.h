//
//  Person.h
//  jsdemo
//
//  Created by weiguang on 2017/3/16.
//  Copyright © 2017年 weiguang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>
@class Person;
@protocol PersonJSExports <JSExport>
    @property (nonatomic, copy) NSString *firstName;
    @property (nonatomic, copy) NSString *lastName;
    @property NSInteger ageToday;
    
    - (NSString *)getFullName;

    + (instancetype)createWithFirstName:(NSString *)firstName lastName:(NSString *)lastName;
@end



@interface Person : NSObject<PersonJSExports>
    @property (nonatomic, copy) NSString *firstName;
    @property (nonatomic, copy) NSString *lastName;
    @property NSInteger ageToday;
    
    
    
    
    
    
    
    

@end
