//
//  MultiSelectList.swift
//  LesMills
//
//  Created by Asher Foster on 12/12/23.
//

import SwiftUI

struct MultiSelectList<Item: Identifiable & Hashable, Content: View>: View {
    public var options: [Item]
    @Binding public var selection: Set<Item>
    public var content: (_ item: Item) -> Content
    
    var body: some View {
        List(options) { item in
            Button {
                if selection.contains(item) {
                    selection.remove(item)
                } else {
                    selection.insert(item)
                }
            } label: {
                HStack {
                    content(item)
                    Spacer()
                    if selection.contains(item) {
                        Image(systemName: "checkmark")
                    }
                }
            }
        }
    }
}

#Preview {
    Text("idk")
//    MultiSelectList(
////        options: ["Foo", "Bar"].map { IdentifiableString(id: $0) },
//        selection: Binding.constant([IdentifiableString(id: "Foo")])
//    ) { item in
//        Text(item.id)
//    }
}
