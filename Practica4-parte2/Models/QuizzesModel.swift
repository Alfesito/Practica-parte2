//
//  QuizzesModel.swift
//  Quiz con SwiftUI
//
//  Created by Santiago Pavón Gómez on 18/10/22.
//

import Foundation
import Combine

class QuizzesModel: ObservableObject {
    
    // Los datos
    @Published private(set) var quizzes = [QuizItem]()
    @Published private(set) var arrayNoAcertadas = [QuizItem]()

    
    let URL_BASE = "https://core.dit.upm.es/api"
    let TOKEN = "6ef2109e73a4facb5228"
    
    func download(){
        
        let urlString = "\(URL_BASE)/quizzes/random10wa?token=\(TOKEN)"
        guard let url = URL(string: urlString) else{
            print("No se han descargado los quizzes")
            return
        }
        
        let session = URLSession.shared.dataTask(with: url) { (data, res, error) in
            if (res as! HTTPURLResponse).statusCode != 200{
                print("Response")
                return
            }
            if error != nil{
                print("Error")
                return
            }
            
            if let quizzes = try? JSONDecoder().decode([QuizItem].self, from: data!){
                print("Load...")
                DispatchQueue.main.async {
                    self.quizzes = quizzes
                    self.arrayNoAcertadas = quizzes
                }
            }
        }
        session.resume()
    }
    
    func favourites(quizItem: QuizItem){
        
        guard let index = quizzes.firstIndex(where: {$0.id == quizItem.id}) else {
            print("Fallo 5 index")
            return
        }
        
        let urlString = "\(URL_BASE)/users/tokenOwner/favourites/\(quizItem.id)?token=\(TOKEN)"
        
        guard let url = URL(string: urlString) else{
            print(urlString)
            print("Fallo al crear la url")
            return
        }
        
        var req = URLRequest(url: url)
        req.httpMethod = quizItem.favourite ? "DELETE" : "PUT"
        req.addValue("XMLHttpRequest", forHTTPHeaderField: "X-Requested-With")
        
        let session = URLSession.shared.uploadTask(with: req, from: Data()) {(data, res, error) in
            
            if (res as! HTTPURLResponse).statusCode != 200{
                print("Fallo en response")
                return
            }
            if error != nil{
                print("Fallo en error")
                return
            }
            
            DispatchQueue.main.async {
                self.quizzes[index].favourite.toggle()
                self.arrayNoAcertadas[index].favourite.toggle()
            }
        }
        session.resume()
        
    }
    
    func checkNoAcertadas(quiz: QuizItem){
        var cont = 0
        arrayNoAcertadas.forEach{ i in
            if i.id == quiz.id{
                arrayNoAcertadas.remove(at: cont)
            }
            cont += 1
        }
    }
}
