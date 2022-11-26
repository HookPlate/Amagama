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
    
    let animals = ["panda", "bear", "chick", "bear","chicken", "crocodile", "cow", "elephant", "duck", "giraffe", "hippo", "gorilla", "sloth", "goat", "narwhal", "parrot", "owl", "penguin", "moose", "pig", "snake", "rhino", "walrus", "penguin", "whale", "rabbit", "zebra", "sloth", "snake", "walrus", "whale", "zebra"]
    
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
    
    
    @Published var isSoundtrackPlaying = false
    @Published var returningFromDetail = false
    
    //keeps track of which sentences the user has purchased
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
    
    func restorePurchase(theme: Theme) {
        PurchaseService.restore(productId: theme.productId) {
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
    
    
    private func storeInUserDefaults() {
        UserDefaults.standard.set(try? JSONEncoder().encode(themes), forKey: "ThemeStore")
        UserDefaults.standard.set(try? JSONEncoder().encode(isSoundtrackPlaying), forKey: "SoundTrack")
        
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

