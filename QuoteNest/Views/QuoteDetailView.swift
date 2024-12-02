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

    init(quote: Quote) {
        _viewModel = StateObject(wrappedValue: QuoteDetailViewModel(quote: quote))
    }

    var body: some View {
        VStack(spacing: 20) {
            // Quote Text
            // TODO: quote is inaccessible due to private protection level
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
        .onAppear {
            viewModel.fetchNotes()
        }
        .background(Color.black.ignoresSafeArea()) // Apply black background to entire screen
        .sheet(isPresented: $isShareSheetPresented) {
            ActivityView(activityItems: ["\"\(viewModel.quote.text)\" - \(viewModel.quote.author)"])
        }
        //Instance method 'alert(item:content:)' requires that 'String' conform to 'Identifiable'
        .alert(item: $viewModel.errorMessage) { errorMessage in
            Alert(
                title: Text("Error"),
                message: Text(errorMessage.message),
                dismissButton: .default(Text("OK"))
            )
        }
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
