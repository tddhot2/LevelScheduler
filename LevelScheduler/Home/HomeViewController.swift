//
//  HomeViewController.swift
//  LevelScheduler
//
//  Created by HYUNJIN on 28/12/2018.
//  Copyright © 2018 HYUNJIN. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet private weak var doubleScrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        doubleScrollView.contentSize = CGSize(width: UIScreen.main.bounds.width * 2, height: UIScreen.main.bounds.height)
        view.layoutIfNeeded()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
