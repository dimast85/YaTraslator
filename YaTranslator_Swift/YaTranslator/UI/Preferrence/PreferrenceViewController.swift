//
//  PreferrenceViewController.swift
//  YaTranslator
//
//  Created by Мартынов Дмитрий on 02/01/2020.
//  Copyright © 2020 Мартынов Дмитрий. All rights reserved.
//

import UIKit

class PreferrenceViewController: UIViewController {
    @IBOutlet weak var clearAllhistoryButton:UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.clearAllhistoryButton.accessibilityIdentifier = "preference_clearall_button"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func actionClearButton(_ sender:UIButton) {
        let coreData = CoreDataService()
        coreData.clearHistory()
    }

}
