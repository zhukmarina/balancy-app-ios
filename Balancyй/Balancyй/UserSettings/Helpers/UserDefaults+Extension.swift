//
//  UserDefaults.swift
//  Balancy
//
//  Created by Oleksandr on 15.10.2024.
//

import Foundation

extension UserDefaults {
    static func save(timeBalance: TimeBalance) {
        if let encoded = try? JSONEncoder().encode(timeBalance) {
            UserDefaults.standard.set(encoded, forKey: "selectedTime")
        }
    }
    
    static var timeBalance: TimeBalance? {
        guard let data = UserDefaults.standard.data(forKey: "selectedTime"),
              let timeBalance = try? JSONDecoder().decode(TimeBalance.self, from: data)
        else { return nil }
        
        return timeBalance
    }
}

