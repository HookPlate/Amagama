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
    let sentences = ["We look at the children",
                     "Make them out of this",
                     "I like to see people",
                     "They saw him and her",
                     "His car is with me",
                     "Can you go for help?",
                     "Could she put that back?",
                     "It looked so very old",
                     "Mum said just get up",
                     "He was not in time",
                     "Dad called about their house",
                     "Mother asked if baby sat",
                     "Don't come down from there",
                     "My little cat came by",
                     "Some say let's have fun",
                     "Your friends went into school",
                     "All animals are in place",
                     "Mr and Mrs made food",
                     "One day when I'm big",
                     "It's here now what then?"]
    
    let animals =  ["bear", "buffalo", "chick", "chicken", "cow", "crocodile", "duck", "dog", "elephant", "frog", "giraffe", "goat", "gorilla", "hippo", "horse", "monkey", "moose", "narwhal", "owl", "panda", "parrot", "penguin", "pig", "rabbit", "rhino", "sloth", "snake", "walrus", "whale", "zebra"]
    
    init() {
        restoreFromUserDefaults()
        print("Using built in palettes")
        print(userPurchases)
        if themes.isEmpty {
            var animalIndex = 0
            
            for i in sentences {
                if i != "We look at the children" {
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
    
//    func themeScore (_ theme: Theme) {
//
//    }
    
    
    
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

