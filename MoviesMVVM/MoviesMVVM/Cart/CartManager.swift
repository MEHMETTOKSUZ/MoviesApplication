//
//  CartViewModel.swift
//  MoviesMVVM
//
//  Created by Mehmet ÖKSÜZ on 21.01.2024.
//

import Foundation

class CartManager {
    
    static let shared = CartManager()
    private init() {}
    
    let userDefaults = UserDefaults.standard
    private var items: [Results] = []
    let key = "addedToCart"
    
    func loadCartItems() {
        if let data = userDefaults.object(forKey: key) as? Data,
           let items = try? JSONDecoder().decode([Results].self, from: data) {
            self.items = items
          //  sendNotification()
        }
    }
    
    func get() -> [Results] {
        
        self.loadCartItems()
        return items
    }
    
    func add(item: Results) {
        if let index = items.firstIndex(where: {$0.id == item.id}) {
            items.remove(at: index)
        } else {
            items.append(item)
        }
        savedCartItems()
        sendNotification()
    }
    
    func delete(for id: Int) {
        if let index = items.firstIndex(where: { $0.id == id }) {
            items.remove(at: index)
        } else {
            print("error")
        }
        savedCartItems()
        sendNotification()
    }
    
    func savedCartItems() {
        if let data = try? JSONEncoder().encode(items) {
            userDefaults.set(data, forKey: key)
            
        }
    }
    
    func isInCart(item: Results) -> Bool {
        return items.contains {$0.id == item.id}
    }
    
    func calculateTotalPrice() -> (purchaseTotal: Double, rentTotal: Double) {
        let purchaseTotal = Double(items.count) * 2.99
        let rentTotal = Double(items.count) * 0.99
        return (purchaseTotal, rentTotal)
    }
    
    func removeAllItems() {
        items.removeAll()
        savedCartItems()
        sendNotification()
    }
    
    func sendNotification() {
      NotificationCenter.default.post(name: NSNotification.Name("newMovies"), object: nil)
    }
}
