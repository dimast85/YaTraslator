//
//  CoreDataService.swift
//  YaTranslator
//
//  Created by Dmitriy Martynov on 21/09/2018.
//  Copyright © 2018 Мартынов Дмитрий. All rights reserved.
//

import UIKit
import CoreData

struct CoreDataService {
    // MARK:-
    static let SupportEntityName = "SupportEntity"
    static let TranslatorEntityName = "TranslatorEntity"
    static let InputLanguageEntityName = "InputLanguageEntity"
    static let OutputLanguageEntityName = "OutputLanguageEntity"
    
    var managedObjectContext:NSManagedObjectContext {
        get {
            let app = UIApplication.shared.delegate as! AppDelegate
            return app.persistentContainer.viewContext
        }
    }
    
    // MARK:-
    public func saveSupportLanguages(_ supportLanguages:[SupportLanguage]) {
        self.removeAllSupportLanguages()
        
        for support in supportLanguages {
            self.saveSupportLanguage(support)
        }
        
        self.saveContext()
    }
    
    private func saveSupportLanguage(_ support:SupportLanguage) {
        let supportEntity = NSEntityDescription.insertNewObject(forEntityName: CoreDataService.SupportEntityName, into: self.managedObjectContext) as! SupportEntity
            supportEntity.inputCountryCode = support.inputCountry?.code
            supportEntity.inputCountryName = support.inputCountry?.name
        
        for country in support.outputCountries {
            let countryEntity = NSEntityDescription.insertNewObject(forEntityName: "CountryEntity", into: self.managedObjectContext) as! CountryEntity
                countryEntity.code = country.code
                countryEntity.name = country.name
                supportEntity.addToCountries(countryEntity)
        }
    }
    
    func saveTranslator(translator:Traslator) {
        if translator.inputLanguage.text == translator.outputLanguage.text {
            return
        }
        
        // Remove Active
        if translator.status == .Active {
            let activeTranslators = self.searchTranslateEntitys(status: translator.status)
            for aTranslator in activeTranslators {
                self.managedObjectContext.delete(aTranslator)
            }
        }
        
        // Create Translator Entity
        let translatorEntity = NSEntityDescription.insertNewObject(forEntityName: CoreDataService.TranslatorEntityName, into: self.managedObjectContext) as! TranslatorEntity
        translatorEntity.status = Int16(translator.status.rawValue)
        
        
        // Input
        let inputEntity = NSEntityDescription.insertNewObject(forEntityName: CoreDataService.InputLanguageEntityName, into: self.managedObjectContext) as! InputLanguageEntity
        inputEntity.text = translator.inputLanguage.text
        
        let coutryInEntity = NSEntityDescription.insertNewObject(forEntityName: "CountryEntity", into: self.managedObjectContext) as! CountryEntity
        coutryInEntity.code = translator.inputLanguage.code
        coutryInEntity.name = translator.inputLanguage.name
        inputEntity.country = coutryInEntity
        translatorEntity.inputLanguage = inputEntity
        
        // Output
        let outputEntity = NSEntityDescription.insertNewObject(forEntityName: CoreDataService.OutputLanguageEntityName, into: self.managedObjectContext) as! OutputLanguageEntity
        outputEntity.text = translator.outputLanguage.text
        let coutryOutEntity = NSEntityDescription.insertNewObject(forEntityName: "CountryEntity", into: self.managedObjectContext) as! CountryEntity
        coutryOutEntity.code = translator.outputLanguage.code
        coutryOutEntity.name = translator.outputLanguage.name
        outputEntity.country = coutryOutEntity
        translatorEntity.outputLanguage = outputEntity
        
        self.saveContext()
    }
    
    // MARK:-
    func getInputCountries() -> [Country] {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: CoreDataService.SupportEntityName)
        let supports = try? self.managedObjectContext.fetch(request)
        var inputs = [Country]()
        for supportEntity in supports as! [SupportEntity] {
            let country = Country(code: supportEntity.inputCountryCode!, name: supportEntity.inputCountryName!)
            inputs.append(country)
        }
        return inputs
    }
    
    func getOutputCountriesByCode(_ code:String) -> [Country] {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: CoreDataService.SupportEntityName)
        let predicate = NSPredicate(format: "inputCountryCode == %@", code)
            request.predicate = predicate
        
        var outputsCountries = [Country]()
        let support = try? self.managedObjectContext.fetch(request).first as! SupportEntity
        for coutryEntity in support?.countries?.allObjects as! [CountryEntity] {
            let country = Country(code: coutryEntity.code!, name: coutryEntity.name!)
            outputsCountries.append(country)
        }
        
        return outputsCountries;
    }
    
    func getTranslators(status: Traslator.Status) -> [Traslator] {
        let translatorEntitys = self.searchTranslateEntitys(status: status)
        var translators = [Traslator]()
        for entity in translatorEntitys {
            let translator = self.translator(translatorEntity: entity)
            translators.append(translator)
        }
        return translators
    }
    
    func translatorDefault() -> Traslator? {
        let inputCountries = self.getInputCountries()
        if inputCountries.count == 0 {
            return nil
        }
        
        let code = "ru"
        let inCountry = inputCountries.filter { $0.code == "ru" }.first
        let outputCountries = self.getOutputCountriesByCode(code)
        let outCountry = outputCountries.filter { $0.code == "en" }.first
        
        let translator = Traslator(inputCountry: inCountry!, outputCountry: outCountry!)
        return translator
    }
    
    // MARK: -
    private func removeAllSupportLanguages() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: CoreDataService.SupportEntityName)
        let result = try? self.managedObjectContext.fetch(request)
        for obj in result as! [NSManagedObject] {
            self.managedObjectContext .delete(obj)
        }
    }
    
    /// Удалаяем все
    /// - Warning: Только для UnitTest
    func removeAll() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: CoreDataService.TranslatorEntityName)
        let translators = try? self.managedObjectContext.fetch(request) as! [TranslatorEntity]
        for entity in translators! {
            self.managedObjectContext.delete(entity)
        }
        
        self.removeAllSupportLanguages()
    }
    
    
    func clearHistory() {
        let translators = self.searchTranslateEntitys(status: Traslator.Status.History)
        for translate in translators {
            self.managedObjectContext.delete(translate)
        }
        self.saveContext()
    }
    
    
    // MARK:-
    func translator(translatorEntity:TranslatorEntity) -> Traslator {
        let inCountry = Country(code: (translatorEntity.inputLanguage?.country?.code)!, name: (translatorEntity.inputLanguage?.country?.name)!)
        let outCountry = Country(code: (translatorEntity.outputLanguage?.country?.code)!, name: (translatorEntity.outputLanguage?.country?.name)!)
        let translator = Traslator(inputCountry: inCountry, outputCountry: outCountry)
            translator.status = Traslator.Status(rawValue: Int(translatorEntity.status))!
            translator.inputLanguage.text = (translatorEntity.inputLanguage?.text)!
            translator.outputLanguage.text = (translatorEntity.outputLanguage?.text)!
        return translator
    }
    
    // MARK:-
    func searchTranslateEntitys(status:Traslator.Status) -> [TranslatorEntity] {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: CoreDataService.TranslatorEntityName)
        let predicate = NSPredicate(format: "SELF.status == \(status.rawValue)")
            request.predicate = predicate
        
        let translators = try? self.managedObjectContext.fetch(request) as! [TranslatorEntity]
        return translators!
    }
    
    // MARK: -
    private func saveContext() {
        let app = UIApplication.shared.delegate as! AppDelegate
            app.saveContext()
    }
}
