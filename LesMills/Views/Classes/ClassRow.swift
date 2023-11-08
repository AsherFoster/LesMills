//
//  ClassRow.swift
//  LesMills
//
//  Created by Asher Foster on 26/09/23.
//

import SwiftUI

struct ClassRow: View {
    var classInstance: ClassInstance
    
    var body: some View {
        HStack {
            Path(roundedRect: CGRect(x: 0, y: 0, width: 5, height: 50), cornerSize: CGSize(width: 3, height: 3))
//                .fill(style: classInstance.color))
                .frame(width: 5, height: 50)
            VStack(alignment: .leading) {
                Text(classInstance.startsAt, style: .time)
                Text("\(classInstance.durationMinutes) mins").foregroundStyle(.secondary)
            }
            VStack(alignment: .leading) {
                Text(classInstance.name).bold()
                Text(classInstance.instructor.name).foregroundStyle(.secondary)
            }
            Spacer()
            Button("Save Class", systemImage: "plus") {}
                .labelStyle(.iconOnly)
        }
    }
}

#Preview {
    ClassRow(classInstance: .mock())
}
