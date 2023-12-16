//
//  ClassRow.swift
//  LesMills
//
//  Created by Asher Foster on 26/09/23.
//

import SwiftUI

struct ClassRow: View {
    var classSession: ClassSession
    
    var body: some View {
        HStack {
            Path(roundedRect: CGRect(x: 0, y: 0, width: 5, height: 50), cornerSize: CGSize(width: 3, height: 3))
//                .fill(style: classInstance.color))
                .frame(width: 5, height: 50)
            VStack(alignment: .leading) {
                Text(classSession.startsAt, style: .time)
                Text("\(classSession.durationMinutes) mins").foregroundStyle(.secondary)
            }
            VStack(alignment: .leading) {
                Text(classSession.name).bold()
                Text(classSession.instructor.name).foregroundStyle(.secondary)
            }
            Spacer()
            Button("Save Class", systemImage: "plus") {}
                .labelStyle(.iconOnly)
        }
    }
}

#Preview {
    ClassRow(classSession: .mock())
}
