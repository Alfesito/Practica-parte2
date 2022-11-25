//
//  QuizView.swift
//  Practica4-parte1
//
//  Created by Andrés Alfaro Fernández on 3/11/22.
//

import SwiftUI

struct QuizView: View {
    
    var quizItem : QuizItem
    var body: some View {
        VStack{
            HStack{
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
                }.frame(width: 90, height: 60, alignment: .center)
                    .scaledToFit()
                    .clipShape (Circle ())
                    .overlay (Circle ().stroke(lineWidth: 1))
                VStack{
                    HStack{
                        //Boton de favoritos
                        Image(quizItem.favourite ? "star_yellow" : "star_grey")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .scaledToFit()
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
                        }.frame(width: 15, height: 15)
                        .clipShape (Circle ())
                        //Nombre del autor
                        Text(quizItem.author?.username ?? "Someone")
                            .font(.system(size: 12, weight: .light))
                    }
                    
                    HStack{
                        //Pregunta
                        Text(quizItem.question)
                            .font(.system(size: 20, weight: .bold))
                    }
                }
            }
        }
    }
}

/*struct QuizView_Previews: PreviewProvider {
    static var previews: some View {
        QuizView()
    }
}*/
