import SwiftUI

struct BookingContextMenu<Content: View>: View {
    var session: ClassSession
    var content: () -> Content
    @StateObject private var bookingModel: ClassBookingModel
    
    init(session: ClassSession, rootModel: RootViewModel, _ content: @escaping () -> Content) {
        self.session = session
        self.content = content
        
        _bookingModel = StateObject(wrappedValue: ClassBookingModel(session: session, rootModel: rootModel))
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
    @EnvironmentObject private var rootModel: RootViewModel
    private var profile: UserProfile { rootModel.profile! }
    private var session: ClassSession? { rootModel.bookedSessions.first }
    
    @State private var isBarcodeOpen = false
    
    var body: some View {
        if let session = session {
            BookingContextMenu(session: session, rootModel: rootModel) {
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
                Text(session.name)
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
                .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    VStack {
        NextClassSnackbar()
            .environmentObject(RootViewModel.mock())
        NextClassSnackbar()
            .environmentObject(RootViewModel.mock(hasBookedSessions: false))
    }
        .padding()
        .background(.secondary)
}
