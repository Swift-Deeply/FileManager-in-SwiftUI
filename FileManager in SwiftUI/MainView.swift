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
    @State private var editMode: EditMode = .inactive
    
    // MARK: - UI Elements
    var body: some View {
        NavigationView {
            List {
                ForEach(dataProvider.allNotes) { note in
                    NoteListCell(note: note)
                }
            }
            .navigationTitle(Text("Notes"))
            .navigationBarItems(
                leading: EditButton(),
                
                trailing: Button(action: {
                    alertShowing = true
                }) {
                    Image(systemName: "plus.circle.fill")
                }
            )
            .textFieldAlert(isPresented: $alertShowing) {
                TextFieldAlert(title: "wpefk", message: "oefpowkefopew")
            }
            .listStyle(InsetListStyle())
            .environment(\.editMode, $editMode)
        }
    }
    
    // MARK: - Methods
    private func onDelete(offsets: IndexSet) {
            items.remove(atOffsets: offsets)
        }

    // 3.
    private func onMove(source: IndexSet, destination: Int) {
        items.move(fromOffsets: source, toOffset: destination)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(dataProvider: DataProvider.shared)
    }
}
