//
//  ToDoListView.swift
//  NewToDoList
//
//  Created by Ben Crystal on 9/30/24.
//

import SwiftUI

struct Task: Identifiable {
    
    //each task gets assigned a random ID so that they are uniquely identifiable/ "hashable"
    let id = UUID()
    
    //lets vs vars?  isComplete is supposed to change and title may change
    var title: String
    var isComplete: Bool
    
    //can add priorities, categories, time created, etc later
}

struct ToDoButtonStyle: ButtonStyle {
    
    //anything that conforms to buttonstyle must include a makeBody function
    func makeBody(configuration: Configuration) -> some View {
        configuration
            .label
            .font(.system(size: 17, weight: .medium))
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 45)
            .background(Color.blue)
            .clipShape(RoundedRectangle(cornerRadius: 8))
    }
    
   
}

struct ToDoListView: View {
    
        @State var tasks: [Task] = []
        
        @State var showAddTaskView = false
        
        //text that appears and is updated when creating new task or updating new task in addtaskview
        @State var taskTitle = ""
        
        //optional index that references already created tasks that we are now updating
        @State var taskIndex: Int?
        
        var body: some View {
            
            //contains title bar for home screen
            NavigationStack{
                
                //allows modal interface to appear layered on top of home screen
                ZStack{
                    
                    //vertically stacks each task
                    VStack{
                        
                        //List contains formatted structure for the whole homepage's todo list
                        List{
                            ForEach(tasks) {
                                
                                task in
                                
                                HStack{
                                    Button(action: {taskTitle = task.title
                                        //finds the first index where this task's id matches the task in the tasks array
                                        guard let taskIndex = tasks.firstIndex(where: {$0.id == task.id})
                                                
                                        else {return}
                                        
                                        self.taskIndex = taskIndex
                                        
                                        showAddTaskView = true
                                    },
                                           label:{
                                        //maybe add an hstack here with the iscomplete button trailing on the right?
                                        Text(task.title)})
                                    //changes button text to black from defauly blue
                                    .foregroundStyle(.black)
                                    
                                    Spacer()
                                    
                                    Button(action: {
                                        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
                                            tasks[index].isComplete.toggle()
                                        }
                                    }) {
                                        Image(systemName: task.isComplete ? "checkmark.circle.fill" : "circle")
                                            .foregroundColor(task.isComplete ? .green : .gray)
                                    }
                                    
                                }
                            }
                            .onDelete(perform: {indexSet in tasks.remove(atOffsets: indexSet)})
                        }
                        
                        
                        
                        
                    }
                    
                    if showAddTaskView{
                        Color.black.opacity(0.4).ignoresSafeArea()
                        ZStack{
                            Color.white
                            VStack{
                            TextField("New Task", text: $taskTitle)
                                .textFieldStyle(.roundedBorder)
                            
                                Button(action: {
                                    //TODO: do I make isComplete private or something so that it doesn't need to be referenced every time the taskTitle is updated?
                                    let task = Task(title: taskTitle, isComplete: false)
                                    
                                    if let taskIndex = taskIndex {tasks[taskIndex] = task
                                    }
                                    
                                    else{
                                        tasks.append(task)
                                    }
                                    
                                    taskIndex = nil
                                    showAddTaskView = false
                                    taskTitle = ""
                                    
                                    //do I have a conditional bool here for tracking the task's state?
                                    
                                    
                                }, label:{ Text(taskIndex != nil ? "Update Task" : "Add Task")})
                                .buttonStyle(ToDoButtonStyle())
                            
                        }
                            .padding(.horizontal, 10)
                    }
                    
                        .overlay(alignment: .topTrailing, content: {
                            Button(action: {showAddTaskView = false},
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
                    .navigationTitle("To Do List")
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing){
                            Button(action: {
                                showAddTaskView = true
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
    ToDoListView()
}
