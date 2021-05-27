//
//  FileLoader.swift
//  CognizantChallengeTests
//
//  Created by Dave Caddy on 27/5/21.
//

import Foundation

class FileLoader {
    
    func loadData(fromFileAtPath filePath: String?) -> Data? {
        if let path = filePath {
            do {
                return try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            }
            catch _ as NSError {
                return nil
            }
        }
        
        return nil
    }
}
