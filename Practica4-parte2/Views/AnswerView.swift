//
//  AnswerView.swift
//  Practica4-parte1
//
//  Created by Andrés Alfaro Fernández on 4/11/22.
//
// creacion branch feature_answer_lab

import SwiftUI

struct AnswerView: View {
    
    var quizItem: QuizItem
    
    @EnvironmentObject var scoresModel: ScoresModel
    @EnvironmentObject var quizzesModel: QuizzesModel

    @State var answer: String = ""
    @State var showAlert = false
    @State private var animationAmount: CGFloat = 0
    @State private var rotationDegrees = 0.0
    
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
                Button(action: {
                    quizzesModel.favourites(quizItem: quizItem)
                    self.animationAmount += 360
                }){
                    Image(quizItem.favourite ? "star_yellow" : "star_grey")
                        .resizable()
                        .frame(width: 25, height: 25)
                        .scaledToFit()
                }
                .rotationEffect(.degrees(animationAmount))
                .animation(Animation.default)
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
                quizzesModel.checkNoAcertadas(quiz: quizItem)
            }) {
                Text("Comprobar")
            }
            
            //Imagen de la pregunta
            quizImage
            
            HStack{
                //Score
                Text("Score: \(scoresModel.acertadas.count)")
                //Imagen del autor
                authorImage
                .frame(width: 50, height: 50)
                .clipShape (Circle ())
                
            }
        }
    }
    
    private var horizontalView: some View {
        return HStack{
            VStack{
                //Imagen de la pregunta
                quizImage
            }
            VStack{
                HStack{
                    //Pregunta
                    Text(quizItem.question)
                        .font(.system(size: 20, weight: .bold))
                    
                    //Boton de favoritos
                    Button(action: {
                        quizzesModel.favourites(quizItem: quizItem)
                        self.animationAmount += 360
                    }){
                        Image(quizItem.favourite ? "star_yellow" : "star_grey")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .scaledToFit()
                    }
                }
                
                TextField("Respuesta",
                          text: $answer,
                          onCommit: {
                    showAlert = true
                    
                })
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
                    authorImage

                }
            }
        }
    }
    public var quizImage: some View {
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
            .rotationEffect(.degrees(rotationDegrees))
                        .onTapGesture(count: 2) {
                            withAnimation {
                                self.rotationDegrees += 360
                                answer = quizItem.answer
                            }
                        }
            .rotationEffect(.degrees(0))
            .animation(
                Animation.linear(duration: 1)
            )
    }
    
    public var authorImage: some View {
        AsyncImage(url: quizItem.author?.photo?.url){ phase in
            if let image = phase.image {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else if phase.error != nil {
                Text("No image available")
            } else {
                //appears as placeholder image
                Image(systemName: "photo.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
        }.frame(width: 50, height: 50)
            .clipShape (Circle ())
            .contextMenu{
                Button(action: {
                    answer = ""
                }) {
                    Text("Eliminar respuesta")
                    Image(systemName: "trash")
                }
                Button(action: {
                    answer = quizItem.answer
                }) {
                    Text("Ver solución")
                    Image(systemName: "eye")
                }
                Button(action: {
                    scoresModel.deleteScore()
                }) {
                    Text("Eliminar record")
                    Image(systemName: "arrowshape.turn.up.left.fill")
                }
            }
    }
}
