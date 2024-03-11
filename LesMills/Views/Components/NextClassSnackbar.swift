import SwiftUI

struct BookingContextMenu<Content: View>: View {
    var session: ClassSession
    var content: () -> Content
    @StateObject private var bookingModel: ClassBookingModel
    
    init(session: ClassSession, _ content: @escaping () -> Content) {
        self.session = session
        self.content = content
        
        _bookingModel = StateObject(wrappedValue: ClassBookingModel(session: session))
    }
    
    var body: some View {
        content()
            .contextMenu {
                ShareLink(item: session.shareText)
                Button("Remove booking", systemImage: "trash", role: .destructive) {
                    Task {
                        await bookingModel.removeBooking()
                    }
                }
            }
    }
}

struct NextClassSnackbar: View {
    public var session: ClassSession?
    public var profile: UserProfile
    
    @State private var isBarcodeOpen = false
    
    var body: some View {
        if let session = self.session {
            BookingContextMenu(session: session) {
                content
            }
        } else {
            content
        }
    }
    
    private var content: some View {
        HStack(spacing: .zero) {
            Image(systemName: "calendar")
                .foregroundStyle(.accent)
            
            classDescription
                .padding(.horizontal)
            
            Spacer()
            
            Button("Scan in") {
                isBarcodeOpen.toggle()
            }
            .sheet(isPresented: $isBarcodeOpen) {
                BarcodeSheet(profile: profile)
            }
        }
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 6)
                    .fill(.background)
            }
    }
    
    @ViewBuilder
    private var classDescription: some View {
        if let session = self.session {
            VStack(alignment: .leading) {
                Text(session.classType.name)
                    .font(.headline)
                HStack {
                    Text(session.startsAt, formatter: CommonDateFormats.time)
                    Text("•")
                    Text(session.location)
                }
                    .font(.subheadline)
            }
        } else {
            Text("Nothing booked")
                .font(.headline)
                .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    VStack {
        NextClassSnackbar(session: .mock(), profile: .mock())
        NextClassSnackbar(session: nil, profile: .mock())
    }
        .padding()
        .background(.secondary)
}
