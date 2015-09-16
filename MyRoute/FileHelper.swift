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
        
        var document: String? = allpaths.first
        
        document = document?.stringByAppendingString("/" + RecordDirectoryName)
        
        var isDir: ObjCBool = false
        
        var pathSuccess: Bool = NSFileManager.defaultManager().fileExistsAtPath(document!, isDirectory: &isDir)
        
        if (!pathSuccess || !isDir) {
            
            do {
                try NSFileManager.defaultManager().createDirectoryAtPath(document!, withIntermediateDirectories: true, attributes: nil)
                pathSuccess = true
            } catch _ {
                pathSuccess = false
            }
        }
        
        return pathSuccess ? document : nil
    }
    
    class func recordFileList() -> [AnyObject]? {
        
        let document: String? = baseDirForRecords()
        
        if document != nil {
            
            var error: NSError?
            
            var result: [AnyObject]?
            do {
                result = try NSFileManager.defaultManager().contentsOfDirectoryAtPath(document!)
            } catch let error1 as NSError {
                error = error1
                result = nil
            }
            if error != nil {
                print("error: \(error)")
            }
            else {
                return result
            }
        }
        
        return nil
    }
    
    class func recordPathWithName(name: String!) -> String? {
        
        let document: String? = baseDirForRecords()
//        let path: String? = document?.stringByAppendingPathComponent(name)
        let path:String? = document! + "/" + name
        return path
    }
    
    class func routesArray() -> [Route]! {
        
        let list: [AnyObject]? = recordFileList()
        
        if (list != nil) {
            
            var routeList: [Route] = []
            
            for file in list as![String] {
                
                print("file: \(file)")
                
                let path = recordPathWithName(file)
                let route = NSKeyedUnarchiver.unarchiveObjectWithFile(path!) as? Route
                
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
        var success: Bool
        do {
            try NSFileManager.defaultManager().removeItemAtPath(path!)
            success = true
        } catch let error1 as NSError {
            error = error1
            success = false
        }
        if error != nil {
            print("error: \(error)")
        }
        return success
    }
}
