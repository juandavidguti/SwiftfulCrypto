//
//  UIScreen.swift
//  SwiftfulCrypto
//
//  Created by Juan David Gutierrez Olarte on 11/08/25.
//
import UIKit

@MainActor
extension UIScreen {
    /// UIScreen de la escena en primer plano (fallback a .main para previews)
    static var current: UIScreen {
        let scenes = UIApplication.shared.connectedScenes
        let winScene = scenes
            .first { $0.activationState == .foregroundActive } as? UIWindowScene
        return winScene?.screen ?? .main
    }
}
