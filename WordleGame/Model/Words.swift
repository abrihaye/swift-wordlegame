//
//  Words.swift
//  CodeBreaker
//
//  Created by CS193p Instructor on 4/16/25.
//

import SwiftUI
import UIKit

extension EnvironmentValues {
    @Entry var words = Words.shared
}

enum Language: String, CaseIterable, Codable {
    case english = "english"
    case french = "french"
    
    var solutionURL: URL? {
        switch self {
        case .english:
            return URL(string: "https://raw.githubusercontent.com/abrihaye/swift-wordlegame/refs/heads/main/Resources/solutions_en.txt")
        case .french:
            return URL(string: "https://raw.githubusercontent.com/abrihaye/swift-wordlegame/refs/heads/main/Resources/solutions_fr.txt")
        }
    }
    
    var validationURL: URL? {
        switch self {
        case .english:
            return URL(string: "https://raw.githubusercontent.com/abrihaye/swift-wordlegame/refs/heads/main/Resources/dictionary_en.txt")
        case .french:
            return URL(string: "https://raw.githubusercontent.com/abrihaye/swift-wordlegame/refs/heads/main/Resources/dictionary_fr.txt")
        }
    }
    
    var code: String {
        switch self {
        case .english: return "en_US"
        case .french: return "fr_FR"
        }
    }
}

@Observable
class Words {
    //private var solutions = Dictionary<String,Dictionary<Int, Set<String>>>()
    private var solutionsDicts = Dictionary<String, Dictionary<Int, Set<String>>>()
    private var validationDicts = Dictionary<String, Dictionary<Int, Set<String>>>()
    
    var language = Language.english
    
    static let shared =
        Words()

    private init() { }
    
    // Count of solutions
    var count: Int {
        solutionsDicts.values.reduce(0) { $0 + $1.count }
    }
    
    func reloadAll() async {
        for language in Language.allCases {
            // Check if the URLs are loaded
            if isDownloaded(language) {
                await load(language)
            }
        }
    }
    
    func isDownloaded(_ language: Language) -> Bool {
        if let solutionURL = language.solutionURL, let validationURL = language.validationURL {
            do {
                let filesLocation = try FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                
                let solutionLastComp = solutionURL.lastPathComponent
                let validationLastComp = validationURL.lastPathComponent
                
                let finalURLs = [filesLocation.appending(path: solutionLastComp) ,
                                 filesLocation.appending(path: validationLastComp)]
                return FileManager.default.fileExists(atPath: finalURLs[0].path) &&
                       FileManager.default.fileExists(atPath: finalURLs[1].path)
            
            } catch {
                print("\(error)")
                return false
            }
            
        }
        return false
    }
    
    func load(_ language: Language) async {
        guard (solutionsDicts[language.code] == nil) || (validationDicts[language.code] == nil) else {
            return
        }
        
        let solutionURL = language.solutionURL
        let dictionaryURL = language.validationURL
        
        guard let solutionURL, let dictionaryURL else {
            print("Invalid dictionaries URL")
            return
        }
        
        let localSolURL = try? await WordsLoader.downloadDictionary(from: solutionURL)
        let localDictURL = try? await WordsLoader.downloadDictionary(from: dictionaryURL)
        
        if let localSolURL {
            solutionsDicts[language.code] = await WordsLoader.loadDictionary(from: localSolURL)
        } else {
            print("Invalid localSolURL for \(language.code)")
        }
        
        if let localDictURL {
            validationDicts[language.code] = await WordsLoader.loadDictionary(from: localDictURL)
        } else {
            print("Invalid localDictURL for \(language.code)")
        }
        
        if count > 0 {
            print("Words loaded \(count) words from \(solutionURL.absoluteString)")
        }
    }
    
    func contains(_ word: String, in language: Language) -> Bool {
        validationDicts[language.code]?[word.count]?.contains(word.uppercased()) == true
    }

    func random(length: Int, in language: Language) -> String? {
        let word = solutionsDicts[language.code]?[length]?.randomElement()
        if word == nil {
            print("Words could not find a random word of length \(length)")
        }
        return word
    }
}


extension UITextChecker {
    func isAWord(_ word: String, in language: String) -> Bool {
        rangeOfMisspelledWord(
            in: word,
            range: NSRange(location: 0, length: word.utf16.count),
            startingAt: 0,
            wrap: false,
            language: language
        ).location == NSNotFound
    }
}
