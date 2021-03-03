//
//  ContentView.swift
//  FileManager in SwiftUI
//
//  Created by Can Balkaya on 2/12/21.
//

import SwiftUI

struct MainView: View {

    // MARK: - Properties
    @ObservedObject var dataProvider = DataProvider.shared
    @State private var alertShowing = false
    @State private var editMode: EditMode = .inactive

    // MARK: - UI Elements
    var body: some View {
        NavigationView {
            List {
                ForEach(dataProvider.allNotes) { note in
                    NoteListCell(note: note)
                }
                .onDelete(perform: dataProvider.delete)
                .onMove(perform: dataProvider.move)
            }
            .navigationTitle(Text("Notes"))
            .navigationBarItems(
                leading: EditButton(),
                trailing: AddButton(editMode: $editMode, alertShowing: $alertShowing)
            )
            .textFieldAlert(isPresented: $alertShowing) {
                TextFieldAlert(title: "Write a note!", message: nil)
            }
            .listStyle(InsetListStyle())
            .environment(\.editMode, $editMode)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ///
        MainView(dataProvider: DataProvider.shared)
    }
}
