//
//  QuizzesModel.swift
//  Quiz con SwiftUI
//
//  Created by Santiago Pavón Gómez on 18/10/22.
//

import Foundation

class QuizzesModel: ObservableObject {
    
    // Los datos
    @Published private(set) var quizzes = [QuizItem]()
    
    func load() {
                
        guard let jsonURL = Bundle.main.url(forResource: "quizzes", withExtension: "json") else {
            print("Internal error: No encuentro p1_quizzes.json")
            return
        }
        
        do {
            let data = try Data(contentsOf: jsonURL)
            let decoder = JSONDecoder()
            
//            if let str = String(data: data, encoding: String.Encoding.utf8) {
//                print("Quizzes ==>", str)
//            }
            
            let quizzes = try decoder.decode([QuizItem].self, from: data)
            
            self.quizzes = quizzes

            print("Quizzes cargados")
        } catch {
            print("Algo chungo ha pasado: \(error)")
        }
    }
}
