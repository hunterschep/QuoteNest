/*
 
 @file: HomeView.swift
 @project: QuoteNest | Fall 2024 Swift Final Project
 @author: Hunter Scheppat
 @date: December 2nd, 2024
 
 @description: main view shown after login
 * shows quote fetching properties
 * render's the fetched quote
 
 */
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
    // Quote display section struct
    struct QuoteDisplaySection: View {
        let quote: Quote?
        let saveAction: () -> Void
        
        var body: some View {
            VStack(spacing: 10) {
                ScrollView {
                    if let quote = quote {
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
                
                Group {
                    if let quote = quote {
                        VStack {
                            Text("- \(quote.author)")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            
                            Button(action: saveAction) {
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
                    } else {
                        VStack {
                            Text("-")
                                .font(.subheadline)
                                .foregroundColor(.clear)
                            
                            Button(action: {}) {
                                Text("") // Add an empty Text as the label
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.clear)
                            .cornerRadius(10)
                            .padding(.horizontal)
                            .hidden() // Ensures the button is invisible and non-interactive
                        }
                    }
                }
                .animation(.default, value: quote)
            }
            .background(Color.black.opacity(0.8))
            .cornerRadius(12)
            .padding(.horizontal)
        }
    }
    
    // Quote fetch section struct
    struct QuoteFetchSection: View {
        @Binding var maxLength: Double
        @Binding var selectedTags: Set<String>
        @Binding var author: String
        let tagOptions: [String]
        let fetchAction: () -> Void
        let clearAction: () -> Void
        
        var body: some View {
            VStack(spacing: 20) {
                Text("Fetch a Quote")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .multilineTextAlignment(.center)
                
                HStack(spacing: 20) {
                    TagsPicker(selectedTags: $selectedTags, tagOptions: tagOptions)
                    MaxLengthSlider(maxLength: $maxLength)
                }
                
                AuthorInput(author: $author)
                
                HStack {
                    Button(action: fetchAction) {
                        Text("Get Quote")
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color("lightRed"))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    
                    Button(action: clearAction) {
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
        }
    }
    
    // Author input struct
    struct AuthorInput: View {
        @Binding var author: String
        
        var body: some View {
            ZStack(alignment: .leading) {
                if author.isEmpty {
                    Text("Author Name")
                        .foregroundColor(.white)
                        .padding(.leading, 16)
                }
                TextField("Author Name", text: $author)
                    .padding()
                    .background(Color("lightRed").opacity(0.2))
                    .cornerRadius(8)
                    .foregroundColor(.white)
            }
        }
    }
    
    // Max length slider struct
    struct MaxLengthSlider: View {
        @Binding var maxLength: Double
        
        var body: some View {
            VStack(alignment: .leading, spacing: 10) {
                Text("Max Length")
                    .font(.title2)
                    .foregroundColor(.white)
                    .padding(.bottom, 20)
                
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
    }
    
    
    // Tags picker struct
    
    struct TagsPicker: View {
        @Binding var selectedTags: Set<String>
        let tagOptions: [String]
        
        var body: some View {
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
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Push content to the top
                Spacer(minLength: 0)
                
                // Quote Fetch Section
                QuoteFetchSection(
                    maxLength: $maxLength,
                    selectedTags: $selectedTags,
                    author: $author,
                    tagOptions: tagOptions,
                    fetchAction: {
                        viewModel.fetchRandomQuote(maxLength: Int(maxLength), tags: selectedTags.joined(separator: ","), author: author)
                    },
                    clearAction: {
                        selectedTags.removeAll()
                        author = ""
                        maxLength = 100
                        viewModel.randomQuote = nil
                    }
                )
                
                // Display Random Quote or Placeholder
                QuoteDisplaySection(
                    quote: viewModel.randomQuote,
                    saveAction: {
                        if let quote = viewModel.randomQuote {
                            viewModel.saveQuote(quote)
                            selectedTags.removeAll()
                            author = ""
                            maxLength = 100
                            viewModel.randomQuote = nil
                        }
                    }
                )
                
                // My Quote Library Button
                NavigationLink {
                    SavedQuotesView()
                } label: {
                    Label("Your Quote Nest", systemImage: "book")
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
                if ProcessInfo.processInfo.environment["XCODE_RUNNING_PREVIEWS"] == "1" {
                    // Running in Xcode canvas previews, use mock data
                    viewModel.savedQuotes = Quote.mockSavedQuotes
                    print("Using mock saved quotes for preview.")
                } else {
                    // Not in previews, fetch real saved quotes
                    viewModel.fetchSavedQuotes()
                }
            }
            .alert(item: $viewModel.errorMessage) { errorMessage in
                Alert(
                    title: Text("Error"),
                    message: Text(errorMessage.message),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
        .tint(Color("lightRed"))
        .navigationViewStyle(StackNavigationViewStyle()) // Ensures proper rendering in all layouts
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
}


#Preview {
    HomeView()
}
