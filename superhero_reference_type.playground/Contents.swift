import Foundation
import PlaygroundSupport

enum Superpower {
    case arachnidSense
    case genius
}

extension Superpower {
    func win(luckyFactor: Int) -> Bool {
        switch self {
        case .arachnidSense:
            return luckyFactor < 40
        case .genius:
            return luckyFactor >= 40
        }
    }
}

class Superhero {
    let name: String
    let superpower: Superpower
    var health: Int
    
    init(name: String, superpower: Superpower, health: Int) {
        self.name = name
        self.superpower = superpower
        self.health = health
    }

    func fight(_ enemy:Superhero, luckyFactor: Int) {
        if (enemy.superpower.win(luckyFactor: luckyFactor)) {
           health = health - 10
        }
    }
    
    var isAlive: Bool {
        return health > 0
    }
}

extension Superhero: CustomStringConvertible {
    var description: String {
        if (isAlive) {
            return "\(name) alive and kicking!"
        } else {
            return "Oh, my God, they killed \(name)!"
        }
    }
}

class Character {
    let name: String
    let meet: (Superhero) -> String
    
    init(name: String, meet: @escaping (Superhero) -> String) {
        self.name = name
        self.meet = meet
    }
}

func fightTillDeath(superhero1: Superhero, superhero2: Superhero) {
    var round = 0
    while (superhero1.isAlive && superhero2.isAlive) {
        let luckyFactor = Int(arc4random_uniform(100))
        superhero1.fight(superhero2, luckyFactor: luckyFactor)
        superhero2.fight(superhero1, luckyFactor: luckyFactor)
        print("    Round \(round): \(superhero1.name) with \(superhero1.health) health against \(superhero2.name) with \(superhero2.health) health")
        round += 1
    }
    print(superhero1)
    print(superhero2)
}

func interact(superhero: Superhero, character: Character) {
    DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + 2.0) {
        print(character.meet(superhero))
    }
}

var spiderman = Superhero(name:"Spiderman", superpower: .arachnidSense, health: 100)
var drDoom = Superhero(name:"Dr. Doom", superpower: .genius, health: 100)
let maryJane = Character(name: "Mary Jane") { superhero in
    if (superhero.name == "Spiderman") {
        assert(superhero.isAlive)
        return "Mary Jane: Oh, my hero! 😍"
    } else {
        return "Mary Jane: Help!"
    }
}

interact(superhero: spiderman, character: maryJane)
fightTillDeath(superhero1: spiderman, superhero2: drDoom)


PlaygroundPage.current.needsIndefiniteExecution = true
