//
//  ScoresModel.swift
//  P4_1_FCM
//
//  Created by b023 DIT UPM on 7/11/22.
//

import Foundation

class ScoresModel: ObservableObject {
    
    @Published private(set) var arrayAcertadas: Array <QuizItem> = []
    @Published private(set) var arrayNoAcertadas: Array <QuizItem> = []
    @Published private(set) var stringAcertadas: Set <String> = []
    @Published private(set) var acertadas: Set <Int> = []
    private var kmykey = "MY_KEY"
    
    func check(respuesta: String, quiz: QuizItem){
        let a1 = respuesta.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        let a2 = quiz.answer.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        if(a1 == a2){
            acertadas.insert(quiz.id)
            stringAcertadas.insert(quiz.question)
            
            // Guarda en array acertadas los quizzes acertados
            arrayAcertadas.append(quiz)
            if arrayAcertadas.count != acertadas.count {
                arrayAcertadas.removeLast()
            }
        }
        
    }
    
    func score(){
        if(UserDefaults.standard.integer(forKey: kmykey) < acertadas.count){
            UserDefaults.standard.set(acertadas.count, forKey: kmykey)
            UserDefaults.standard.synchronize()
        }
    }
}
