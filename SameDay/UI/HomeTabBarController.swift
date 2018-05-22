//
//  HomeTabBarController.swift
//  SameDay
//
//  Created by Derik Flanary on 5/22/18.
//  Copyright © 2018 AppJester. All rights reserved.
//

import UIKit

class HomeTabBarController: UITabBarController, StoryboardInitializable {

    static var storyboardName = "Home"
    static var viewControllerIdentifier = "HomeTabBarController"

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