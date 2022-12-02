//
//  ContentView.swift
//  Practica4-parte1
//
//  Created by Andrés Alfaro Fernández on 3/11/22.
//

import SwiftUI

struct QuizzesListView: View {
    
    @EnvironmentObject var quizzesModel : QuizzesModel
    @EnvironmentObject var scoresModel: ScoresModel
    
    var body: some View{
        NavigationStack{
            VStack{
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
                .navigationBarItems(
                                    leading: Text("Record:"), //muestra el mayor número de acertados
                                    trailing: Button(action: {
                                        quizzesModel.download()
                                        scoresModel.delete()
                                    }) {
                                        Label("Reload", systemImage: "arrow.counterclockwise.circle")
                                    }
                )
                .onAppear{
                    quizzesModel.quizzes.count == 0 ? quizzesModel.download() : nil
                }
            }
        }
    }
}

/*struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        QuizzesListView()
    }
}*/
