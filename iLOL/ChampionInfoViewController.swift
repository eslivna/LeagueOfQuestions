//
//  ChampionInfoViewController.swift
//  iLOL
//
//  Created by Esli Van Acoleyen on 19/01/2017.
//  Copyright © 2017 Esli Van Acoleyen. All rights reserved.
//

import Foundation
import UIKit

class  ChampionInfoViewController: UIViewController {
    var image = UIImage()
    var champTitle = String()
    
    @IBOutlet weak var backgroundImage: UIImageView!
    
    @IBOutlet weak var championIcon: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
     titleLabel.text = champTitle
     championIcon.image = image
     backgroundImage.image = image
    }
}
