//
//  CoreData.swift
//  VocabularyGame
//
//  Created by Nguyen Nhat  Loc on 9/26/17.
//  Copyright © 2017 bktech. All rights reserved.
//
import UIKit
import CoreData

class CoreDataOperations: NSObject {
    var words: [NSManagedObject] = []

    func save(name: String) {
        let managedContext = kAppDelegate.persistentContainer.viewContext

        let entity = NSEntityDescription.entity(forEntityName: "Word", in: managedContext)!
        let word = NSManagedObject(entity: entity, insertInto: managedContext)
        word.setValue(name, forKeyPath: "name")
        words.append(word)
        kAppDelegate.saveContext ()
    }

    func fetchData() -> [NSManagedObject]{
        let managedContext = kAppDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Word")

        do {
            words = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        return words
    }

    func delete(name: String) -> Void {
        let managedContext = kAppDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Word")
    
        let results = try? managedContext.fetch(fetchRequest)
    
        for object in results! {
            if object.value(forKeyPath: "name") as? String == name{
                managedContext.delete(object)
            }
        }
    
        kAppDelegate.saveContext ()
    }
    

//// MARK: Save data
//func saveData() -> Void {
//    let managedObjectContext = getContext()
//    let personData = NSEntityDescription.insertNewObject(forEntityName: "Word", into: managedObjectContext) as! Person
//    personData.name = "Raj"
//    personData.city = "Bikaner"
//
//    do {
//        try managedObjectContext.save()
//        print("saved!")
//    } catch let error as NSError  {
//        print("Could not save \(error), \(error.userInfo)")
//    } catch {
//
//    }
//
//}
//
//// MARK: Fetching Data
//func fetchData() -> Void {
//
//    let moc = getContext()
//    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Person")
//
//    do {
//        let fetchedPerson = try moc.fetch(fetchRequest) as! [Person]
//
//        print(fetchedPerson.count)
//        for object in fetchedPerson {
//            print(object.name!)
//        }
//
//    } catch {
//        fatalError("Failed to fetch employees: \(error)")
//    }
//
//}
//
//
//
//// MARK: Delete Data Records
//
//func deleteRecords() -> Void {
//    let moc = getContext()
//    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Person")
//
//    let result = try? moc.fetch(fetchRequest)
//    let resultData = result as! [Person]
//
//    for object in resultData {
//        moc.delete(object)
//    }
//
//    do {
//        try moc.save()
//        print("saved!")
//    } catch let error as NSError  {
//        print("Could not save \(error), \(error.userInfo)")
//    } catch {
//
//    }
//
//
//
//
//
//}
//
//// MARK: Update Data
//func updateRecords() -> Void {
//    let moc = getContext()
//
//    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Person")
//
//    let result = try? moc.fetch(fetchRequest)
//
//    let resultData = result as! [Person]
//    for object in resultData {
//        object.name! = "\(object.name!) Joshi"
//        print(object.name!)
//    }
//    do{
//        try moc.save()
//        print("saved")
//    }catch let error as NSError {
//        print("Could not save \(error), \(error.userInfo)")
//    }
//
//
//}
//
//// MARK: Get Context
//
//func getContext () -> NSManagedObjectContext {
//    let appDelegate = UIApplication.shared.delegate as! AppDelegate
//    return appDelegate.persistentContainer.viewContext
//}

}
