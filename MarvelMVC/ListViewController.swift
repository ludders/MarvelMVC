//
//  ListViewController.swift
//  MarvelMVC
//
//  Created by dludlow7 on 17/11/2019.
//  Copyright © 2019 David Ludlow. All rights reserved.
//

import UIKit

class ListViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let label = UILabel(frame: UIScreen.main.bounds)
        view = label
        label.text = "HELLO WORLD!"
        label.font = UIFont.systemFont(ofSize: 40)
        label.textAlignment = .center
        label.backgroundColor = UIColor.white
    }

}

