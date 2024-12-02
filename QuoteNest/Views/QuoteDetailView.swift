//
//  QuoteDetailView.swift
//  QuoteNest
//
//  Created by Hunter Scheppat on 12/1/24.
//

import SwiftUI

struct QuoteDetailView: View {
    let quote: Quote
    @State private var notes: String = ""
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack(spacing: 20) {
            // Quote Text
            Text("\"\(quote.text)\"")
                .font(.title)
                .italic()
                .multilineTextAlignment(.center)
                .padding()
                .foregroundColor(.white)
            
            // Author
            Text("- \(quote.author)")
                .font(.title3)
                .foregroundColor(.gray)
                .padding(.bottom)

            // Notes Section
            VStack(alignment: .leading, spacing: 10) {
                Text("Notes")
                    .font(.headline)
                
                TextEditor(text: $notes)
                    .frame(height: 150)
                    .padding()
                    .background(Color.lightRed.opacity(0.2))
                    .cornerRadius(8)
            }
            .padding(.horizontal)

            Spacer()

            // Save Button
            Button(action: {
                saveNotes()
            }) {
                Text("Save Notes")
                    .fontWeight(.bold)
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
            loadNotes()
        }
        .background(Color.black.ignoresSafeArea()) // Apply black background to entire screen
    }


    // Load notes for the quote if they exist
    private func loadNotes() {
        // Retrieve stored notes for this quote, if applicable
        let savedNotes = UserDefaults.standard.string(forKey: "notes_\(quote.id)") ?? ""
        notes = savedNotes
    }

    // Save notes to local storage
    private func saveNotes() {
        UserDefaults.standard.set(notes, forKey: "notes_\(quote.id)")
        presentationMode.wrappedValue.dismiss()
    }
}

#Preview {
    QuoteDetailView(quote: Quote(id: 1, text: "Kindness is the golden chain by which society is bound together.", author: "Johann Wolfgang von Goethe", tags: nil))
}

