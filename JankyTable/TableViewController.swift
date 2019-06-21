//
//  TableViewController.swift
//  JankyTable
//
//  Created by Thomas Vandegriff on 5/28/19.
//  Copyright © 2019 Make School. All rights reserved.
//

//Q: How many threads are active at the breakpoint?
//A: 7

//Q: How many queues?
//A: 2

//Q: What is the thread number of the main queue?
//A: 1

//Q: What is the last function executed prior to the breakpoint?
//A: View did load

//Q: What is the first function executed on the main queue/main thread?
//A: App Delegate

//Q: Why do you think it takes so long to present the images to the user?
//A: Needs to apply the filter to the pictures before displaying the cells on screen.

//Q: Why is scrolling so slow?
//A: Need to apply filter to the incoming cells as they come.

//Q: What could you do to resolve these 2 egregious UI issues?
//A: Having the filter be applied on a different thread from the one that loads the cells.

import UIKit

class TableViewController: UITableViewController {
    

    private var photosDict: [String: String] = [:]
    lazy var photos = NSDictionary(dictionary: photosDict)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let plist = Bundle.main.url(forResource: "PhotosDictionary", withExtension: "plist"),
            let contents = try? Data(contentsOf: plist),
            let serializedPlist = try? PropertyListSerialization.propertyList(from: contents, format: nil),
            let serialUrls = serializedPlist as? [String: String] else {
                print("error with serializedPlist")
                return
        }
        photosDict = serialUrls
    }
    
    override func tableView(_ tableView: UITableView?, numberOfRowsInSection section: Int) -> Int {
        return photosDict.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier", for: indexPath)
        let rowKey = photos.allKeys[indexPath.row] as! String
        
        var image : UIImage?
        
        guard let imageURL = URL(string:photos[rowKey] as! String),
            let imageData = try? Data(contentsOf: imageURL) else {
                return cell
        }
        
        // Simulate a network wait
        Thread.sleep(forTimeInterval: 1)
        print("sleeping 1 sec")
        
        let unfilteredImage = UIImage(data:imageData)
        image = self.applySepiaFilter(unfilteredImage!)
        
        // Configure the cell...
        cell.textLabel?.text = rowKey
        if image != nil {
            cell.imageView?.image = image!
        }
        return cell
    }
    
    // MARK: - image processing
    
    func applySepiaFilter(_ image:UIImage) -> UIImage? {
        let inputImage = CIImage(data:image.pngData()!)
        let context = CIContext(options:nil)
        let filter = CIFilter(name:"CISepiaTone")
        filter?.setValue(inputImage, forKey: kCIInputImageKey)
        filter!.setValue(0.8, forKey: "inputIntensity")
        
        guard let outputImage = filter!.outputImage,
            let outImage = context.createCGImage(outputImage, from: outputImage.extent) else {
                return nil
        }
        return UIImage(cgImage: outImage)
    }
}


