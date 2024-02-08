// This file is a crime. Sorry.

import SwiftUI
import SafariServices

struct SafariWebView: UIViewControllerRepresentable {
    let url: URL
    
    func makeUIViewController(context: Context) -> SFSafariViewController {
        return SFSafariViewController(url: url)
    }
    
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {}
}

struct ListItemCell: ButtonStyle {
    let title: String

    func makeBody(configuration: Configuration) -> some View {
        HStack(alignment: .center) {
            Text(title)

            Spacer()

            Image(systemName: "chevron.right")
                .font(.body.weight(.medium))
                .imageScale(.small)
                .foregroundStyle(Color(.tertiaryLabel))
        }
        .animation(.easeOut.delay(0.2), value: configuration.isPressed)
        .background {
            Rectangle()
                .foregroundColor(configuration.isPressed ? Color(.systemGray4) : .clear)
                .padding(EdgeInsets(top: -12, leading: -20, bottom: -12, trailing: -20))
                .contentShape(Rectangle())
        }
    }
}


struct AccountLinkView: View {
    var label: String
    var url: URL
    
    @State private var isVisible = false
    
    var body: some View {
        Button(label, action: {
            self.isVisible = true
        })
        .buttonStyle(ListItemCell(title: label))
        .sheet(isPresented: $isVisible) {
            SafariWebView(url:url)
                .ignoresSafeArea()
        }
    }
}

#Preview {
    List {
        AccountLinkView(label: "Test", url: URL(string: "https://google.com")!)
    }
}
