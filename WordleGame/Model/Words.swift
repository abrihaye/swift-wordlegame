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

enum Language: String {
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

struct LanguageWords {
    let code: String = ""
    let solutions: [String] = []
    let validation: Dictionary<Int, Set<String>> = [:]
}

@Observable
class Words {
    private var words = Dictionary<Int, Set<String>>()
    
    var language = Language.english
    
    static let shared =
        Words()

    private init() { }
    
    var count: Int {
        words.values.reduce(0) { $0 + $1.count }
    }
    
    func load(_ language: Language) {
        self.language = language
        Task {
            var _words = [Int:Set<String>]()
            let url = language.solutionURL
            if let url {
                do {
                    for try await word in url.lines {
                        _words[word.count, default: Set<String>()].insert(word.uppercased())
                    }
                } catch {
                    print("Words could not load words from \(url): \(error)")
                }
            }
            words = _words
            if count > 0 {
                print("Words loaded \(count) words from \(url?.absoluteString ?? "nil")")
            }
        }
    }
    
    func contains(_ word: String) -> Bool {
        words[word.count]?.contains(word.uppercased()) == true
    }

    func random(length: Int) -> String? {
        let word = words[length]?.randomElement()
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
