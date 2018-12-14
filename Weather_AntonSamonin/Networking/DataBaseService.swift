//
//  DataBaseService.swift
//  Weather_AntonSamonin
//
//  Created by Anton Samonin on 12/10/18.
//  Copyright © 2018 AntCo. All rights reserved.
//

import Foundation
import RealmSwift

class DataBaseService {
    static var configuration: Realm.Configuration  {
        return Realm.Configuration(deleteRealmIfMigrationNeeded: true)
    }
    
  @discardableResult
    static func saveToRealm<Element: Object>(items: [Element], config: Realm.Configuration = Realm.Configuration.defaultConfiguration, update: Bool = true) -> Realm? {
    do {
        let realm = try Realm(configuration: config)
        print(realm.configuration.fileURL ?? "")
        let oldItems = realm.objects(Element.self)
        try realm.write {
            realm.delete(oldItems)
            realm.add(items)
        }
        return realm
    }
    catch {
        print(error.localizedDescription)
    }
    return nil
    }
    
    
    static func get<Element: Object>(itemsType: Element.Type, config: Realm.Configuration = Realm.Configuration.defaultConfiguration) -> Results<Element>? {
        do {
            let realm = try Realm(configuration: config)
            return realm.objects(itemsType)
        }
        catch {
            print(error.localizedDescription)
        }
        return nil
    }
    
    
    
}
