//
//  TranslatorViewController.swift
//  YaTranslator
//
//  Created by Мартынов Дмитрий on 16/09/2018.
//  Copyright © 2018 Мартынов Дмитрий. All rights reserved.
//
import Foundation
import UIKit

class TranslatorViewController: UIViewController {
    
    @IBOutlet private var inputTextView: UITextView!
    @IBOutlet private var outputTextView: UITextView!
    @IBOutlet private var inputCountryButton: UIButton!
    @IBOutlet private var outputCountryButton: UIButton!
    @IBOutlet private var swapButton:UIButton!
    
//    private weak var _translateView: TranslateToolBarView?
    private weak var countriesView: CountriesView!
    private weak var translateView: TranslateToolBarView!/* {
        if _translateView == nil {
            let view = Bundle.main.loadNibNamed("TranslateToolBarView", owner: nil, options: nil)?.first as! TranslateToolBarView
            view.translatesAutoresizingMaskIntoConstraints = false
            view.delegate = self
            self.view.addSubview(view)
            _translateView = view
        }
        return _translateView
    }
    lazy var countriesView: CountriesView = {
        let view = Bundle.main.loadNibNamed("CountriesView", owner: nil, options: nil)?.first as! CountriesView
        view.translatesAutoresizingMaskIntoConstraints = false
        self.tabBarController?.view.addSubview(view)
        return view
    }()*/
    
    
    private var translator: Traslator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let coreData = CoreDataService()
        let read: Traslator? = coreData.getTranslators(status: .Active).first
        let def = coreData.translatorDefault()
        translator = read ?? def
        
        let inputs = coreData.getInputCountries()
        if inputs.count == 0 {
            requestSupport()
        } else {
            configureTranslator(translator)
        }
        
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(self.openKeyboard), name: .UIKeyboardDidShow, object: nil)
        nc.addObserver(self, selector: #selector(self.closeKeyboard), name: .UIKeyboardDidHide, object: nil)
//        nc.addObserver(self, selector: Selector(("openKeyboard:")), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
//        nc.addObserver(self, selector: Selector(("closeKeyboard:")), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
        
        self.inputCountryButton.accessibilityIdentifier = "translator_input_country_button"
        self.outputCountryButton.accessibilityIdentifier = "translator_output_country_button"
        self.swapButton.accessibilityIdentifier = "translator_swap_button"
        self.inputTextView.accessibilityIdentifier = "translator_input_textView"
        self.outputTextView.accessibilityIdentifier = "translator_output_textView"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK:- Request
    func requestSupport() {
        let locale = Bundle.main.preferredLocalizations.first
        let api = YandexAPIService()
        let params = ["ui":locale ?? "ru"]
        api.requestQuery(.getLangs, andObject: nil, andParams: params, andDelegate: self)
    }
    
    func requestTranslate() {
        let service = YandexAPIService()
        service.requestQuery(YandexAPIService.Query.translate, andObject:translator, andParams: translator.requestParams, andDelegate: self)
    }
    
    //MARK:- Configure
    func configureTranslator(_ translator: Traslator) {
        DispatchQueue.main.async {
            self.inputTextView.text = translator.inputLanguage.text
            self.outputTextView.text = translator.outputLanguage.text
            
            self.inputCountryButton.setTitle(translator.inputLanguage.name, for: UIControlState.normal)
            self.outputCountryButton.setTitle(translator.outputLanguage.name, for: UIControlState.normal)
        }
    }
    
    func saveTranslator(_ translator:Traslator) {
        let coreData = CoreDataService()
        coreData.saveTranslator(translator: translator)
    }
    
    //MARK:- Notification
    @objc func openKeyboard(notification:Notification) {
        let userInfo = notification.userInfo
        let rect = userInfo![UIKeyboardFrameEndUserInfoKey] as! CGRect
        
        let height:CGFloat = 46.0
        let bottom = rect.height
        
        var view:TranslateToolBarView? = nil
        if self.translateView != nil {
            view = self.translateView
        } else {
            view = Bundle.main.loadNibNamed("TranslateToolBarView", owner: nil, options: nil)?.first as? TranslateToolBarView
            view!.translatesAutoresizingMaskIntoConstraints = false
            view!.delegate = self
            self.view.addSubview(view!)
            self.translateView = view!
        }

        let views = ["translateView":view as Any] as [String : Any]
        let metrics = ["height":height, "bottom":bottom]
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[translateView]|", options: [], metrics: nil, views: views))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[translateView(height)]-bottom-|", options: [], metrics: metrics, views: views))
    }
    
    @objc func closeKeyboard(notification:Notification) {
        if translateView != nil {
            translateView!.removeFromSuperview()
            translateView = nil
        }
        print("translateView:\(String(describing: translateView))")
    }
    
    //MARK:- Action
    @IBAction func actionChangeLanguagesButton(_ sender:UIButton) {
        self.translator.swapLanguages()
        self.saveTranslator(self.translator)
        self.configureTranslator(self.translator)
    }
    
    @IBAction func actionInputCountryButton(_ sender:UIButton) {
        let coreData = CoreDataService()
        let inputs = coreData.getInputCountries()
        
        let view = Bundle.main.loadNibNamed("CountriesView", owner: nil, options: nil)?.first as! CountriesView
        view.translatesAutoresizingMaskIntoConstraints = false
        self.tabBarController?.view.addSubview(view)
        self.countriesView = view
        
        let views = ["countriesView":view]
        let metrics = ["height":170.0]
        self.tabBarController?.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[countriesView]|", options: [], metrics: nil, views: views))
        self.tabBarController?.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[countriesView(height)]|", options: [], metrics: metrics, views: views))
        
        countriesView.configureContries(inputs) { (country:Country) in
            self.translator.addInputCountry(country: country)
            self.configureTranslator(self.translator)
        }
    }
    
    @IBAction func actionOutputCountryButton(_ sender:UIButton) {
        let coreData = CoreDataService()
        let outputs = coreData.getOutputCountriesByCode(self.translator.inputLanguage.code)
        
        let view = Bundle.main.loadNibNamed("CountriesView", owner: nil, options: nil)?.first as! CountriesView
        view.translatesAutoresizingMaskIntoConstraints = false
        self.tabBarController?.view.addSubview(view)
        self.countriesView = view
        
        let views = ["countriesView":view]
        let metrics = ["height":170.0]
        self.tabBarController?.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[countriesView]|", options: [], metrics: nil, views: views))
        self.tabBarController?.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[countriesView(height)]|", options: [], metrics: metrics, views: views))
        
        countriesView.configureContries(outputs) { (country:Country) in
            self.translator.addOunputCountry(country: country)
            self.configureTranslator(self.translator)
        }
    }
}

extension TranslatorViewController: YandexAPIServiceDelegate {
    func yandexFail(_ service: YandexAPIService, didFail error: Error) {
        let message = error.localizedDescription
        
        let okAction = UIAlertAction.init(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        let alert = UIAlertController(title: nil, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(okAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func yandexSupportLanguages(_ service: YandexAPIService, didSupportLanguages supports: [SupportLanguage]) {
        if translator == nil {
            let coreData = CoreDataService()
            translator = coreData.translatorDefault()
        }
        self.configureTranslator(self.translator)
    }
    
    func yandex(_ service: YandexAPIService, didTranslate translator: Traslator) {
        self.configureTranslator(translator)
    }
}

extension TranslatorViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        self.translator.setInputText(textView.text)
        self.saveTranslator(self.translator)
    }
}

extension TranslatorViewController: TranslateToolBarDelegate {
    func clearText(_ toolBar: TranslateToolBarView) {
        self.translator.setInputText("")
        self.configureTranslator(self.translator)
        self.saveTranslator(self.translator)
    }
    
    func cancel(_ toolBar: TranslateToolBarView) {
        self.inputTextView.resignFirstResponder()
    }
    
    func translate(_ toolBar: TranslateToolBarView) {
        self.saveTranslator(self.translator)
        self.requestTranslate()
        self.cancel(toolBar)
    }
}
