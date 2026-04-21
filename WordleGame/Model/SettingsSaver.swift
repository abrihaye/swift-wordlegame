//
//  SettingsSaver.swift
//  WordleGame
//
//  Created by Alexandre Brihaye on 2026-04-01.
//

import SwiftUI

extension EnvironmentValues {
    @Entry var settings = SettingsSaver.shared
}

@Observable
class SettingsSaver {
    static let factoryDefaults: [String: [Double]] = [
            "exactColor": [0.33, 1.0, 1.0, 1.0],   // Green
            "inexactColor": [0.08, 1.0, 1.0, 1.0], // Orange
            "nomatchColor": [0.0, 0.0, 0.5, 1.0]   // Gray
        ]
    
    var exactColor: Color = .green {
        didSet {
            saveColorToDefaults(exactColor, key: "exactColor")
        }
    }
    var inexactColor: Color = .orange {
        didSet {
            saveColorToDefaults(inexactColor, key: "inexactColor")
        }
    }
    var nomatchColor: Color = .gray {
        didSet {
            saveColorToDefaults(nomatchColor, key: "nomatchColor")
        }
    }
    
    var language: Language = Language.english {
        didSet {
            saveLanguage(language)
        }
    }
    
    static let shared = SettingsSaver()
    
    init()
    {
        UserDefaults.standard.register(defaults: SettingsSaver.factoryDefaults)
        UserDefaults.standard.register(defaults: ["language": "english"])
        
        self.exactColor = hsboToColor((UserDefaults.standard.array(forKey: "exactColor") as? [Double])!)
        self.inexactColor = hsboToColor((UserDefaults.standard.array(forKey: "inexactColor") as? [Double])!)
        self.nomatchColor = hsboToColor((UserDefaults.standard.array(forKey: "nomatchColor") as? [Double])!)
        self.language = Language(rawValue: UserDefaults.standard.string(forKey: "language") ?? "english") ?? Language.english
    }
    
    func saveColorToDefaults(_ color: Color, key: String) {
        var h: CGFloat = 0
        var s: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0

        // Convert SwiftUI Color to UIColor to get HSB values
        UIColor(color).getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        let components = [Double(h), Double(s), Double(b), Double(a)]
        UserDefaults.standard.set(components, forKey: key)
    }
    
    func saveLanguage(_ language: Language) {
        UserDefaults.standard.set(language.rawValue, forKey: "language")
    }
    
    func hsboToColor(_ hsbo: [Double]) -> Color {
        Color(
            hue: hsbo[0],
            saturation: hsbo[1],
            brightness: hsbo[2],
            opacity: hsbo[3])
    }
    
    func setToDefaults() {
        self.exactColor = hsboToColor(SettingsSaver.factoryDefaults["exactColor"]!)
        self.inexactColor = hsboToColor(SettingsSaver.factoryDefaults["inexactColor"]!)
        self.nomatchColor = hsboToColor(SettingsSaver.factoryDefaults["nomatchColor"]!)
    }
}
