//
//  ViewController.swift
//  Softimage
//
//  Created by Desheng Xu on 10/10/16.
//  Copyright © 2016 Desheng Xu. All rights reserved.
//

import Cocoa

extension NSImage {
    var imageJPGRepresentation: NSData {
        return NSBitmapImageRep(data: tiffRepresentation!)!.representation(using: NSBitmapImageFileType.JPEG, properties: [:])! as NSData
    }
    func saveJPG(path:String) -> Bool {
        return imageJPGRepresentation.write(toFile: path, atomically: true)
    }
}


class ViewController: NSViewController, NSTextFieldDelegate {
    var destinationFolder:NSURL? = nil
    
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
    
    func verifyDestinationFolder(){
        destinationFolder = nil
        let dstFolderText = target.stringValue.trimmingCharacters(in: .whitespacesAndNewlines)
        if dstFolderText == ""{
            let myPopup: NSAlert = NSAlert()
            myPopup.messageText = "Target Folder"
            myPopup.informativeText = "target folder can't be empty!"
            myPopup.alertStyle = NSAlertStyle.warning
            myPopup.addButton(withTitle: "OK")
            myPopup.runModal()
            return
        }
        
        let fileManager = FileManager.default
        var isDir : ObjCBool = false
        
        if fileManager.fileExists(atPath: dstFolderText, isDirectory:&isDir) {
            if isDir.boolValue {
                destinationFolder = NSURL(fileURLWithPath: dstFolderText, isDirectory: true)
            }
        }else{
            do{
                try fileManager.createDirectory(atPath: dstFolderText, withIntermediateDirectories: true, attributes: nil)
                destinationFolder = NSURL(fileURLWithPath: dstFolderText, isDirectory: true)
            }catch let error as NSError {
                NSLog("Unable to create directory \(error.debugDescription)")
                destinationFolder = nil
            }
        }
        
        if destinationFolder == nil{
            let myPopup: NSAlert = NSAlert()
            myPopup.messageText = "Target Folder"
            myPopup.informativeText = "Target folder can't be found or created!"
            myPopup.alertStyle = NSAlertStyle.warning
            myPopup.addButton(withTitle: "OK")
            myPopup.runModal()
        }
    }
    
    @IBAction func startProcessing(_ sender: NSButton) {
        verifyDestinationFolder()
        if destinationFolder==nil{
            return
        }
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
    
    @IBAction func exitProcessing(_ sender: NSButton) {
        ImageSofter.stopProcessing=true
        NSLog("Stop sign has been sent out")
        self.exitButton.isEnabled=false
        
    }
    
    //process all images from folder or the single file selected
    func processingAllImages(_ imageList:[NSURL]){
        
        ImageSofter.stopProcessing = false
        
        var total_timeinterval: TimeInterval = 0
        
        for imageFile in imageList{
            if ImageSofter.stopProcessing {
                break;
            }
            self.logField.stringValue += "Processing file:\(imageFile)"
            
            DispatchQueue.global(qos: .background).async {
                NSLog("This is run on the background queue")
                let sourceImage = ImageSofter.loadImageFromLocalFile(imageFile)
                    
                if sourceImage != nil {
                    let blur_starttime = NSDate()
                    DispatchQueue.main.sync {
                        self.originalImageView.image=sourceImage
                    }
                    //this is the key step to process a file.
                    let outImage = ImageSofter.blurOnePicture(sourceImage!)
                    
                    if let fileName = imageFile.lastPathComponent {
                        if let targetFileName = self.destinationFolder?.appendingPathComponent(fileName, isDirectory: false) {
                            NSLog("file name: \(targetFileName)")
                            if outImage != nil{
                                if !outImage!.saveJPG(path: targetFileName.path){
                                    self.logField.stringValue += "save failed:\(targetFileName)"
                                }
                            }
                        }
                        
                    }

                    
                    let blur_endtime = NSDate()
                    let time_spent = blur_endtime.timeIntervalSince(blur_starttime as Date)
                    total_timeinterval += time_spent
                    
                    DispatchQueue.main.sync{
                        NSLog("This is run on the main queue, after the previous code in outer block")
                        self.lastUsedTime.stringValue = "\(time_spent)"
                        self.totalUsedTime.stringValue = "\(total_timeinterval)"
                        self.originalImageView.image=sourceImage
                        
                        if outImage != nil{
                            self.destinationImageView.image = outImage
                        }
                    }
                        
                }
                    
            }
        }
        
        //notice process finish
        //below notice window will pop up earlier than all queue finishes.
        //therefore, it has misleading effect here.
        
        //let myPopup: NSAlert = NSAlert()
        //myPopup.messageText = "Notice"
        //myPopup.informativeText = "Process finished!"
        //myPopup.alertStyle = NSAlertStyle.informational
        //myPopup.addButton(withTitle: "OK")
        //myPopup.runModal()
        //return
        
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
        source.delegate = self
        
        startButton.isEnabled=false
        exitButton.isEnabled=false
        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    override func controlTextDidChange(_ obj: Notification) {
        let changedSource = obj.object as! NSTextField
        // we don't need to identify which text field changed in this demo.
        // we only need to verify source field anyway.
        NSLog("\(changedSource.tag) \(changedSource.stringValue)")
        verifySource()
    }
    
    //dynamically verify source folder or file when user is typing
    //control enable status of start and exit button.
    func verifySource(){
        let atPath = source.stringValue
        
        let fileManager = FileManager.default
        var isDir:ObjCBool = false
        if fileManager.fileExists(atPath: atPath, isDirectory: &isDir){
            if isDir.boolValue{
                do{
                    let filelist = try fileManager.contentsOfDirectory(atPath: atPath)
                    for filename in filelist{
                        if ImageSofter.isPictureSafe(filename){
                            startButton.isEnabled = true
                            exitButton.isEnabled = false
                            if let image=ImageSofter.loadImageFromLocalFile(atPath){
                                originalImageView.image=image
                            }
                        }
                    }
                    
                }catch{
                    startButton.isEnabled = false
                    exitButton.isEnabled = false
                }
                
            }else{
                //NSLog("Detected it is a file again!\(atPath)")
                if ImageSofter.isPictureSafe(atPath) {
                    NSLog("Then enable it!")
                    startButton.isEnabled = true
                    exitButton.isEnabled = false
                }
            }
        }else{
            startButton.isEnabled = false
            exitButton.isEnabled = false
        }
        startButton.isEnabled = false
        exitButton.isEnabled = false
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

