//
//  String.swift
//  SwiftfulCrypto
//
//  Created by Juan David Gutierrez Olarte on 29/08/25.
//

import Foundation

extension String {
    
    var removingHTMLOccurances: String {
        return self.replacingOccurrences(
            of: "<[^>]+>",
            with: "",
            options: .regularExpression
            , range: nil)
    }
}
