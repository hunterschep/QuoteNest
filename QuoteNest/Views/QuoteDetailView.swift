/*
 
     @file: QuoteDetailView.swift
     @project: QuoteNest | Fall 2024 Swift Final Project
     @author: Hunter Scheppat
     @date: December 2nd, 2024
     
     @description: View for displaying a single quote and associated notes with a share button
 
 */

import SwiftUI

struct QuoteDetailView: View {
    @StateObject private var viewModel: QuoteDetailViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var isShareSheetPresented = false
    @State private var showLoadingScreen = true // Controls the initial loading view
    @FocusState private var isTextEditorFocused: Bool // Tracks focus of the TextEditor

    init(quote: Quote) {
        _viewModel = StateObject(wrappedValue: QuoteDetailViewModel(quote: quote))
    }

    var body: some View {
        ZStack {
            if showLoadingScreen {
                // Loading Screen
                Color.black
                    .ignoresSafeArea()
                    .overlay(
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: Color("lightRed")))
                            .scaleEffect(2) // Make the spinner larger
                    )
            } else {
                // Main Content
                VStack(spacing: 20) {
                    // Quote Text
                    Text("\"\(viewModel.quote.text)\"")
                        .font(.title)
                        .italic()
                        .multilineTextAlignment(.center)
                        .padding()
                        .foregroundColor(.white)

                    // Author
                    Text("- \(viewModel.quote.author)")
                        .font(.title3)
                        .bold()
                        .foregroundColor(.gray)
                        .padding(.bottom)

                    // Notes Section
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Personal Notes")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)

                        ZStack {
                            if viewModel.notes.isEmpty {
                                Text("No notes yet!")
                                    .font(.title3)
                                    .foregroundColor(.gray)
                            }

                            TextEditor(text: $viewModel.notes)
                                .frame(height: 150)
                                .padding()
                                .background(Color.gray.opacity(0.2))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color("lightRed"), lineWidth: 4)
                                )
                                .cornerRadius(12)
                                .foregroundColor(.white)
                                .scrollContentBackground(.hidden)
                                .focused($isTextEditorFocused) // Attach the focus state
                        }
                    }
                    .padding(.horizontal)

                    Spacer()

                    // Save Notes Button
                    Button(action: {
                        viewModel.saveNotes()
                    }) {
                        if viewModel.isSaving {
                            ProgressView()
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color("lightRed"))
                                .cornerRadius(10)
                                .foregroundColor(.white)
                        } else {
                            Text("Save Notes")
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color("lightRed"))
                                .cornerRadius(10)
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.horizontal)

                    // Share Quote Button
                    Button(action: {
                        isShareSheetPresented = true
                    }) {
                        HStack {
                            Image(systemName: "square.and.arrow.up")
                            Text("Share Quote")
                                .fontWeight(.bold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color("lightRed"))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    .padding(.horizontal)
                }
                .padding()
                .navigationTitle("Quote Details")
                .navigationBarTitleDisplayMode(.inline)
                .background(
                    Color.black
                        .ignoresSafeArea()
                        .onTapGesture {
                            // Dismiss the keyboard when tapping outside
                            isTextEditorFocused = false
                        }
                )
                .sheet(isPresented: $isShareSheetPresented) {
                    ActivityView(activityItems: ["\"\(viewModel.quote.text)\" - \(viewModel.quote.author)"])
                }
                .alert(item: $viewModel.errorMessage) { errorMessage in
                    Alert(
                        title: Text("Error"),
                        message: Text(errorMessage.message),
                        dismissButton: .default(Text("OK"))
                    )
                }
            }
        }
        .onAppear {
            viewModel.fetchNotes()

            // Dismiss loading screen after 1 second
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.50) {
                showLoadingScreen = false
            }
        }
        .tint(Color("lightRed")) // Explicitly set back button tint
    }
}
// ActivityView to present the iOS Share Sheet
struct ActivityView: UIViewControllerRepresentable {
    let activityItems: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

#Preview {
    QuoteDetailView(quote: Quote(id: 1, text: "What is the most beautiful thing in the world?", author: "Yoda", tags: ["Test"], notes: "hmmmm"))
}

