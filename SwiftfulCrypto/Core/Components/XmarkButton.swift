//
//  XmarkButton.swift
//  SwiftfulCrypto
//
//  Created by Juan David Gutierrez Olarte on 27/08/25.
//

import SwiftUI

struct XmarkButton: View {
    @Environment(\.dismiss) var dismiss
    var body: some View {
        Button {
            dismiss.callAsFunction()
        } label: {
            Image(systemName: "xmark")
                .font(.headline)
        }
    }
}

#Preview {
    XmarkButton()
}
