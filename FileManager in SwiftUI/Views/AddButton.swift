//
//  AddButton.swift
//  FileManager in SwiftUI
//
//  Created by Can Balkaya on 2/27/21.
//

import SwiftUI

struct AddButton: View {

    // MARK: - Properties
    ///
    @Binding var editMode: EditMode
    @Binding var alertShowing: Bool

    // MARK: - UI Elements
    var body: some View {
        ///
        if editMode == .inactive {
            return AnyView(Button(action: {
                    withAnimation {
                        if alertShowing {
                            alertShowing = false
                        } else {
                            alertShowing = true
                        }
                    }
                }) {
                    Image(systemName: "plus.circle.fill")
                })
        } else {
            ///
            return AnyView(EmptyView())
        }
    }
}
