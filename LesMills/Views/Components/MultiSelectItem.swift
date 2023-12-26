//
//  MultiSelectItem.swift
//  LesMills
//
//  Created by Asher Foster on 26/12/23.
//

import SwiftUI

struct MultiSelectItem<Option: Hashable, Content: View>: View {
    public var option: Option
    @Binding public var selection: Set<Option>
    public var content: () -> Content
    
    var body: some View {
        Button {
            if selection.contains(option) {
                selection.remove(option)
            } else {
                selection.insert(option)
            }
        } label: {
            HStack {
                content()
                Spacer()
                if selection.contains(option) {
                    Image(systemName: "checkmark")
                }
            }
        }
    }
}

#Preview {
    MultiSelectItem(option: "Foo", selection: Binding.constant(Set(["Foo"]))) {
        Text("Foo!")
    }
}
