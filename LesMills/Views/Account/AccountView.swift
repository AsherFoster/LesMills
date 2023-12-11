//
//  AccountView.swift
//  LesMills
//
//  Created by Asher Foster on 30/09/23.
//

import SwiftUI
import SafariServices

struct AccountProfileView: View {
    var name: String
    
    var body: some View {
        HStack(spacing: 12) {
            Text(profileEmoji)
                .font(.largeTitle)
                .padding(8)
                .background(
                    Circle()
                        .foregroundStyle(.orange)
                        .opacity(0.3)
                )
            VStack(alignment: .leading) {
                Text(name)
                    .font(.title2)
                Text("Update Details")
                    .font(.subheadline)
            }
        }
    }
    
    var profileEmoji: String {
        let names: [String] = ["🤠", "🫠", "😤", "🥸", "🤔", "🫣", "🤩", "🤯", "🥳", "🥺", "👽", "🤖"]
        
        // Implement a FNV1a PRNG algorithm suggested by ChatGPT
        var result: UInt64 = 14695981039346656037
        for byte in Array(name.utf8) {
            result ^= UInt64(byte)
            result &*= 1099511628211
        }

        return names[abs(Int(truncatingIfNeeded: result)) % names.count]
    }
}


struct AccountView: View {
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    Section {
                        NavigationLink {
                            NotImplementedView()  // TODO implement
                        } label: {
                            AccountProfileView(name: "Asher")
                        }
                    }
                    Section(header: Text("Notifications")) {
                        Toggle(isOn: .constant(false)) {
                            Text("Push Notifications")
                        }
                        Toggle(isOn: .constant(false)) {
                            Text("Class Reminders")
                        }
                        Toggle(isOn: .constant(false)) {
                            Text("Save Classes to Calendar")
                        }
                        Toggle(isOn: .constant(false)) {
                            Text("Send Me News & Updates")
                        }
                        Toggle(isOn: .constant(false)) {
                            Text("Quick Beacon Barcode")
                        }
                    }
                    .disabled(true)  // TODO implement
                    Section(header: Text("About Les Mills")) {
                        AccountLinkView(
                            label: "Contact Us",
                            url: URL(string: "https://www.lesmills.co.nz/contact")!
                        )
                        AccountLinkView(
                            label: "Personal Training",
                            url: URL(string: "https://www.lesmills.co.nz/trainers/")!
                        )
                        
                        NavigationLink {
                            NotImplementedView()  // TODO implement
                        } label: {
                            Text("Clubs")
                        }
                        AccountLinkView(
                            label: "Club News",
                            url: URL(string: "https://www.lesmills.co.nz/journal/club-news")!
                        )
                        AccountLinkView(
                            label: "Les Mills Music",
                            url: URL(string: "https://open.spotify.com/user/lesmillsnewzealand")!
                        )
                        AccountLinkView(
                            label: "Group Fitness",
                            url: URL(string: "https://www.lesmills.co.nz/group-fitness")!
                        )
                    }
                    Section(header: Text("About")) {
                        NavigationLink {
                            NotImplementedView()  // TODO implement
                        } label: {
                            Text("Terms of Use")
                        }
                        NavigationLink {
                            NotImplementedView()  // TODO implement
                        } label: {
                            Text("Open Source Licenses")
                        }
                        HStack {
                            Text("App Version")
                            Spacer()
                            Text("0.0.0")
                        }
                    }
                    
                    Section {
                        Button("Sign out", role: .destructive) {}  // TODO implement
                    }
                    
                    Section {
                        Link("Made with Spite by Asher", destination: URL(string: "https://asherfoster.com")!)
                    }
                }
            }
            .navigationTitle("Account")
        }
        
    }
}

#Preview {
    AccountView()
}
