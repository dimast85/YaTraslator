//
//  ContriesView.swift
//  YaTranslator
//
//  Created by Мартынов Дмитрий on 29/09/2019.
//  Copyright © 2019 Мартынов Дмитрий. All rights reserved.
//

import Foundation
import UIKit

class CountriesView: UIView {
    @IBOutlet private var cancelButton:UIButton!
    @IBOutlet private var selectButton:UIButton!
    @IBOutlet private var countriesPickerView:UIPickerView!
    
    private var countries: [Country] = []
    private var selectCountryClosure: ((Country) -> ())?
    private var selectCountry:Country?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.accessibilityIdentifier = "translate_tool_bar_countries"
        self.selectButton.accessibilityIdentifier = "ok_button"
    }
    
    func configureContries(_ countries:[Country], andSelectCountry selectCountry:((Country) -> ())?) {
        self.countries = countries
        self.selectCountryClosure = selectCountry
        
        self.countriesPickerView.reloadAllComponents()
    }
    
    @IBAction func actionCancelButton(_ sender:UIButton) {
        removeFromSuperview()
    }
    
    @IBAction func actionSelectButton(_ sender:UIButton) {
        if (selectCountryClosure != nil && selectCountry != nil) {
            selectCountryClosure!(self.selectCountry!)
        }
        self.actionCancelButton(self.cancelButton)
    }
}

extension CountriesView: UIPickerViewDelegate, UIPickerViewDataSource {
    //MARK: UIPickerViewDataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.countries.count
    }
    
    //MARK: UIPickerViewDelegate
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let country = self.countries[row]
        return country.name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let country = self.countries[row]
        self.selectCountry = country
    }
}
