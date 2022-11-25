//
//  AnswerView.swift
//  Practica4-parte1
//
//  Created by Andrés Alfaro Fernández on 4/11/22.
//
// creacion branch feature_answer_lab

import SwiftUI

struct AnswerView: View {
    
    var quizItem:QuizItem
    
    @EnvironmentObject var scoresModel: ScoresModel
    @State var answer: String = ""
    @State var showAlert = false
    
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass
    
    var body: some View {
        if verticalSizeClass == .compact{
            horizontalView
        }else{
            verticalView
        }
    }
    
    private var verticalView: some View {
        return VStack{
            HStack{
                
                //Pregunta
                Text(quizItem.question)
                    .font(.system(size: 20, weight: .bold))
                
                //Boton de favoritos
                Image(quizItem.favourite ? "star_yellow" : "star_grey")
                    .resizable()
                    .frame(width: 25, height: 25)
                    .scaledToFit()
            }
            
            TextField("Respuesta",
                      text: $answer,
                      onCommit: {
                showAlert = true
            }
                      
            )
            .padding(40)
            .overlay (RoundedRectangle (cornerRadius: 20).stroke(lineWidth: 1))
            .padding(30)
            .alert(isPresented: $showAlert) {
                let string1 = quizItem.answer.lowercased().trimmingCharacters(in:
                        .whitespacesAndNewlines)
                let string2 = answer.lowercased().trimmingCharacters(in:
                        .whitespacesAndNewlines)
                return Alert(title: Text("Resultado"),
                             message: Text(string1 == string2 ? "Correcta" : "Incorrecta"),
                             dismissButton: .default(Text("Ok"))
                )
            }
            
            Button(action: {
                showAlert = true
                scoresModel.check(respuesta: answer, quiz: quizItem)
                scoresModel.score()
            }) {
                Text("Comprobar")
            }
            
            //Imagen de la pregunta
            AsyncImage(url: quizItem.attachment?.url){ phase in // 1
                if let image = phase.image { // 2
                    // if the image is valid
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } else if phase.error != nil { // 3
                    // some kind of error appears
                    Text("No image available")
                } else {
                    //appears as placeholder image
                    Image(systemName: "photo.circle.fill") // 4
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }
            }.frame(width: 360, height: 240, alignment: .center)
                .scaledToFit()
                .clipShape (RoundedRectangle (cornerRadius: 20))
                .overlay (RoundedRectangle (cornerRadius: 20).stroke(lineWidth: 4))
                .padding(30)
       
            HStack{
                //Score
                Text("Score: \(scoresModel.acertadas.count)")
                
                //Imagen del autor
                AsyncImage(url: quizItem.author?.photo?.url){ phase in // 1
                    if let image = phase.image { // 2
                        // if the image is valid
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } else if phase.error != nil { // 3
                        // some kind of error appears
                        Text("No image available")
                    } else {
                        //appears as placeholder image
                        Image(systemName: "photo.circle.fill") // 4
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    }
                }.frame(width: 50, height: 50)
                    .clipShape (Circle ())
            }
        }
    }
    
    private var horizontalView: some View {
        return HStack{
            VStack{
                //Imagen de la pregunta
                AsyncImage(url: quizItem.attachment?.url){ phase in // 1
                    if let image = phase.image { // 2
                        // if the image is valid
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } else if phase.error != nil { // 3
                        // some kind of error appears
                        Text("No image available")
                    } else {
                        //appears as placeholder image
                        Image(systemName: "photo.circle.fill") // 4
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    }
                }.frame(width: 360, height: 240, alignment: .center)
                    .scaledToFit()
                    .clipShape (RoundedRectangle (cornerRadius: 20))
                    .overlay (RoundedRectangle (cornerRadius: 20).stroke(lineWidth: 4))
                    .padding(30)
            }
            VStack{
                HStack{
                    
                    //Pregunta
                    Text(quizItem.question)
                        .font(.system(size: 20, weight: .bold))
                    
                    //Boton de favoritos
                    Image(quizItem.favourite ? "star_yellow" : "star_grey")
                        .resizable()
                        .frame(width: 25, height: 25)
                        .scaledToFit()
                }
                
                TextField("Respuesta",
                          text: $answer,
                          onCommit: {
                    showAlert = true
                }
                          
                )
                .padding(40)
                .overlay (RoundedRectangle (cornerRadius: 20).stroke(lineWidth: 1))
                .padding(30)
                .alert(isPresented: $showAlert) {
                    let string1 = quizItem.answer.lowercased().trimmingCharacters(in:
                            .whitespacesAndNewlines)
                    let string2 = answer.lowercased().trimmingCharacters(in:
                            .whitespacesAndNewlines)
                    return Alert(title: Text("Resultado"),
                                 message: Text(string1 == string2 ? "Correcta" : "Incorrecta"),
                                 dismissButton: .default(Text("Ok"))
                    )
                }
                
                Button(action: {
                    showAlert = true
                    scoresModel.check(respuesta: answer, quiz: quizItem)
                    scoresModel.score()
                }) {
                    Text("Comprobar")
                }
                
                HStack{
                    //Score
                    Text("Score: \(scoresModel.acertadas.count)")
                    
                    //Imagen del autor
                    AsyncImage(url: quizItem.author?.photo?.url){ phase in // 1
                        if let image = phase.image { // 2
                            // if the image is valid
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        } else if phase.error != nil { // 3
                            // some kind of error appears
                            Text("No image available")
                        } else {
                            //appears as placeholder image
                            Image(systemName: "photo.circle.fill") // 4
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        }
                    }.frame(width: 50, height: 50)
                        .clipShape (Circle ())
                }
            }
        }
    }
}
/*
struct QuizPlayView_Previews: PreviewProvider {
    static var previews: some View {
        QuizPlayView()
    }
}
*/
