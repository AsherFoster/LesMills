import SwiftUI


public enum InputState: Equatable, Hashable {
    case `default`
    case error(String? = nil)
    case disabled
}

public struct LesMillsTextFieldStyle: TextFieldStyle {
    var state: InputState

    @FocusState var isFocused: Bool

    public init(_ state: InputState = .default) {
        self.state = state
    }

    public func _body(configuration: TextField<_Label>) -> some View {
        HStack {
            configuration
                .focused($isFocused)
                .disabled(state == .disabled)
                .foregroundColor(.primary)
//                .accentColor(palette.cursor)
//                .foregroundColor(.body)
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 6)
                .foregroundColor(.secondary)
                .background(.clear)
        )
//        .overlay(
//            RoundedRectangle(cornerRadius: 6)
//                .inset(by: 0.5)
//                .stroke(lineWidth: 1.0)
//                .foregroundColor(.black)
//                .background(.clear)
//        )
    }
}

