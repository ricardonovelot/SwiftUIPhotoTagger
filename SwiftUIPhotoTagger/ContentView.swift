//
//  ContentView.swift
//  SwiftUIPhotoTagger
//
//  Created by Ricardo on 20/08/24.
//

import SwiftUI

struct ContentView: View {
    @State var showSheet = false
    @State private var newTagLocation: CGPoint = .zero
    @State private var tags: [Tag] = []
    
    var body: some View {
        NavigationStack{
            VStack {
                ZStack {
                    Image("test")
                        .resizable()
                        .scaledToFit()
                        .onTapGesture { location in
                            newTagLocation = location
                            showSheet = true
                            print("Tapped at \(newTagLocation)")
                        }
                        .overlay {
                            ForEach(tags) { tag in
                                TagView(tag: tag)
                            }
                        }
                }
            }
            .padding()
        }
        
        .sheet(isPresented: $showSheet) {
                SearchView(tags: $tags, newTagLocation: $newTagLocation)
            
        }
    }
}

struct TagView: View {
    @ObservedObject var tag: Tag
    
    var body: some View {
        Text(tag.name)
            .bold()
            .foregroundStyle(.white)
            .padding(12)
            .background(.black.opacity(0.3))
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .frame(height: 70.0)
            .position(tag.position)
            .opacity(tag.name.isEmpty ? 0.0 : 1.0)
            .gesture(DragGesture()
                .onChanged { value in
                    tag.position = value.location
                }
            )
            .onAppear {
                print(tag.name)
                print(tag.position)
            }
    }
}

struct SearchView: View {
    
    @Environment(\.dismiss) private var dismiss
    @Binding var tags: [Tag]
    @Binding var newTagLocation: CGPoint
    
    var body: some View {
        NavigationView{
            List(castMembers) { item in
                HStack {
                    Text(item.name)
                    Spacer()
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    newTagLocation = newTagLocation.applying(CGAffineTransform(translationX: 0, y: 50))
                    let newTag = Tag(name: item.name, position: newTagLocation)
                    tags.append(newTag)
                    dismiss()
                }
            }
        }
    }
}

class Tag: Identifiable, ObservableObject {
    let id = UUID()
    @Published var name: String
    @Published var position: CGPoint
    
    init(name: String, position: CGPoint) {
        self.name = name
        self.position = position
    }
}

struct CastMember: Identifiable {
    let name: String
    let id = UUID()
}

private var castMembers = [
    CastMember(name: "Sponge Bob"),
    CastMember(name: "Patrick"),
    CastMember(name: "Mr Krabs"),
    CastMember(name: "Sandy"),
    CastMember(name: "Squidward"),
    CastMember(name: "Plankton"),
    CastMember(name: "Mrs. Puff"),
    CastMember(name: "Gary"),
    CastMember(name: "Karen"),
    CastMember(name: "Pearl")
]

#Preview {
    ContentView()
}

