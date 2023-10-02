//
//  UserProfileHelper.swift
//  Medbook
//
//  Created by Kamal Negi on 02/10/23.
//

import CoreData

internal struct UserProfileHelper {
    static let shared = UserProfileHelper()

    let persistantContainer: NSPersistentContainer = {

        let container = NSPersistentContainer(name: "MedBook")
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error {
                fatalError("Loading of store failed \(error)")
            }
        }
        return container
    }()

    @discardableResult
    func createUserDetails(email: String?, password: String?) {
        let context = persistantContainer.viewContext

        guard let email = email, let password = password else {
            return
        }

        let userDetails = Userdetails(context: context)
        userDetails.email = email
        userDetails.password = password
        
        do {
            try context.save()
            print(userDetails)
        } catch let createError {
            print("Failed to create: \(createError)")
        }
    }

    func fetchUserDetails() -> [[String:AnyObject]]? {
        let context = persistantContainer.viewContext

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Userdetails")
        fetchRequest.propertiesToFetch = ["email","password"]
        fetchRequest.returnsDistinctResults = true
        fetchRequest.resultType = .dictionaryResultType
        do {
            let details = try context.fetch(fetchRequest) as? [[String:AnyObject]]
            return details
        } catch let error {
            print("Error in fetching: \(error)")
        }
        return nil
    }
}
