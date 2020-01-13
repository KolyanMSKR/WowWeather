//
//  DBManager.swift
//  WowWeather
//
//  Created by asd dsa on 11/8/19.
//  Copyright © 2019 asd dsa. All rights reserved.
//

import Foundation
import RealmSwift

class DBManager {
    
    func save(city: FavoriteCity) {
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(city)
            }
        } catch {
            fatalError("Fatal -save(city:) error")
        }
    }
    
    func fetchCities() -> [FavoriteCity] {
        do {
            let realm = try Realm()
            return Array(realm.objects(FavoriteCity.self))
        } catch {
            return []
        }
    }

    func remove(city: FavoriteCity) {
        do {
            let realm = try Realm()
            try realm.write {
                realm.delete(city)
            }
        } catch {
            fatalError("Fatal -remove(city:) error")
        }
    }

}


