//
//  ContentView.swift
//  FileManager in SwiftUI
//
//  Created by Can Balkaya on 2/12/21.
//

import SwiftUI

struct MainView: View {
    
    // MARK: - Properties
    @ObservedObject var dataProvider: DataProvider
    @State private var alertShowing = false
    @State var noteTitle: String?
    @State var noteDescription: String?
    
    // MARK: - UI Elements
    var body: some View {
        NavigationView {
            List {
                ForEach(dataProvider.allNotes) { note in
                    Text("\(note.title)")
                }
            }
            .textFieldAlert(isPresented: $alertShowing) {
                TextFieldAlert(title: "wpefk", message: "oefpowkefopew", noteTitle: $noteTitle, noteDescription: $noteDescription)
            }
            .navigationTitle("Notes")
            .navigationBarItems(trailing: Button(action: {
                alertShowing = true
            }) {
                Image(systemName: "plus.circle.fill")
            })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(dataProvider: DataProvider.shared)
    }
}
