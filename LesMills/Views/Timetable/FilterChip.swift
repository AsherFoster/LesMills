import SwiftUI


struct FilterChip<Content: View>: View {
    public var label: String
    public var active: Bool
    public var selectValue: () -> Content
    
    @State private var filterOpen = false
    
    @ViewBuilder
    var body: some View {
        if active {
            base
                .buttonStyle(.borderedProminent)
        } else {
            base
                .buttonStyle(.bordered)
        }
    }
    
    var base: some View {
        Button {
            filterOpen.toggle()
        } label: {
            HStack {
                Text(label)
                Image(systemName: "chevron.down")
            }
        }
        .controlSize(.small)
        .sheet(isPresented: $filterOpen) {
            selectValue()
                .presentationDragIndicator(.visible)
                .presentationDetents([.fraction(0.8)])
        }
    }
}


#Preview {
    FilterChip(
        label: "Clubs",
        active: true
    ) {
        Text("Hello!")
    }
}
