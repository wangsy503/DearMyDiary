//
//  ContentView.swift
//  DiaryBottle
//
//  Created by Shuyue on 2/16/24.
//

import SwiftUI

//struct ContentView: View {
//    var body: some View {
//        VStack {
//            Image(systemName: "globe")
//                .imageScale(.large)
//                .foregroundStyle(.tint)
//            Text("Hello, world!")
//        }
//        .padding()
//    }
//}

struct Note: Identifiable {
    var id: UUID = UUID()
    var content: String
    var summarizedContent: String?  // GPT-4 summary
    var isGPTSummarized: Bool = false  // Differentiate original vs GPT-summarized notes
    var isRead: Bool = false  // Track read status
    var position: CGPoint
    var size: CGSize = CGSize(width: 40, height: 40)
}

struct BottleArea {
    static let minX: CGFloat = 80.0
    static let maxX: CGFloat = 300.0
    static let minY: CGFloat = 350.0
    static let maxY: CGFloat = 530.0
}


struct NoteCreatorView: View {
    @Binding var notes: [Note]
    @State private var noteContent = ""
    @Environment(\.dismiss) var dismiss
    @State private var fontSize: CGFloat = 14
    
    func doesOverlapWithExistingNotes(x: CGFloat, y: CGFloat) -> Bool {
            for note in notes {
                if abs(x - note.position.x) < (note.size.width / 2 + note.size.width / 2) &&
                    abs(y - note.position.y) < (note.size.width / 2 + note.size.height / 2) {
                    return true
                }
            }
            return false
    }
    
    func generateRandomPosition() -> CGPoint {
        let maxAttempts = 100
        var attempt = 0
        var positionFound = false
        
        while !positionFound && attempt < maxAttempts {
            attempt += 1
            let x = CGFloat.random(in: BottleArea.minX...BottleArea.maxX)
            let y = CGFloat.random(in: BottleArea.minY...BottleArea.maxY)
            if !doesOverlapWithExistingNotes(x:x, y:y) {
                positionFound = true
                return CGPoint(x: x, y: y)
            }
        }
        return CGPoint.zero
    }
    
    func addNoteAndFetchSummary(content: String) {
        // Step 1: Add the original note immediately to your app's notes array
        let originalNote = Note(content: content, isGPTSummarized: false, position: generateRandomPosition())
        self.notes.append(originalNote)
        
        // Step 2: Call your backend to get the GPT-4 summarized content
        NetworkService.summarizeNote(content: content) { summarizedContent in
            DispatchQueue.main.async {
                guard let summary = summarizedContent else {
                    print("Failed to fetch summary")
                    return
                }
                
                // Step 3: Add the summarized note as a new note item
                let summarizedNote = Note(content: summary,isGPTSummarized: true, position: generateRandomPosition() )
                self.notes.append(summarizedNote)
            }
        }
    }

    
    var body: some View {
        VStack {
            TextEditor(text: $noteContent)
                                .font(.system(size: fontSize)) // Adjust the font size here
                                .padding()
                                .border(Color.gray, width: 1) // Optional border for visual structure
                                .frame(height: 300) // Set the desired height for the TextEditor
            // Controls for adjusting font size
                        HStack {
                            Text("Font size:")
                            Slider(value: $fontSize, in: 12...24, step: 1)
                                .onChange(of: fontSize) { newValue in
                                    // You can react to font size changes here if needed
                                }
                        }.padding()
            
            Button("Add Note") {
                addNoteAndFetchSummary(content:noteContent)
                            dismiss()
                        }
            .padding()
            .background(Color.yellow)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .padding()
        .navigationTitle("Create Note")
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Cancel") {
                    dismiss()
                }
            }
        }
        
    }
}

struct HomePageView: View {
    @State private var notes: [Note] = []
    @State private var showingNoteCreator = false
    @State private var selectedNote: Note?
    
    var body: some View {
        ZStack {
            // Background image of the bottle
            Image("jar-of-jam-icon")
                .resizable()
                .aspectRatio(contentMode: .fit)
            
            // Origamis representation
            
            ForEach(notes) { note in
                Text(note.isGPTSummarized ? "✨" : "📃") // Different symbols for original vs summarized
                    .foregroundColor(note.isGPTSummarized ? .blue : .black) // Different colors
                    .font(.largeTitle)
                    .scaleEffect(note.isRead ? 1.0 : 1.5) // Simple "shining" effect for unread notes
                    .animation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true), value: note.isRead)
                    .onAppear {
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                            if let index = self.notes.firstIndex(where: { $0.id == note.id }) {
//                                self.notes[index].isRead = true // Mark as read to stop animation
//                            }
//                        }
                    }
                    .frame(width: note.size.width, height: note.size.height)
                    .position(x: note.position.x, y: note.position.y)
                    .onTapGesture {
                        self.selectedNote = note
                    }.onTapGesture {
                        if let index = self.notes.firstIndex(where: { $0.id == note.id }) {
                            self.notes[index].isRead = true // Mark the note as read
                            // Code to display the note's content
                        }
                    }
            }
            
            
            // Create button
            VStack {
                Spacer()
                Button(action: {
                    showingNoteCreator.toggle()
                }) {
                    Text("Create")
                        .padding()
                        .background(Color.yellow)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
                .sheet(isPresented: $showingNoteCreator) {
                    // Note creation view
                    NoteCreatorView(notes: $notes)
                }
            }
        }.sheet(item: $selectedNote) { note in
            NoteDetailView(note: note)
        }

    }
}


struct NoteDetailView: View {
    var note: Note;
    
    var body: some View {
        VStack(alignment: .leading) {
            Spacer() // Pushes the content to the middle
            Text(note.content)
                .padding()
                .foregroundColor(.black) // Sets the text color to black for contrast
            Spacer() // Pushes the content to the middle
        }
        
        .background(Color.yellow.opacity(0.3)) // Sets a light yellow background
        
    }
}

#Preview {
    HomePageView()
}
