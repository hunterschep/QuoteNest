import SwiftUI

struct HomeView: View {
    // ViewModel to interact with backend
    @StateObject private var viewModel = HomeViewModel()
    @State private var maxLength: Double = 100
    @State private var selectedTags: Set<String> = [] // Allow multiple selections
    @State private var author: String = ""
    @State private var showSavedQuotesView = false

    
    // Predefined list of tags
    private let tagOptions: [String] = [
        "motivation", "inspiration", "life", "wisdom", "love", "success", "leadership",
        "happiness", "change", "perseverance", "mindfulness", "growth", "courage",
        "gratitude", "resilience", "friendship", "creativity", "humility", "forgiveness",
        "patience", "integrity", "self-reflection", "empathy", "purpose", "justice",
        "harmony", "knowledge", "hope", "anger", "fear", "general"
    ]

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Push content to the top
                Spacer(minLength: 0)

                // Quote Fetch Section
                VStack(spacing: 20) {
                    // Center aligned title
                    Text("Fetch a Quote")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .multilineTextAlignment(.center)

                    // Tags Picker and Max Length Slider
                    HStack(spacing: 20) {
                        // Tags Dropdown
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Tags")
                                .font(.title2)
                                .foregroundColor(.white)

                            Menu {
                                ForEach(tagOptions, id: \.self) { tag in
                                    Button(action: {
                                        if selectedTags.contains(tag) {
                                            selectedTags.remove(tag)
                                        } else {
                                            selectedTags.insert(tag)
                                        }
                                    }) {
                                        HStack {
                                            Text(tag.capitalized)
                                            Spacer()
                                            if selectedTags.contains(tag) {
                                                Image(systemName: "checkmark")
                                            }
                                        }
                                    }
                                }
                            } label: {
                                Text(selectedTags.isEmpty ? "Select Tags" : selectedTags.joined(separator: ", "))
                                    .padding()
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(Color("lightRed").opacity(0.2))
                                    .cornerRadius(8)
                                    .foregroundColor(.white)
                            }
                        }
                        .frame(maxWidth: .infinity)

                        // Max Length Slider
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Max Length")
                                .font(.title2)
                                .foregroundColor(.white)

                            HStack {
                                Slider(value: $maxLength, in: 50...300, step: 1)
                                    .accentColor(Color("lightRed"))
                                Text("\(Int(maxLength))")
                                    .foregroundColor(.white)
                                    .frame(width: 40, alignment: .leading)
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }

                    // Author Name Input
                    ZStack(alignment: .leading) {
                        if author.isEmpty {
                            Text("  Author Name")
                                .foregroundColor(.white) // Light white color
                                .padding(.leading, 8)
                        }
                        TextField("Author Name", text: $author)
                            .padding()
                            .background(Color("lightRed").opacity(0.2))
                            .cornerRadius(8)
                            .foregroundColor(.white)
                    }

                    // Buttons
                    HStack {
                        Button(action: {
                            viewModel.fetchRandomQuote(maxLength: Int(maxLength), tags: selectedTags.joined(separator: ","), author: author)
                        }) {
                            Text("Get Quote")
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color("lightRed"))
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }

                        Button(action: {
                            selectedTags.removeAll()
                            author = ""
                            maxLength = 100
                            viewModel.randomQuote = nil
                        }) {
                            Text("Clear")
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.gray.opacity(0.8))
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }
                }
                .padding()
                .background(Color.black.opacity(0.8))
                .cornerRadius(12)
                .padding(.horizontal)

                // Display Random Quote or Placeholder
                VStack(spacing: 10) {
                    ScrollView {
                        if let quote = viewModel.randomQuote {
                            Text("\"\(quote.text)\"")
                                .font(.title2)
                                .italic()
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                                .padding()
                        } else {
                            Text("Your quote will appear here!")
                                .font(.title3)
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                                .padding()
                        }
                    }
                    .frame(height: 175)
                    .frame(maxWidth: .infinity)
                    .background(Color.black)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color("lightRed"), lineWidth: 4)
                    )
                    .cornerRadius(12)
                    
                    Spacer()

                    if let quote = viewModel.randomQuote {
                        Text("- \(quote.author)")
                            .font(.subheadline)
                            .foregroundColor(.gray)

                        Button(action: {
                            viewModel.saveQuote(quote)
                        }) {
                            Text("Save Quote")
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color("lightRed"))
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .padding(.horizontal)
                        }
                    }
                }
                .background(Color.black.opacity(0.8))
                .cornerRadius(12)
                .padding(.horizontal)
                                
                // My Quote Library Button
                // My Quote Library Button
                NavigationLink(
                    destination: SavedQuotesView()
                        .onDisappear {
                        },
                    isActive: $showSavedQuotesView
                ) {
                    Text("My Quote Library")
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(viewModel.savedQuotes.isEmpty ? Color.gray : Color("lightRed"))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                .disabled(viewModel.savedQuotes.isEmpty)
                .padding(.horizontal)

                // Push content to the bottom
                Spacer(minLength: 0)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity) // Ensure VStack fills the screen
            .background(Color.black.ignoresSafeArea()) // Apply black background to entire screen
            .onAppear {
                viewModel.fetchSavedQuotes()
            }
            .alert(item: $viewModel.errorMessage) { errorMessage in
                Alert(
                    title: Text("Error"),
                    message: Text(errorMessage.message),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
        .navigationViewStyle(StackNavigationViewStyle()) // Ensures proper rendering in all layouts
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)


    }
}

#Preview {
    HomeView()
}
