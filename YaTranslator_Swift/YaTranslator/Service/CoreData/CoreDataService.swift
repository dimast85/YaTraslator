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
    static let SupportEntityName = "SupportEntity"
    
    var managedObjectContext:NSManagedObjectContext {
        get {
            let app = UIApplication.shared.delegate as! AppDelegate
            return app.persistentContainer.viewContext
        }
    }
    
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
    
    private func removeAllSupportLanguages() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: CoreDataService.SupportEntityName)
        let result = try? self.managedObjectContext.fetch(request)
        for obj in result as! [NSManagedObject] {
            self.managedObjectContext .delete(obj)
        }
    }
    
    private func saveContext() {
        let app = UIApplication.shared.delegate as! AppDelegate
            app.saveContext()
    }
}
