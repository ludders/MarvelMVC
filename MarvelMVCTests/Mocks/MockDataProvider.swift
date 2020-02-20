//
//  MockDataProvider.swift
//  MarvelMVCTests
//
//  Created by dludlow7 on 20/02/2020.
//  Copyright © 2020 David Ludlow. All rights reserved.
//

import Foundation

class MockResourceDataProvider {
    static func data(fromFile filename: String, ofType ext: String?) -> Data? {
        guard let filePath = Bundle(for: self).path(forResource: filename, ofType: ext) else { return nil }
        let url = URL(fileURLWithPath: filePath)
        return try? Data(contentsOf: url)
    }
}
