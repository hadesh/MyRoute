//
//  FileHelper.swift
//  MyRoute
//
//  Created by xiaoming han on 14-7-22.
//  Copyright (c) 2014 AutoNavi. All rights reserved.
//

import Foundation

let RecordDirectoryName = "myRecords"

class FileHelper: NSObject {
   
    class func baseDirForRecords() -> String? {
        
        let allpaths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        
        var document: String? = allpaths[0] as? String
        
        document = document?.stringByAppendingPathComponent(RecordDirectoryName)
        
        var isDir: ObjCBool = false
        
        var pathSuccess: Bool = NSFileManager.defaultManager().fileExistsAtPath(document!, isDirectory: &isDir)
        
        if (!pathSuccess || !isDir) {
            
            pathSuccess = NSFileManager.defaultManager().createDirectoryAtPath(document!, withIntermediateDirectories: true, attributes: nil, error: nil)
        }
        
        return pathSuccess ? document? : nil
    }
    
    class func recordFileList() -> [AnyObject]? {
        
        var document: String? = baseDirForRecords()
        
        if document != nil {
            
            var error: NSError?
            
            var result = NSFileManager.defaultManager().contentsOfDirectoryAtPath(document!, error: &error)
            if error != nil {
                println("error: \(error)")
            }
            else {
                return result
            }
        }
        
        return nil
    }
    
    class func recordPathWithName(name: String!) -> String? {
        
        var document: String? = baseDirForRecords()
        
        var path: String? = document?.stringByAppendingPathComponent(name)
        
        return path
    }
    
    class func routesArray() -> [Route]! {
        
        var list: [AnyObject]? = recordFileList()
        
        if (list != nil) {
            
            var routeList: [Route] = []
            
            for file in list as [String] {
                
                println("file: \(file)")
                
                let path = recordPathWithName(file)
                var route = NSKeyedUnarchiver.unarchiveObjectWithFile(path!) as? Route
                
                if route != nil {
                    routeList.append(route!)
                }
            }
            
            return routeList
        }
        
        return []
    }
    
    class func deleteFile(file: String!) -> Bool! {
        let path = recordPathWithName(file)
        
        var error: NSError?
        var success = NSFileManager.defaultManager().removeItemAtPath(path!, error: &error)
        if error != nil {
            println("error: \(error)")
        }
        return success
    }
}
