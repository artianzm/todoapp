//
//  ContentView.swift
//  Project1
//
//  Created by Artijan Zmajli on 24.01.21.
//

import SwiftUI

struct ContentView: View {
    
    @State private var newTodo = ""
    @State private var allTodos : [todoItem] = []
    private let todosKey = "todosKey"
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    TextField("Tell me what u want to do next", text: $newTodo )
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Button(action: {
                        guard !self.newTodo.isEmpty else {return}
                        self.allTodos.append(todoItem(todo: self.newTodo))
                        self.newTodo = ""
                        self.saveTodos()
                    }) {
                        Image(systemName: "plus")
                    }.padding(.leading,5)
                    
                }.padding()
                List {
                    ForEach(allTodos) {todoItem in
                        Text(todoItem.todo).foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                    }.onDelete(perform: deleteTodo)
                }
            }
            .navigationBarTitle("Whats next..")
        }.onAppear(perform: loadTodos)
    }
    
    
    
    private func deleteTodo(at offsets: IndexSet) {
        self.allTodos.remove(atOffsets: offsets)
        saveTodos()
    }
    
    private func loadTodos() {
        if let todosData = UserDefaults.standard.value(forKey: self.todosKey) as? Data {
            if let todosList = try? PropertyListDecoder().decode(Array<todoItem>.self, from: todosData) {
                self.allTodos = todosList
            }
        }
    }
    
    private func saveTodos() {
        UserDefaults.standard.set(try? PropertyListEncoder().encode(self.allTodos), forKey: todosKey)
    }
}



struct todoItem: Codable, Identifiable {
    var id = UUID()
    let todo :String;
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
