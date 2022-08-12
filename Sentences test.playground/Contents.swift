import UIKit

let sentences = ["I like to see people",
                 "They saw him and her",
                 "His car is with me",
                 "Can you go for help?",
                 "Could she put that back?",
                 "It looked so very old",
                 "Mum said just get up",
                 "He was not in time",
                 "Dad called about their house",
                 "Mother asked if baby sat",
                 "Don’t come down from there",
                 "My little cat came by",
                 "Some say \"Let’s have fun\"",
                 "Your friends went into school",
                 "All animals are in place",
                 "Mr and Mrs made food",
                 "One day when I’m big",
                 "It’s here now, what then?",
                 "We look at the children",
                 "Make them out of this"]

//for i in sentences {
//    print(i)
//}

struct Theme: Hashable, Codable, Identifiable {
    var title: String
    var emojis: [String]
    var imageName: String
    var id = UUID()
    var score : Int
}

func formatThemeFor(sentence: String) -> Theme {
    return sentences[Theme(title: <#T##String#>, emojis: <#T##[String]#>, imageName: <#T##String#>, id: <#T##UUID#>, score: <#T##Int#>)]
}

