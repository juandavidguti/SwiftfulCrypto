//
//  UIApplication.swift
//  SwiftfulCrypto
//
//  Created by Juan David Gutierrez Olarte on 27/08/25.
//

import Foundation
import SwiftUI

extension UIApplication {
    // hecho para ocultar hide teclado keyboard despues de escribir
    
    func endEditing(){
        sendAction(
            #selector(UIResponder.resignFirstResponder),to: nil,from: nil,for: nil)
    }
}
