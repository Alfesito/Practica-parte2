//
//  ContentView.swift
//  Practica4-parte1
//
//  Created by Andrés Alfaro Fernández on 3/11/22.
//

import SwiftUI

struct QuizzesListView: View {
    
    @EnvironmentObject var quizzesModel : QuizzesModel
    
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
                .onAppear{quizzesModel.load()}
            }
        }
    }
}

/*struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        QuizzesListView()
    }
}*/
