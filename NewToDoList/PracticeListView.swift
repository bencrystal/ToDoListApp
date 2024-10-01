//
//  PracticeListView.swift
//  NewToDoList
//
//  Created by Ben Crystal on 9/30/24.
//

import SwiftUI

//CRUD
//{Create, Read, Update, Delete} Data

/*struct School: Hashable {
    let name: String
}*/

//when you refer to a struct as identifiable, you need an "id"
struct Student: Identifiable {
    
    //random ID
    let id = UUID()
    
    //computed property
    /*var id: String{
        return name
    }*/
    let name: String
    let age: Int
    //let school: School
    
    //static belongs to the type but not the instance
    
    
   
}

struct PrimaryButtonStyle: ButtonStyle {
    
    //anything that conforms to buttonstyle must include a makeBody function
    func makeBody(configuration: Configuration) -> some View {
        configuration
            .label
            .font(.system(size: 17, weight: .medium))
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 45)
            .background(Color.green)
            .clipShape(RoundedRectangle(cornerRadius: 8))
    }
    
   
}

/*
//TODO: - Fix this later
//MARK: - Conformance to Hashable
//in the NewToDoList > NewToDoList ) PracticeListView.swift > ____ you can get a rundown to declarations and marks
//this makes the base class neater
//extending student to have more behaviour
extension Student: Hashable {
    //either make School: Hashable or add...

    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
}

extension Student: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        //left hand side == right hand side
        return lhs.name == rhs.name && lhs.age == rhs.age && lhs.school == rhs.school
    }
}*/

//equatable and hashable are related protocols
//equatable means that you're able to see if they're able to be compared (if you can use == the equality operator)
//can't derive from multiple classes but a type can conform to multiple protocols



struct PracticeListView: View {
    
    //modal vs navigation stack
    //navigation stack for messages homeview
    
    @State var students: [Student] = [
        //Student(name: "Ben", age: 27),
        //Student(name: "Ay", age: 2)
    ]
    //["Ay", "Tay", "Po", "Benny"]
    
    @State var showAddStudentView = false
    
    @State var studentName = ""
    @State var studentAge = ""
    @State var studentIndex: Int? //optional because we're not always updating
    
    
    var body: some View {
        
        NavigationStack {
            ZStack{
                VStack {
                    
                    //whenever you have a mechanism that has to iterate through something it requires an id to differentiate
                    
                    //the id is the type itself
                    
                    //any type that is hashable can be used as a distinguishable element
                    
                    /*List(studentNames, id: \.self) { studentName in
                     Text (studentName)*/
                    
                    //this version of list is better because it's not bound to just studentNames
                    
                    //can use swipe to delete with the onDelete method added onto the foreach statement
                    
                    
                    /*ForEach(studentNames, id: \.self) {
                     studentName in Text(studentName)
                     }.onDelete(perform: {indexSet in studentNames.remove(atOffsets: indexSet)})
                     //.onMove(perform: {indexSet,newOffset   in studentNames})
                     
                     */
                    
                    List {
                        ForEach(students) {
                            
                            student in
                            
                            Button(action: {
                                studentName = student.name
                                studentAge = String(student.age)
                                
                                guard let studentIndex = students.firstIndex(where: { $0.id == student.id} )//finds the first index where this student's id matches the student in the students array
                                else{return}
                                
                                self.studentIndex = studentIndex
                                
                                showAddStudentView = true
                                
                            }, label:{ Text(student.name + " " + "(\(student.age))")
                            })
                            .foregroundStyle(.black)
                            
                            
                            
                            
                            
                            }
                        .onDelete(perform: {indexSet in students.remove(atOffsets: indexSet)})
                        }
                    }
                
                if showAddStudentView {
                    
                    
                    Color.black.opacity(0.4).ignoresSafeArea()
                    ZStack{
                        Color.white
                        VStack{
                            TextField("Student Name", text: $studentName).textFieldStyle(.roundedBorder)
                            TextField("Student Age", text: $studentAge).textFieldStyle(.roundedBorder)
                            Button(action: {
                                
                                guard let studentAge = Int(studentAge)
                                        else { return }
                                
                                let student = Student(name: studentName, age: studentAge)
                                
                                if let studentIndex = studentIndex {
                                    students[studentIndex] = student
                                }
                                
                                else{
                                    students.append(student)
                                }
                                
                                studentIndex = nil
                                
                                showAddStudentView = false
                                studentName = ""
                                
                                //self refers to the practicelistview itself (the outermost studentAge, or PracticeListView.studentAge)
                                self.studentAge = ""
                                
                            }, label:{ Text(studentIndex != nil ? "Update Student" : "Add Student")
                                   
                                
                                
                                
                            })
                            //the () means we're creating an instance of this button style
                            .buttonStyle(PrimaryButtonStyle())
                        }
                        .padding(.horizontal, 10)
                        
                        
                        
                        
                    }
                    
                    .overlay(alignment: .topTrailing, content: {
                        Button(action: {showAddStudentView = false},
                               label:{ Image(systemName: "xmark")
                                .font(.system(size: 18, weight: .bold))
                        })
                        
                        .padding([.top, .trailing], 10)
                    })
                    
                    
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .padding(.horizontal)
                    .frame(height: 250)
                    
                    
                }
                }
                .navigationTitle("Students")
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing){
                        Button(action: {
                            showAddStudentView = true
                        },
                               label: {
                            Image(systemName: "plus")
                        })
                    }
                
            }
        }
    }
}






#Preview {
    PracticeListView()
}
