//
//  ImageSofter.swift
//  Softimage
//
//  Created by Desheng Xu on 10/11/16.
//  Copyright © 2016 Desheng Xu. All rights reserved.
//

import Foundation

class ImageSofter{
    class func blurOnePicture(_ sourceImg:NSImage)->NSImage?{
        let outImage = OpenCV.cvtColorBGR2GRAY(sourceImg)
        
        return outImage
    }
    
    class func loadImageFromLocalFile(_ atPath:String)->NSImage?{
        NSLog("Loading \(atPath)")
        
        return NSImage(contentsOfFile: atPath)
        
    }
    
    class func loadImageFromLocalFile(_ atURL:NSURL?)->NSImage?{
        if atURL == nil{
            return nil
        }
        if atURL?.absoluteString == nil{
            return nil
        }
        return loadImageFromLocalFile((atURL?.path!)!)
    }
    
    class func isFolderWithPictureUnsafe(_ atPath:String)->Bool{
        //atPath may not exist or may be a file
        //so, it needs a safe check
        let fileManager = FileManager.default
        var isDir:ObjCBool = false
        if fileManager.fileExists(atPath: atPath, isDirectory: &isDir){
            if isDir.boolValue{
                return isFolderWithPictureSafe(atPath)
            }
        }
        return false
    }
    
    class func isFolderWithPictureSafe(_ atPath:String)->Bool{
        //assume path exist and is a folder
        //doesn't need to check again.
        let fileManager=FileManager.default
        
        do{
            let filelist = try fileManager.contentsOfDirectory(atPath: atPath)
            for filename in filelist{
                if isPictureSafe(filename){
                    return true
                }
            }
        }catch{return false}
        return false
    }
    
    class func isPictureSafe(_ atPath:String)->Bool{
        //atPath has been confirmed is a file.
        //so, it doesn't need to check exists or not again.
        if atPath.hasSuffix("jpg") || atPath.hasSuffix("JPG") || atPath.hasSuffix("JPEG")||atPath.hasSuffix("jpeg"){
            return true
        }
        return false
    }
    
    class func isPictureUnsafe(_ atPath:String)->Bool{
        //atPath may be an unchecked path or file name.
        //so, it needs a recheck
        let fileManager = FileManager.default
        var isDir:ObjCBool = false
        if fileManager.fileExists(atPath: atPath, isDirectory: &isDir){
            if isDir.boolValue{
                return false
            }else{
                return isPictureSafe(atPath)
            }
        }
        return false
    }

}
