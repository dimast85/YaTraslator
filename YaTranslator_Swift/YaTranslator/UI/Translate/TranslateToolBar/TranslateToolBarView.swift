//
//  TranslateToolBarView.swift
//  YaTranslator
//
//  Created by Мартынов Дмитрий on 29/09/2019.
//  Copyright © 2019 Мартынов Дмитрий. All rights reserved.
//

import Foundation
import UIKit

protocol TranslateToolBarDelegate {
    func clearText(_ toolBar:TranslateToolBarView)
    func translate(_ toolBar:TranslateToolBarView)
    func cancel(_ toolBar:TranslateToolBarView)
}

class TranslateToolBarView: UIView {
    @IBOutlet var translateButton:UIButton!
    @IBOutlet var cancelButton:UIButton!
    @IBOutlet var clearButton:UIButton!
    
    var delegate:TranslateToolBarDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.translateButton.accessibilityIdentifier = "translate_translateButton"
        self.cancelButton.accessibilityIdentifier = "translate_cancelButton"
        self.clearButton.accessibilityIdentifier = "translate_clearButton"
    }
    
    @IBAction func actionClearButton(_ sender:UIButton?) {
        delegate.clearText(self)
    }
    
    @IBAction func actionCancelButton(_ sender:UIButton?) {
        delegate.cancel(self)
    }
    
    @IBAction func actionTranslateButton(_ sender:UIButton) {
        delegate.translate(self)
    }
}
