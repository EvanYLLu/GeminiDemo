//
//  ContentView.swift
//  GeminiDemo
//
//  Created by Evan Lu on 2024/8/12.
//

import SwiftUI
import GoogleGenerativeAI


struct ContentView: View {
    
    
    
    @State private var textInput = ""
    @State private var response: LocalizedStringKey = "Hello! How can I help you today?"

    @State private var isThinking = false

    let model = GenerativeModel(name: "gemini-pro", apiKey: APIKey.default)
    
    
    
    func sendMessage() {
        response = "Thinking..."
        
        withAnimation(.easeInOut(duration: 0.6).repeatForever(autoreverses: true)) {
            isThinking.toggle()
        }
        
        Task {
            do {
                let generatedResponse = try await model.generateContent(textInput)
                
                guard let text = generatedResponse.text else  {
                    textInput = "Sorry, Gemini got some problems.\nPlease try again later."
                    return
                }
                
                textInput = ""
                response = LocalizedStringKey(text)
                
                isThinking.toggle()
            } catch {
                response = "Something went wrong!\n\(error.localizedDescription)"
            }
        }
    }

    
    
    var body: some View {
        VStack(alignment: .leading) {
            
            ScrollView {
                VStack {
                    Text(response)
                        .font(.system(.title, design: .rounded, weight: .medium))
                        .opacity(isThinking ? 0.2 : 1.0)
                }
            }
            .contentMargins(.horizontal, 15, for: .scrollContent)
            
            Spacer()
            
            HStack {
                
                TextField("Type your message here", text: $textInput)
                    .textFieldStyle(.plain)
                    .padding()
                    .background(Color(.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .onSubmit {
                        sendMessage()
                    }
                
            }
            .padding(.horizontal)
        }
    }
}


#Preview {
    ContentView()
}
