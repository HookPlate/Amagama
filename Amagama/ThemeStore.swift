//
//  ThemeStore.swift
//  Amagama
//
//  Created by Yoli on 28/07/2022.
//

//This is the Model & ViewModel for the first screen (GameChooserView)

import Foundation

struct Theme: Hashable, Codable, Identifiable {
    var title: String
    var emojis: [String]
    var imageName: String
    var id = UUID()
    var score : Int
    var restartable: Bool
    var productId: String?
}

class ThemeStore: ObservableObject{
    let sentences = ["I like to see people",
                     "We look at the children",
                     "They saw him and her",
                     "Mum said just get up",
                     "Could she put that back?",
                     "Can you go for help?",
                     "He was not on time",
                     "His car is with me",
                     "It looked so very old",
                     "Make them out of this",
                     "One day when I'm big",
                     "My little cat came by",
                     "Some say let's have fun",
                     "All animals are in place",
                     "Mr and Mrs made food",
                     "Mother asked if baby cried",
                     "It's here now what then?",
                     "Dad called about their house",
                     "Your friends went into school",
                     "Don't come down from there"]
    
    let animals =  ["buffalo", "chick", "chicken", "cow", "crocodile", "elephant", "giraffe", "gorilla", "hippo", "horse", "narwhal", "owl", "parrot", "penguin", "pig", "rhino", "snake", "walrus", "whale", "zebra"]
    
    init() {
        restoreFromUserDefaults()
        print("Using built in palettes")
        print(userPurchases)
        if themes.isEmpty {
            var animalIndex = 0
            
            for i in sentences {
                if i != "I like to see people" {
                    animalIndex += 1
                    themes.append(Theme(title: i, emojis: i.components(separatedBy: " "), imageName: animals[animalIndex], score: 0, restartable: false, productId: "19BuyableSentences"))
                } else {
                    themes.append(Theme(title: i, emojis: i.components(separatedBy: " "), imageName: animals[animalIndex], score: 0, restartable: false, productId: "FreeSentence"))
                }
                
            }
        } else {
            print("Succesfully loaded palletes from UserDefaults: \(themes)")
        }
    }
    
    @Published var themes: [Theme] = [] {
        didSet {
            storeInUserDefaults()
        }
    }
    
    //var isMuted = false
    
    @Published var isSoundtrackPlaying = false
    @Published var returningFromDetail = false
    
    //keeps track of which meditations the user has purchased
    @Published var userPurchases = ["FreeSentence": true]
    
    func makePurchase(theme: Theme) {
        
        //perform purchase
        PurchaseService.purchase(productId: theme.productId) {
            
            //upon successful purchase set the purchase status of the theme
            if theme.productId != nil {
                self.userPurchases[theme.productId!] = true
                self.storePurchasesInUserDefaults()
            }
            
        }
    }
    
    func resetThemeScores() {
        for index in themes.indices {
            themes[index].score = 0
        }
    }
    
    
    
//    @Published var themes = [
//        Theme(title:  "I like to see people", emojis:  ["I", "like", "to", "see", "people"], imageName: "zebra"),
//        Theme(title: "We look at the children", emojis: ["We", "look", "at", "the", "children"], imageName: "buffalo"),
//        Theme(title: "Can you go for help?", emojis: ["can", "you", "go", "for", "help?"], imageName: "whale"),
//        Theme(title:  "Dad called about their house", emojis:  ["Dad", "called", "about", "their", "house"], imageName: "chick"),
//        Theme(title: "Don't come down from there", emojis: ["Don't", "come", "down", "from", "there"], imageName: "chicken"),
//        Theme(title: "Can you go for help?", emojis: ["can", "you", "go", "for", "help?"], imageName: "crocodile"),
//        Theme(title:  "I like to see people", emojis:  ["I", "like", "to", "see", "people"], imageName: "owl"),
//        Theme(title: "We look at the children", emojis: ["We", "look", "at", "the", "children"], imageName: "dog"),
//        Theme(title: "Can you go for help?", emojis: ["can", "you", "go", "for", "help?"], imageName: "duck"),
//        Theme(title:  "I like to see people", emojis:  ["I", "like", "to", "see", "people"], imageName: "elephant"),
//        Theme(title: "We look at the children", emojis: ["We", "look", "at", "the", "children"], imageName: "frog"),
//        Theme(title: "Can you go for help?", emojis: ["can", "you", "go", "for", "help?"], imageName: "cow"),
//        Theme(title:  "I like to see people", emojis:  ["I", "like", "to", "see", "people"], imageName: "giraffe"),
//        Theme(title: "We look at the children", emojis: ["We", "look", "at", "the", "children"], imageName: "goat"),
//        Theme(title: "Can you go for help?", emojis: ["can", "you", "go", "for", "help?"], imageName: "gorilla"),
//        Theme(title:  "I like to see people", emojis:  ["I", "like", "to", "see", "people"], imageName: "hippo"),
//        Theme(title: "We look at the children", emojis: ["We", "look", "at", "the", "children"], imageName: "horse"),
//        Theme(title: "Can you go for help?", emojis: ["can", "you", "go", "for", "help?"], imageName: "monkey"),
//        Theme(title:  "I like to see people", emojis:  ["I", "like", "to", "see", "people"], imageName: "moose"),
//        Theme(title: "We look at the children", emojis: ["We", "look", "at", "the", "children"], imageName: "narwhal"),
//        Theme(title: "Can you go for help?", emojis: ["can", "you", "go", "for", "help?"], imageName: "panda"),
//        Theme(title:  "I like to see people", emojis:  ["I", "like", "to", "see", "people"], imageName: "parrot"),
//        Theme(title: "We look at the children", emojis: ["We", "look", "at", "the", "children"], imageName: "penguin"),
//        Theme(title: "Can you go for help?", emojis: ["can", "you", "go", "for", "help?"], imageName: "pig")
//    ]
    
    
    private func storeInUserDefaults() {
        UserDefaults.standard.set(try? JSONEncoder().encode(themes), forKey: "ThemeStore")
        
    }
    
    private func storePurchasesInUserDefaults() {
        UserDefaults.standard.set(try? JSONEncoder().encode(userPurchases), forKey: "userPurchases")
    }
    
    private func restoreFromUserDefaults() {
        if let jsonData = UserDefaults.standard.data(forKey: "ThemeStore"),
           let decodedThemes = try? JSONDecoder().decode([Theme].self, from: jsonData) {
            themes = decodedThemes
        }
        
        if let jsonData = UserDefaults.standard.data(forKey: "userPurchases"),
           let decodedUserPurchases = try? JSONDecoder().decode([String: Bool].self, from: jsonData) {
            userPurchases = decodedUserPurchases
        }
    }

    
    var sentencesComplete : Int {
        var myTotalScore = 0
        for theme in themes {
            myTotalScore += theme.score
        }
        return myTotalScore
    }
    
}

