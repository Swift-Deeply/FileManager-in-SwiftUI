//
//  NoteListCell.swift
//  FileManager in SwiftUI
//
//  Created by Can Balkaya on 2/27/21.
//

import SwiftUI

struct NoteListCell: View {
    
    // MARK: - Properties
    let note: Note
    
    // MARK: - UI Elements
    var body: some View {
        Text("\(note.title)")
    }
}

struct NoteListCell_Previews: PreviewProvider {
    static var previews: some View {
        NoteListCell(note: Note(title: "", description: ""))
    }
}
