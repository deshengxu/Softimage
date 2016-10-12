//
//  ViewController.swift
//  Softimage
//
//  Created by Desheng Xu on 10/10/16.
//  Copyright © 2016 Desheng Xu. All rights reserved.
//

import Cocoa


class ViewController: NSViewController {
    @IBOutlet weak var totalFiles: NSTextField! //total pictures in selection
    @IBOutlet weak var lastUsedTime: NSTextField!   //used time in last picture processing
    @IBOutlet weak var totalUsedTime: NSTextField!  //total used time in processing
    @IBOutlet weak var logField: NSTextField!   //processing log
    @IBOutlet weak var originalImageView: NSImageView!
    @IBOutlet weak var destinationImageView: NSImageView!
    
    @IBOutlet weak var source: NSTextField! // it can be a folder or an image
    
    @IBOutlet weak var target: NSTextField! // it must be a folder
    
    @IBAction func selectTarget(_ sender: NSButton) {
        //it must be a folder!
        let myFileDialog: NSOpenPanel = NSOpenPanel()
        myFileDialog.allowsMultipleSelection=false
        myFileDialog.canChooseDirectories=true
        myFileDialog.canChooseFiles=false
        
        myFileDialog.runModal()
        
        // Get the path to the file chosen in the NSOpenPanel
        let path = myFileDialog.url?.path
        
        // Make sure that a path was chosen
        if (path != nil) {
            let fileManager = FileManager.default
            var isDir : ObjCBool = false
            if fileManager.fileExists(atPath: path!, isDirectory:&isDir) {
                if isDir.boolValue {
                    NSLog("it's a folder!\(path)")
                    target.stringValue="\(path!)"
                }
            }
        }

    }
    @IBAction func startProcessing(_ sender: NSButton) {
        startButton.isEnabled=false
        exitButton.isEnabled=true
        
        let sourceText = source.stringValue.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let imageList:[NSURL] = collectImagesFromFolder(sourceText)
        
        if imageList.count == 0 {
            let myPopup: NSAlert = NSAlert()
            myPopup.messageText = "Notice"
            myPopup.informativeText = "Nothing to process!"
            myPopup.alertStyle = NSAlertStyle.informational
            myPopup.addButton(withTitle: "OK")
            myPopup.runModal()
            return
        }
        NSLog("\(imageList)")
        totalFiles.stringValue = "\(imageList.count)"
        
        //a new thread or process should be started here to handle all pictures processing
        processingAllImages(imageList)
    }
    
    //need to add more control in different thread or process here.
    func processingAllImages(_ imageList:[NSURL]){
        //let queue = DispatchQueue(label: "ImageBlur")
        //queue.async {
            for imageFile in imageList{
                self.logField.stringValue += "Processing file:\(imageFile)"
                
                if let sourceImage = ImageSofter.loadImageFromLocalFile(imageFile) {
                    NSLog("Loaded from file:\(imageFile)")
                    
                    self.originalImageView.image=sourceImage
                    
                    if let outImage = ImageSofter.blurOnePicture(sourceImage){
                        self.destinationImageView.image=outImage
                    }
                }else{
                    NSLog("failed to load image from:\(imageFile)")
                }
            }

        //}
        
}
    
    @IBAction func selectSource(_ sender: NSButton) {
        let myFileDialog: NSOpenPanel = NSOpenPanel()
        myFileDialog.allowsMultipleSelection=false
        myFileDialog.canChooseDirectories=true
        myFileDialog.canChooseFiles=true

        myFileDialog.runModal()
        
        // Get the path to the file chosen in the NSOpenPanel
        let path = myFileDialog.url?.path
        
        // Make sure that a path was chosen
        if (path != nil) {
            let fileManager = FileManager.default
            var isDir : ObjCBool = false
            if fileManager.fileExists(atPath: path!, isDirectory:&isDir) {
                if isDir.boolValue {
                    //NSLog("it's a folder!\(path)")
                    source.stringValue="\(path!)"
                    if ImageSofter.isFolderWithPictureSafe(path!){
                        startButton.isEnabled=true
                        exitButton.isEnabled=false
                    }else{
                        startButton.isEnabled=false
                        exitButton.isEnabled=false
                    }
                    
                } else {
                    //NSLog("It's a file:\(path)")
                    source.stringValue="\(path!)"
                    if ImageSofter.isPictureSafe(path!){
                        startButton.isEnabled=true
                        exitButton.isEnabled=false
                        if let image=ImageSofter.loadImageFromLocalFile(path!){
                            originalImageView.image=image
                            //if let outImage = ImageSofter.blurOnePicture(image){
                            //    destinationImageView.image=outImage
                            //}
                        }

                    }else{
                        startButton.isEnabled=false
                        exitButton.isEnabled=false
                                            }
                }
            }else{
                startButton.isEnabled=false
                exitButton.isEnabled=false
            }
        }
    }
    @IBOutlet weak var startButton: NSButton!
    
    @IBOutlet weak var exitButton: NSButton!
     
    override func viewDidLoad() {
        super.viewDidLoad()
        startButton.isEnabled=false
        exitButton.isEnabled=false
        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    
    
    func collectImagesFromFolder(_ atPath:String)->[NSURL]{
        var imageList = [NSURL]()
        
        let fileManager = FileManager.default
        var isDir:ObjCBool = false
        if fileManager.fileExists(atPath: atPath, isDirectory: &isDir){
            if isDir.boolValue{
                do{
                    NSLog("Processing folder:\(atPath)")
                    let filelist = try fileManager.contentsOfDirectory(atPath: atPath)
                    let documentsURL = NSURL(fileURLWithPath: atPath, isDirectory: true)
                    
                    for filename in filelist{
                        if ImageSofter.isPictureSafe(filename){
                            let fileURL = NSURL(fileURLWithPath: filename, relativeTo: documentsURL as URL)
                            //imageList += [fileURL.absoluteString!]
                            imageList += [fileURL]
                        }
                    }
                    return imageList    // return all images in a folder
                }catch{return imageList}

            }else{
                if ImageSofter.isPictureSafe(atPath) {
                    let fileURL = NSURL(fileURLWithPath: atPath, isDirectory: false)
                    //imageList += [fileURL.absoluteString!]
                    imageList += [fileURL]
                    return imageList    //return image list with current image only
                }
            }
        }else{
            return imageList    //return an empty image list
        }
        return imageList    //return an empty image list
    }
}

