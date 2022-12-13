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
                Text("Record: \(UserDefaults.standard.integer(forKey: kmykey))") //muestra el mayor número de acertados
                Spacer()
                Button(action: {
                    quizzesModel.download()
                    scoresModel.delete()
                }) {
                    Label("Reload", systemImage: "arrow.counterclockwise.circle")
                }
        }
        .onAppear{
            if quizzesModel.quizzes.count == 0 {
                quizzesModel.download()
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
                Text("Record: \(UserDefaults.standard.integer(forKey: kmykey))") //muestra el mayor número de acertados -> usar persistencia
                Spacer()
                Button(action: {
                    quizzesModel.download()
                    scoresModel.delete()
                }) {
                    Label("Reload", systemImage: "arrow.counterclockwise.circle")
                }
        }
        .onAppear{
            if quizzesModel.quizzes.count == 0 {
                quizzesModel.download()
            }
            
        }
        
    }
    
    
}
