//
//  ViewController.swift
//  Lab3
//
//  Created by Karol Perec on 19/01/2020.
//  Copyright © 2020 Karol Perec. All rights reserved.
//

import UIKit

class ViewController: UIViewController, URLSessionDownloadDelegate, UIApplicationDelegate {
    let fileManager = FileManager.default
    let docDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]

    @IBOutlet weak var log: UITextView!
    @IBAction func run(_ sender: UIButton) {
        self.log.text = ""
        let imageURLs = ["https://upload.wikimedia.org/wikipedia/commons/0/04/Dyck,_Anthony_van_-_Family_Portrait.jpg",
                         "https://upload.wikimedia.org/wikipedia/commons/c/ce/Petrus_Christus_-_Portrait_of_a_Young_Woman_-_Google_Art_Project.jpg",
                         "https://upload.wikimedia.org/wikipedia/commons/3/36/Quentin_Matsys_-_A_Grotesque_old_woman.jpg",
                         "https://upload.wikimedia.org/wikipedia/commons/c/c8/Valmy_Battle_painting.jpg"
        ]
        for i in 1...imageURLs.count {
            guard let imageURL = URL(string: imageURLs[i-1]) else {
                DispatchQueue.main.async {
                    self.log.text.append("Error parsing filename of file: \(i)\n")
                }
                continue }
            download(imageURL: imageURL, identifier: "\(i)")
        }
    }
    
    func download(imageURL: URL, identifier: String) {
        let config = URLSessionConfiguration.background(withIdentifier: identifier)
        config.sessionSendsLaunchEvents = true
        config.isDiscretionary = true
        let session = URLSession(configuration: config, delegate: self, delegateQueue: OperationQueue.main)
        let task = session.downloadTask(with: imageURL)
        task.resume()
        DispatchQueue.main.async {
            self.log.text.append("Started downloading file \(identifier) from: \(imageURL.absoluteString)\n")
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        guard let fileName = downloadTask.originalRequest?.url?.lastPathComponent else { return }
        let location2 = self.docDir.appendingPathComponent(fileName)
        DispatchQueue.main.async {
            self.log.text.append("Downloading file \(session.configuration.identifier ?? "?") finished...saved to: \(location)\n")
        }
        
        try? self.fileManager.removeItem(at: location2)
        do {
            try self.fileManager.copyItem(at: location, to: location2)
            DispatchQueue.main.async {
                self.log.text.append("File \(session.configuration.identifier ?? "?") copied to: \(location2)\n")
            }
            
            DispatchQueue.global(qos: .background).async {
                self.detectFaces(location: location2)
            }
        }
        catch {
            DispatchQueue.main.async {
                self.log.text.append("Error saving file \(session.configuration.identifier ?? "?") to location: \(location2)\n")
                return
            }
        }
    }
    
    func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: @escaping () -> Void) {
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        let percentDownloaded = Int((totalBytesWritten*100)/totalBytesExpectedToWrite)
        
        DispatchQueue.main.async {
            if (percentDownloaded%10 == 0) {
                self.log.text.append("Downloading file \(session.configuration.identifier ?? "?")...\(percentDownloaded)%\n")
            }
        }
    }
    
    func detectFaces(location: URL) {
        DispatchQueue.main.async {
            self.log.text.append("Starting face detection for image \(location.lastPathComponent)\n")
        }
        let image = CIImage(contentsOf: location)
        let detector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: [CIDetectorAccuracy: CIDetectorAccuracyHigh])
        let facesDetected = detector?.features(in: image!)
        
        DispatchQueue.main.async {
            self.log.text.append("Finished face detection for image \(location.lastPathComponent), number of faces: \(facesDetected?.count ?? 0)\n")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
}
