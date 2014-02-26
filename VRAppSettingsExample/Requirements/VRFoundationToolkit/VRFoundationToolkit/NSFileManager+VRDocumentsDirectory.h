//
//  NSFileManager+VRDocumentsDirectory.h
//  VRFoundationToolkit
//
//  Created by Ivan Rublev on 8/2/12.
//  Copyright (c) 2014 Ivan Rublev http://ivanrublev.me. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSFileManager (VRDocumentsDirectory)

- (NSString*)temporaryDirectory;
- (NSString*)documentsDirectory;
- (NSString*)documentsDirectoryAddingPath:(NSString*)relativePath;
- (BOOL)removeItemAtPathIfExists:(NSString *)path error:(NSError *__autoreleasing *)error;
+ (NSString*)randomFileNameOfType:(NSString *)type;
+ (NSString*)randomFileNameOfLength:(NSUInteger)length type:(NSString *)type;

@end
