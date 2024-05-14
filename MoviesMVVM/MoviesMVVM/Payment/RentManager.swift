//
//  RentManager.swift
//  MoviesMVVM
//
//  Created by Mehmet ÖKSÜZ on 26.01.2024.
//

import Foundation

class RentManager {
    
    static let shared = RentManager()
    private init() {
            startExpirationTimer()
        }
    let userDefaults = UserDefaults.standard
    var rentedItems: [RentItem] = []
    let rentKey = "rentedItems"
    
    struct RentItem: Codable {
        let item: Results
        let addedTimestamp: TimeInterval
    }
    
    var expirationTimer: Timer?
    
    func startExpirationTimer() {
        expirationTimer = Timer.scheduledTimer(timeInterval: 20, target: self, selector: #selector(removeExpiredItemsIfNeeded), userInfo: nil, repeats: true)
    }

    @objc func removeExpiredItemsIfNeeded() {
        removeExpiredItems()
    }
    
    func loadRentedItems() {
        if let data = userDefaults.data(forKey: rentKey),
           let items = try? JSONDecoder().decode([RentItem].self, from: data) {
            self.rentedItems = items
            NotificationCenter.default.post(name: NSNotification.Name("rent"), object: nil)
        }
    }
    
    func addToRentedData(item: Results) {
        let rentItem = RentItem(item: item, addedTimestamp: Date().timeIntervalSince1970)
        rentedItems.append(rentItem)
        savedRentedItems()
        NotificationCenter.default.post(name: NSNotification.Name("rent"), object: nil)
    }
    
   func deleteRentedMovie(_ movie: RentItem) {
        if let index = rentedItems.firstIndex(where: { $0.item.id == movie.item.id }) {
            rentedItems.remove(at: index)
        } else {
            print("error")
        }
        savedRentedItems()
        NotificationCenter.default.post(name: NSNotification.Name("rent"), object: nil)
    }
    
    func isRented(item: Results) -> Bool {
        return rentedItems.contains { $0.item.id == item.id }
    }
    
    func savedRentedItems() {
        if let data = try? JSONEncoder().encode(rentedItems) {
            userDefaults.set(data, forKey: rentKey)
        }
    }
    
    func removeExpiredItems() {
        let currentDate = Date().timeIntervalSince1970
        rentedItems = rentedItems.filter { currentDate - $0.addedTimestamp <= 20 }
        savedRentedItems()
        NotificationCenter.default.post(name: NSNotification.Name("rent"), object: nil)
    }
    
    func saveRentItems(cartItems: [HomeTableViewCell.ViewModel]) {
        let encodedData = try? JSONEncoder().encode(rentedItems)
        userDefaults.set(encodedData, forKey: rentKey)
    }
}


