//
//  MultiSelectList.swift
//  LesMills
//
//  Created by Asher Foster on 12/12/23.
//

import SwiftUI


struct MultiSelectList<Option: Identifiable & Hashable, Content: View>: View {
    public var options: [Option]
    @Binding public var selection: Set<Option>
    public var content: (_ option: Option) -> Content
    
    var body: some View {
        List(options) { option in
            MultiSelectItem(
                option: option,
                selection: $selection,
                content: { content(option) }
            )
        }
    }
}

struct IdentifiableString: Hashable, Codable, Identifiable {
    var id: String
}

#Preview {
    MultiSelectList(
        options: ["Foo", "Bar"].map { IdentifiableString(id: $0) },
        selection: Binding.constant([IdentifiableString(id: "Foo")])
    ) { item in
        Text(item.id)
    }
}
