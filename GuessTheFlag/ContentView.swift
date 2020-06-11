//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by KazukiNakano on 2020/05/28.
//  Copyright © 2020 kazu. All rights reserved.
//

import SwiftUI

struct FlagImage: ViewModifier {
    func body(content: Content) -> some View {
        content
            .clipShape(Capsule())
            .overlay(Capsule().stroke(Color.black, lineWidth: 1))
            .shadow(color: Color.black, radius: 2)
    }
}

extension View {
    func FlagImageStyle() -> some View {
        self.modifier(FlagImage())
    }
}

struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var score = 0
    
    @State private var animationAmount = [0.0, 0.0, 0.0]
    @State private var blurRadius = [0.0, 0.0, 0.0]
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.blue, .black]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 30) {
                VStack {
                    Text("Tap the flag of")
                        .foregroundColor(.white)
                    Text(countries[correctAnswer])
                        .foregroundColor(.white)
                        .font(.largeTitle)
                        .fontWeight(.black)
                }
                
                ForEach(0 ..< 3) { number in
                    Button(action: {
                        self.flagTapped(number)
                    }) {
                        Image(self.countries[number])
                            .renderingMode(.original)
                            .self.modifier(FlagImage())
                            .blur(radius: CGFloat(self.blurRadius[number]))
                            .rotation3DEffect(.degrees(self.animationAmount[number]), axis: (x: 0, y: 1, z: 0))
                    }
                }
                
                HStack {
                    Text("Your score is")
                        .foregroundColor(.white)
                    Text("\(score)")
                        .foregroundColor(.white)
                        .font(.largeTitle)
                        .fontWeight(.black)
                }
                
                Spacer()
            }
        }
        .alert(isPresented: $showingScore) {
            Alert(title: Text(scoreTitle), message: Text("Your score is \(score)"), dismissButton: .default(Text("Continue")) {
                self.askQuestion()
                })
        }
    }
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct"
            score += 1
            withAnimation {
                self.animationAmount[number] += 360
            }
        } else {
            scoreTitle = "Wrong! That's flag of \(countries[number])"
            score = 0
        }
        
        if correctAnswer == 0 {
            withAnimation {
                self.blurRadius[1] = 25.0
                self.blurRadius[2] = 25.0
            }
        } else if correctAnswer == 1 {
            withAnimation {
                self.blurRadius[0] = 25.0
                self.blurRadius[2] = 25.0
            }
        } else {
            withAnimation {
                self.blurRadius[0] = 25.0
                self.blurRadius[1] = 25.0
            }
        }
        
        showingScore = true
    }
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        withAnimation {
            self.blurRadius = [0.0, 0.0, 0.0]
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
