//
//  View+Ext.swift
//  FileManager in SwiftUI
//
//  Created by Can Balkaya on 2/25/21.
//

import SwiftUI

extension View {
    
    // MARK: - Methods
    func textFieldAlert(isPresented: Binding<Bool>, content: @escaping () -> TextFieldAlert) -> some View {
        TextFieldWrapper(isPresented: isPresented, presentingView: self, content: content)
    }
}
