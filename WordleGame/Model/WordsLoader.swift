//
//  WordsLoader.swift
//  WordleGame
//
//  Created by Alexandre Brihaye on 2026-04-20.
//

import Foundation

struct WordsLoader {
    enum DownloadError: Error {
        case failedDownload
        case nilHttpResponse
        case unknown
    }
    
    static func downloadDictionary(from url: URL) async throws -> URL? {
        let fileManager: FileManager = FileManager.default
        let documentsURL = try fileManager.url(
            for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)

        let destinationURL = documentsURL.appending(path: url.lastPathComponent)
        // Check if the file exists already
        if fileManager.fileExists(atPath: destinationURL.path) {
            dPrint("File already exists at \(destinationURL.path)")
            return destinationURL
        }

        let (urlLocation, urlResponse) = try await URLSession.shared.download(from: url)
        
        dPrint(urlResponse.url ?? "No URL in the response")
        dPrint(urlLocation)

        guard let httpResponse = urlResponse as? HTTPURLResponse, httpResponse.statusCode == 200
        else { throw (urlResponse as? HTTPURLResponse == nil ? DownloadError.nilHttpResponse: DownloadError.failedDownload)}

        try fileManager.moveItem(at: urlLocation, to: destinationURL)

        dPrint(destinationURL)
        return destinationURL
    }

    static func loadDictionary(from url: URL) async -> Dictionary<Int, Set<String>>
    {
        let characterList = CharacterSet(charactersIn: ".'")
        var dictionary: Dictionary<Int, Set<String>> = [:]
        do {
            for try await word in url.lines
            {
                if let wordToInsert = word.applyingTransform(StringTransform.stripDiacritics, reverse: false),
                wordToInsert.rangeOfCharacter(from: characterList) == nil {
                    dictionary[wordToInsert.count, default: []].insert(wordToInsert.uppercased())
                }
                
            }
        } catch {
            print("\(error)")
        }
        return dictionary
    }

    static func dPrint(_ info: Any, funcName: String = #function) {
        #if DEBUG
        print("[D]f-\(funcName) - \(info)")
        #endif
    }
}
