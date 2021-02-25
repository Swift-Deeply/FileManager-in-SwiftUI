//
//  ContentView.swift
//  FileManager in SwiftUI
//
//  Created by Can Balkaya on 2/12/21.
//

import SwiftUI

struct ContentView: View {
    
    // MARK: - Properties
    @ObservedObject var dataProvider: DataProvider
    
    // MARK: - UI Elements
    var body: some View {
        NavigationView {
            List {
                ForEach(dataProvider.allNotes) { note in
                    Text("\(note.title)")
                }
            }
            .navigationTitle("Notes")
            .navigationBarItems(trailing: Button(action: {
                
            }) {
                Image(systemName: "plus.circle.fill")
            })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(dataProvider: DataProvider.shared)
    }
}
