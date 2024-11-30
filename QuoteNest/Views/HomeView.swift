//
//  HomeView.swift
//  QuoteNest
//
//  Created by Hunter Scheppat on 11/19/24.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @State private var maxLength: Double = 100
    @State private var tags: String = ""
    @State private var author: String = ""

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                VStack {
                    Text("Fetch a Random Quote")
                        .font(.headline)

                    Slider(value: $maxLength, in: 50...300, step: 1) {
                        Text("Max Length")
                    }
                    Text("Max Length: \(Int(maxLength))")

                    TextField("Tags (comma-separated)", text: $tags)
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                    TextField("Author Name", text: $author)
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                    Button("Get Quote") {
                        viewModel.fetchRandomQuote(maxLength: Int(maxLength), tags: tags, author: author)
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .padding()

                if let quote = viewModel.randomQuote {
                    VStack {
                        Text("\"\(quote.text)\"")
                            .font(.title)
                            .italic()
                            .padding()

                        Text("- \(quote.author)")
                            .font(.subheadline)
                            .foregroundColor(.gray)

                        Button("Save Quote") {
                            viewModel.saveQuote(quote)
                        }
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                }

                Text("Your Saved Quotes")
                    .font(.headline)

                List(viewModel.savedQuotes) { quote in
                    VStack(alignment: .leading) {
                        Text("\"\(quote.text)\"")
                            .font(.body)
                            .italic()
                        Text("- \(quote.author)")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding()
            .onAppear {
                viewModel.fetchSavedQuotes()
            }
            .alert(item: $viewModel.errorMessage) { errorMessage in
                Alert(title: Text("Error"), message: Text(errorMessage.message), dismissButton: .default(Text("OK")))
            }
        }
    }
}

#Preview {
    HomeView()
}

