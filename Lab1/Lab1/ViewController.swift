//
//  ViewController.swift
//  Lab1
//
//  Created by Karol Perec on 12/12/2019.
//  Copyright © 2019 Karol Perec. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    @IBOutlet weak var searchField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func search(_ sender: UIButton) {
        debugPrint("KEKW")
        Alamofire.request("https://aws.random.cat/meow")
            .validate()
            .responseJSON { response in
                if let JSON = response.result.value {
                    debugPrint("JSON: \(JSON)")
                }
        }
}
}
