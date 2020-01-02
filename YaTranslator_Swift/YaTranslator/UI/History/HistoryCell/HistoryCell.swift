//
//  HistoryCell.swift
//  YaTranslator
//
//  Created by Мартынов Дмитрий on 02/01/2020.
//  Copyright © 2020 Мартынов Дмитрий. All rights reserved.
//

import UIKit

class HistoryCell: UITableViewCell {
    
    static let XibName = "HistoryCell"
    static let Identifer = "HistoryIdentifer"
    
    @IBOutlet weak var hederLabel:UILabel!
    @IBOutlet weak var inputLabel:UILabel!
    @IBOutlet weak var outputLabel:UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func initUI(_ translator:Traslator) {
        let header = "\(translator.inputLanguage.name) -> \(translator.outputLanguage.name)"
        self.hederLabel.text = header
        self.inputLabel.text = translator.inputLanguage.text
        self.outputLabel.text = translator.outputLanguage.text
        self.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
    }
}
