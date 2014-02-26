//
//  NSObject+VRPropertiesProcessingTests.m
//  VRFoundationToolkit
//
//  Created by Ivan Rublev on 2/26/14.
//  Copyright (c) 2014 Ivan Rublev http://ivanrublev.me. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "VRPPMyClass.h"
#import "NSObject+VRPropertiesProcessing.h"

@interface NSObject_VRPropertiesProcessingTests : XCTestCase {
    VRPPMyClass * obj1, * obj2, * obj3;
}

@end

#define VRPPSrtMatchesRegexp(str,rexp) [[NSPredicate predicateWithFormat:@"SELF MATCHES %@", rexp] evaluateWithObject:str]
#define VRPPAssertRegexp(str, pattern) do { BOOL tr = VRPPSrtMatchesRegexp(str, pattern);\
XCTAssertTrue(tr, @"Value %@ does not matches pattern %@!", str, pattern);} while(0)

@implementation NSObject_VRPropertiesProcessingTests

- (void)setUp
{
    [super setUp];
    obj1 = [VRPPMyClass new];
    obj2 = [VRPPMyClass new];
    obj3 = [VRPPMyClass new];
}

- (void)tearDown
{
    obj3 = nil;
    obj2 = nil;
    obj1 = nil;
    [super tearDown];
}

- (void)testDescriptionWithPropertiesTypes
{
    NSString * value = [obj1 descriptionWithPropertiesTypes];
    NSLog(@"====");
    NSLog(@"Properties types of an obj1: %@", value);
    NSLog(@"====");
    
    VRPPAssertRegexp(value, @"<VRPPMyClass:[a-zA-Z0-9]+ \\.value:__NSCFNumber \\.title:\\(null\\) \\.value2:__NSCFNumber>");
}

- (void)testDescriptionWithProperties
{
    NSString * value = [obj1 descriptionWithProperties];
    NSLog(@"====");
    NSLog(@"Properties of an empty obj1: %@", value);
    NSLog(@"====");

    VRPPAssertRegexp(value, @"<VRPPMyClass:[a-zA-Z0-9]+ \\.value=0 \\.title=\\(null\\) \\.value2=0>");
}


// ↓↓↓
- (void)fillObj:(VRPPMyClass *)obj
{
    obj.value = 100;
    obj.title = @"Hello";
    obj.constInvisible = @"You will not see this"; // because property begins with const
    obj.superTitle = @"And this also"; // because the property is inherited from super class
    [obj setValue:@(200) forKey:@"value2"]; // do in such way because declaration is hidden
}

- (void)testEnumeratePropertiesUsingBlock
{
    [self fillObj:obj1];
    
    NSMutableString * values = [NSMutableString stringWithString:@""];
    [obj1 enumeratePropertiesUsingBlock:^(NSString *propertyName, id propertyValue, __unsafe_unretained Class valuesClass) {
        [values appendFormat:@".%@ = %@; ", propertyName, propertyValue];
    }];
    NSLog(@"====");
    NSLog(@"Values of properties of the filled obj1: %@", values);
    NSLog(@"====");

    VRPPAssertRegexp(values, @"\\.value = 100; \\.title = Hello; \\.value2 = 200; ");
}
// ↑↑↑


- (void)testIsEqualByProperties
{
    [self fillObj:obj1];
    [self fillObj:obj2];
    XCTAssertTrue([obj1 isEqualByProperties:obj1], @"obj must be equal self!");
    XCTAssertTrue([obj1 isEqualByProperties:obj2], @"obj must be equal to object filled with same values!");
    XCTAssertTrue([obj2 isEqualByProperties:obj1], @"obj must be equal to object filled with same values!"); // vice versa
    XCTAssertFalse([obj1 isEqualByProperties:obj3], @"obj must not be equal empty object!");
    XCTAssertFalse([obj3 isEqualByProperties:obj1], @"obj must not be equal empty object!");
}

- (void)testDeepCopyPropertiesToNewInstanceWithZone
{
    [self fillObj:obj1];
    VRPPMyClass * objNew = [obj1 deepCopyPropertiesToNewInstanceWithZone:nil];

    BOOL tr = [obj1 isEqualByProperties:objNew];
    NSLog(@"====");
    NSLog(@"objNew created as proprerty by property copy of obj1, and they are equal by properties = %d", tr);
    NSLog(@"====");
    
    XCTAssertTrue(tr, @"Objects must be equal after copying.");
}

- (void)testDeepCopyPropertiesTo
{
    [self fillObj:obj1];
    [obj1 deepCopyPropertiesTo:obj2];
    
    BOOL tr = [obj1 isEqualByProperties:obj2];
    NSLog(@"====");
    NSLog(@"obj2 filled property by property from obj1, and they are equal by properties = %d", tr);
    NSLog(@"====");
    
    XCTAssertTrue(tr, @"Objects must be equal after copying.");
}

- (void)testHashByProperties
{
    [self fillObj:obj1];
    
    NSUInteger obj1HashByProps = [obj1 hashByProperties];
    NSUInteger obj1UsuallHash  = [obj1 hash];
    VRPPMyClass * objNew = [obj1 deepCopyPropertiesToNewInstanceWithZone:nil];
    NSUInteger objNewHashByProps = [objNew hashByProperties];
    NSUInteger objNewUsuallHash  = [objNew hash];
    
    NSLog(@"====");
    NSLog(@"For obj1   hash by properties: %d, usuall hash: %d", obj1HashByProps, obj1UsuallHash);
    NSLog(@"For objNew hash by properties: %d, usuall hash: %d", objNewHashByProps, objNewUsuallHash);
    NSLog(@"Usuall hashes differs because VRPPMyClass itsefl doesn't contains address independent version of [-hash].");
    NSLog(@"====");

    NSUInteger etalon = 1004900858;
    XCTAssertTrue(obj1HashByProps   == etalon, @"Hash must be equal to etalon!");
    XCTAssertTrue(objNewHashByProps == etalon, @"Hash must be equal to etalon!");
}

- (void)testEncodePropertiesWithCoderAndInitPropertiesWithCoder
{
    [self fillObj:obj1];
    VRPPMyClass * unarchivedObj = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:obj1]];
    BOOL tr = [obj1 isEqualByProperties:unarchivedObj];
    
    NSLog(@"==== Test fast implementing of NSCoding, see realisation of protocol in VRPPMyClass ====");
    NSLog(@"obj1:          %@", [obj1 descriptionWithProperties]);
    NSLog(@"unarchivedObj: %@", [unarchivedObj descriptionWithProperties]);
    NSLog(@"====");
    
    XCTAssertTrue(tr, @"unarchived object must have same values.");
}


@end
