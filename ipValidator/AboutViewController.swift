//
//  AboutViewController.swift
//  ipValidator
//
//  Created by Mehmet emin Kartal on 9/18/16.
//  Copyright © 2016 mehmet. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {
	@IBAction func githubProfile(_ sender: AnyObject) {
		UIApplication.shared.open(URL(string: "https://github.com/mehmeteminkartal/")!, options: [:], completionHandler: nil);
	}

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
