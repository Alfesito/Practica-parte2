//
//  ContentView.swift
//  Practica4-parte1
//
//  Created by Andrés Alfaro Fernández on 3/11/22.
//

import SwiftUI

struct QuizzesListView: View {
    
    @EnvironmentObject var quizzesModel: QuizzesModel
    @EnvironmentObject var scoresModel: ScoresModel
    private var kmykey = "MY_KEY"
    @State var toggleAcertadas = false
    @State var showAlert = false
    
    var body: some View{
        NavigationStack{
            VStack{
                Toggle(isOn: $toggleAcertadas, label:{
                    Text("Quizzes sin resolver")
                })
                .padding(20)
                
                if toggleAcertadas {
                    noAcertadasView
                }else{
                    quizzesView
                }
            }
        }
    }
    
    private var quizzesView: some View{
        List{
            ForEach(quizzesModel.quizzes){ qi in
                NavigationLink(
                    destination: AnswerView(quizItem: qi)
                ){
                    QuizView(quizItem: qi)
                }
                
            }
        }
        .navigationTitle("Quizzes")
        .toolbar{
            ToolbarItem(placement: .navigationBarLeading){
                Text("Record: \(UserDefaults.standard.integer(forKey: kmykey))")
            }
            ToolbarItem(placement: .navigationBarTrailing){
                Button(action: {
                    quizzesModel.download()
                    //Task{ await quizzesModel.download_async1() }
                    scoresModel.delete()
                }) {
                    Label("Reload", systemImage: "arrow.counterclockwise.circle")
                }
            }
        }
        .onAppear{
            if quizzesModel.quizzes.count == 0 {
                quizzesModel.download()
            }
        }
        .task {
            if quizzesModel.quizzes.count == 0 {
                //await quizzesModel.download_async1()
            }
        }
        .onReceive(quizzesModel.$errorMsg) { msg in
            showAlert = msg != nil
        }
        .alert(isPresented: $showAlert){
            Alert(title: Text("ERROR"),
                  message: Text(quizzesModel.errorMsg ?? ""),
                  dismissButton: .default(Text("Cerrar"))
            )
        }
    }
    
    private var noAcertadasView: some View{
        List{
            ForEach(quizzesModel.arrayNoAcertadas){ qi in
                NavigationLink(
                    destination: AnswerView(quizItem: qi)
                ){
                    QuizView(quizItem: qi)
                }
            }
        }
        .navigationTitle("Quizzes")
        .toolbar{
            ToolbarItem(placement: .navigationBarLeading){
                Text("Record: \(UserDefaults.standard.integer(forKey: kmykey))")
            }
            ToolbarItem(placement: .navigationBarTrailing){
                Button(action: {
                    quizzesModel.download()
                    //Task{ await quizzesModel.download_async1() }
                    scoresModel.delete()
                }) {
                    Label("Reload", systemImage: "arrow.counterclockwise.circle")
                }
            }
        }
        .onAppear{
            if quizzesModel.quizzes.count == 0 {
                quizzesModel.download()
            }
        }
        .task {
            if quizzesModel.quizzes.count == 0 {
                //await quizzesModel.download_async1()
            }
        }
    }
}
