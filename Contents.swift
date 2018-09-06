

import Foundation


class Spoon
{
    static let spoonsSemaphore: [DispatchSemaphore] = Array(repeating: DispatchSemaphore(value: 2), count: 5)
    
    let leftSpoon: DispatchSemaphore
    let rightSpoon: DispatchSemaphore
    
    //    var leftSpoonIsPickedUp: Bool = false
    //    var rightSpoonIsPickedUp: Bool = false
    //    var isPickedUp: Bool = true
    //    var developer: Developer?
    private let lock = NSLock()
    
    init(leftIndex: Int, rightIndex: Int)
    {
        if leftIndex > rightIndex {
            leftSpoon = Spoon.spoonsSemaphore[leftIndex]
            rightSpoon = Spoon.spoonsSemaphore[rightIndex]
        } else {
            leftSpoon = Spoon.spoonsSemaphore[rightIndex]
            rightSpoon = Spoon.spoonsSemaphore[leftIndex]
        }
    }
    
    func pickUp()
    {
        //wait until another developer call putDown()
        
        //isPickedUp = true
        //        rightSpoonIsPickedUp = true
        //        leftSpoonIsPickedUp = true
        leftSpoon.wait()
        rightSpoon.wait()
        
    }
    
    func putDown()
    {
        //        lock.lock()
        //        rightSpoonIsPickedUp = false
        //
        //        leftSpoonIsPickedUp = false
        //        lock.unlock()
        
        leftSpoon.signal()
        
        rightSpoon.signal()
        
        print("spoon is put down")
    }
}

class Developer
{
    //let developer: String
    //    var leftSpoon: Spoon
    //    var rightSpoon: Spoon
    var leftIndex = -1
    var rightIndex = -1
    let developerIndex: Int
    let spoons: Spoon
    
    init(developerIndex: Int)
    {
        leftIndex = developerIndex
        rightIndex = developerIndex - 1
        
        if rightIndex < 0 {
            rightIndex += 5
        }
        
        self.developerIndex = developerIndex
        
        
        self.spoons = Spoon(leftIndex: leftIndex, rightIndex: rightIndex)
        
        print("Developer: \(developerIndex)  left: \(leftIndex)  right: \(rightIndex)")
        
    }
    
    
    
    
    func think() {
        print("\(developerIndex) is thinking.")
        spoons.pickUp()
        
    }
    
    func eat() {
        print("\(developerIndex) is eating.")
        usleep(arc4random_uniform(10000))
        spoons.putDown()
        
    }
    
    
    func run() {
        while true {
            
            think()
            eat()
            
            //        if spoons.leftSpoonIsPickedUp == true && spoons.rightSpoonIsPickedUp == false || spoons.leftSpoonIsPickedUp == false && spoons.rightSpoonIsPickedUp == true
            //        {
            //            print("\(developerIndex) is in limbo")
            //        }
        }
    }
    
    
}

//let spoon = Spoon()
//spoon.pickUp()

//var spoon1 = Spoon(leftIndex: 1, rightIndex: 5)
//var spoon2 = Spoon(leftIndex: 2, rightIndex: 1)
//var spoon3 = Spoon(leftIndex: 3, rightIndex: 2)
//var spoon4 = Spoon(leftIndex: 4, rightIndex: 3)
//var spoon5 = Spoon(leftIndex: 5, rightIndex: 4)
//
//var developer1 = Developer(developer: "Developer1", developerIndex: 1, spoons: spoon1)
//var developer2 = Developer(developer: "Developer2", developerIndex: 2, spoons: spoon2)
//var developer3 = Developer(developer: "Developer3", developerIndex: 3, spoons: spoon3)
//var developer4 = Developer(developer: "Developer4", developerIndex: 4, spoons: spoon4)
//var developer5 = Developer(developer: "Developer5", developerIndex: 5, spoons: spoon5)
//
//let developers = [developer1, developer2, developer3, developer4, developer5]

//DispatchQueue.concurrentPerform(iterations: 5) { i in
//    developers[i].run()
//}

//DispatchQueue.concurrentPerform(iterations: 5) {
//    developers[$0].run()
//}

let globalSem = DispatchSemaphore(value: 0)

for i in 0..<5 {
    DispatchQueue.global(qos: .background).async {
        let p = Developer(developerIndex: i)
        
        p.run()
    }
}

//Start the thread signaling the semaphore
for semaphore in Spoon.spoonsSemaphore {
    semaphore.signal()
}

//Wait forever
globalSem.wait()
