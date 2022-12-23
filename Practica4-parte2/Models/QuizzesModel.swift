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
    @Published private(set) var errorMsg: String?
    
    private var subscription: AnyCancellable?
    
    let URL_BASE = "https://core.dit.upm.es/api"
    let TOKEN = "6ef2109e73a4facb5228"
    
    // Share Session y un Data Task
    private func download1(){
        var components = URLComponents()
        components.scheme = "https"
        components.host = "core.dit.upm.es"
        components.path = "/api/quizzes/random10wa"
        components.queryItems = [
            URLQueryItem(name: "token", value: "6ef2109e73a4facb5228")
        ]
        
        DispatchQueue.global().async { //Uso GCD y envío de la tarea a un thread
            guard let url = components.url else { return } //se reconstruye la url
            print("\(components.scheme!)://\(String(describing: components.percentEncodedHost!))\(components.percentEncodedPath)\(String(describing: components.percentEncodedQuery!))") //URL usando escapado con %
            
            let session = URLSession.shared.dataTask(with: url) { (data, response, error) in
                guard (response is HTTPURLResponse) else { return }
                if error != nil{ return }
                if let quizzes = try? JSONDecoder().decode([QuizItem].self, from: data!){
                    print("Load...")
                    DispatchQueue.main.async { //El GUI solo se actualiza en el Main thread
                        self.quizzes = quizzes
                        self.arrayNoAcertadas = quizzes
                    }
                }
            }
            session.resume()
        }
    }
    //Utilizando codificación Base64 y utf8
    private func download2(){
        let urlString = "\(URL_BASE)/quizzes/random10wa?token=\(TOKEN)"
        guard let url = URL(string: urlString) else{
            return
        }
        DispatchQueue.global().async {
            do{
                let data = try Data(contentsOf: url)
                //1.1 Codificamos de binario a base64
                let str_base64 = String(data.base64EncodedString())
                let data_base64 = Data(base64Encoded: str_base64)
                //1.2 Codificamos de binario a utf8
                let str_utf8 = String(data: data, encoding: String.Encoding.utf8)
                print(str_utf8!)
                //2. Decodificamos
                let quizzes = try JSONDecoder().decode([QuizItem].self, from: data_base64!)
                //let quizzes = try JSONDecoder().decode([QuizItem].self, from: data)
                DispatchQueue.main.async{
                    self.quizzes = quizzes
                }
            }catch{
                DispatchQueue.main.async{
                    print("Algo ha pasado")
                }
            }
        }
    }
    // Share session y data Task
    private func download_Task(){
        let urlString = "\(URL_BASE)/quizzes/random10wa?token=\(TOKEN)"
        guard let url = URL(string: urlString) else{
            return
        }
        URLSession.shared.dataTask(with: url){ data, response, error in
            guard error == nil else{ return }
            guard let response = (response as? HTTPURLResponse) else { return }
            if response.statusCode != 200{ return }
            guard let data,
                  let quizzes = try? JSONDecoder().decode([QuizItem].self, from: data) else{
                return
            }
            DispatchQueue.main.async {
                self.quizzes = quizzes
            }
        }.resume()
    }
    // Share session y download Task
    func download_default() {
        // Crear una sesion con la configuracion default:
        let session = URLSession(configuration: URLSessionConfiguration.default)
        // Construir un URL. No es necesario escapar ningún carácter.
        let url = URL(string: "\(URL_BASE)/quizzes/random10wa?token=\(TOKEN)")!
        // Crear un Download Task con un Completion handler
        let task = session.downloadTask(with: url) { (location: URL?, response: URLResponse?, error: Error?) in
            guard error == nil,
                  let response = response as? HTTPURLResponse,
                  response.statusCode == 200 else { return }
            guard let data = try? Data(contentsOf: location!),
                  let quizzes = try? JSONDecoder().decode([QuizItem].self, from: data) else {
                print("Error construyendo la imagen")
                return
            }
            DispatchQueue.main.async {
                self.quizzes = quizzes
            }
        }
        task.resume() // Arrancar la tarea
    }
    //Share session con funcion asincrona
    func download_async1() async {
        let urlString = "\(URL_BASE)/quizzes/random10wa?token=\(TOKEN)"
        guard let url = URL(string: urlString) else{ return }
        guard let(data,_) = try? await URLSession.shared.data(from:url),
              let quizzes = try? JSONDecoder().decode([QuizItem].self, from: data) else{
            return
        }
        DispatchQueue.main.async{
            self.quizzes = quizzes
        }
    }
    //Share session con funcion asincrona
    private func download_async2() {
        let urlString = "\(URL_BASE)/quizzes/random10wa?token=\(TOKEN)"
        Task{
            guard let url = URL(string: urlString) else{
                return
            }
            if let (data,_) = try? await URLSession.shared.data(from: url),
               let quizzes = try? JSONDecoder().decode([QuizItem].self, from: data){
                DispatchQueue.main.async {
                    self.quizzes = quizzes
                }
            }else{
                self.errorMsg = "Fallo"
            }
        }
    }
    //Share session y un data task publisher con trymap
    private func download_publisher1(){
        let urlString = "\(URL_BASE)/quizzes/random10wa?token=\(TOKEN)"
        guard let url = URL(string: urlString) else{return}
        subscription = URLSession.shared.dataTaskPublisher(for: url)
            .tryMap{data, _ in
                try JSONDecoder().decode([QuizItem].self, from: data)
            }
            .receive(on: DispatchQueue.main)
            .sink{ completion in
                if case .failure(let error) = completion {
                    self.errorMsg = error.localizedDescription
                }
            } receiveValue: { quizzes in
                self.quizzes = quizzes
            }
    }
    //Share session y un data task publisher con map sin manejar errores
    private func download_publisher2(){
        let urlString = "\(URL_BASE)/quizzes/random10wa?token=\(TOKEN)"
        guard let url = URL(string: urlString) else{ return }
        subscription = URLSession.shared.dataTaskPublisher(for: url)
            .map (\.data)
            .decode (type: [QuizItem].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .replaceError(with: [])
            .assign(to: \.quizzes, on: self)
    }
    //Share session y un data task publisher con map manejando errores
    private func download_publisher3(){
        let urlString = "\(URL_BASE)/quizzes/random10wa?token=\(TOKEN)"
        guard let url = URL(string: urlString) else{ return }
        subscription = URLSession.shared.dataTaskPublisher(for: url)
            .map (\.data)
            .decode (type: [QuizItem].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .catch({error in
                return Just([QuizItem]())
            })
                .assign(to: \.quizzes, on: self)
    }
    
    func download(){
        download1()
        //download2()
        //download_Task()
        //download_default()
        //download_async2()
        //download_publisher1()
        //download_publisher2()
        //download_publisher3()
    }
    
    func favourites(quizItem: QuizItem){
        guard let index = quizzes.firstIndex(where: {$0.id == quizItem.id}) else {
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
        
        URLSession.shared.uploadTask(with: req, from: Data()) {(data, res, error) in
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
                if(index < self.arrayNoAcertadas.count){
                    self.arrayNoAcertadas[index].favourite.toggle()
                }
            }
        }.resume()
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
    
    func load() {
        //Bundle.main permite acceder a los recursos que se añadieron en el proyecto
        guard let jsonURL = Bundle.main.url(forResource: "quizzes", withExtension: "json") else {
            print("Internal error: No encuentro p1_quizzes.json")
            return
        }
        do {
            let data = try Data(contentsOf: jsonURL)
            let decoder = JSONDecoder()
            let quizzes = try decoder.decode([QuizItem].self, from: data)
            self.quizzes = quizzes
            print("Quizzes cargados")
        } catch {
            print("Algo chungo ha pasado: \(error)")
        }
    }
}
