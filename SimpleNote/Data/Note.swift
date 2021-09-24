//
//  Note.swift
//  SimpleNote
//
//  Created by Erik Flores on 24/9/21.
//

import CoreData

class Note: NSManagedObject {
    @NSManaged private(set) var id: UUID
    @NSManaged private(set) var text: String
    @NSManaged private(set) var register: Date

    static func insert(context: NSManagedObjectContext, text: String) -> Note {
        let note: Note = context.insertObject()
        note.id = UUID()
        note.text = text
        note.register = Date()
        return note
    }

    func update(text: String) {
        self.text = text
    }
}

extension Note: Managed {
    static var defaultSortDescriptors: [NSSortDescriptor] {
        return [NSSortDescriptor(key: #keyPath(register), ascending: true)]
    }
}
