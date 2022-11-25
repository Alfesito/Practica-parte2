//
//  Practica4_parte2App.swift
//  Practica4-parte2
//
//  Created by Andrés Alfaro Fernández on 25/11/22.
//

import SwiftUI

@main
struct Practica4_parte1App: App {
    
    let quizzesModel = QuizzesModel()
    let scoresModel = ScoresModel()
    
    var body: some Scene {
        WindowGroup {
            QuizzesListView()
                .environmentObject(quizzesModel)
                .environmentObject(scoresModel)

        }
    }
}
