//
//  TH_CVTestVC.swift
//  mapview
//
//  Created by diamond on 07.06.16.
//  Copyright (c) 2016 diamond. All rights reserved.
//

import UIKit

class TH_CVTestVC: UICollectionViewController {
    
    init(){
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
        
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "THCollecitonviewController"
        println("view load")
        
    }

}
