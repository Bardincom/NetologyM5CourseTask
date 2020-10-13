//
//  CoreData.swift
//  Course3FinalTask
//
//  Created by Aleksey Bardin on 19.09.2020.
//  Copyright © 2020 Bardincom. All rights reserved.
//  swiftlint:disable force_cast

import Foundation
import CoreData

extension CoreDataStack {
    static let shared = CoreDataStack(modelName: Model.name)
}

final class CoreDataStack {
    private let modelName: String

    init(modelName: String) {
        self.modelName = modelName
    }

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: modelName)

        container.loadPersistentStores { (storeDescription, error) in
            print(storeDescription)
            if let error = error as NSError? {
                fatalError()
            }
        }
        return container
    }()

    func getContext() -> NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    func save(context: NSManagedObjectContext) {
        let privateContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        privateContext.parent = context
        guard context.hasChanges else { return }
        context.mergePolicy = NSMergePolicy(merge: .mergeByPropertyObjectTrumpMergePolicyType)
        do {
            try context.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }

    func save() {
        guard getContext().hasChanges else { return }
        let context = getContext()
        context.mergePolicy = NSMergePolicy(merge: .mergeByPropertyObjectTrumpMergePolicyType)

        do {
            try context.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }

    func createObject<T: NSManagedObject>(from entity: T.Type) -> T {
        let context = getContext()
        let object = NSEntityDescription.insertNewObject(forEntityName: String(describing: entity), into: context) as! T
        return object
    }

    func fetchData<T: NSManagedObject>(for entity: T.Type) -> [T] {
        let context = getContext()
        let request: NSFetchRequest<T>
        var fetchResult = [T]()
        var sortDescriptor = NSSortDescriptor(key: #keyPath(PostOffline.createdTime), ascending: false)

        request = entity.fetchRequest() as! NSFetchRequest<T>

        if entity is UserOffline.Type {
            sortDescriptor = NSSortDescriptor(key: #keyPath(UserOffline.fullName), ascending: true)
        }

        request.sortDescriptors = [sortDescriptor]

        do {
            fetchResult = try context.fetch(request)
        } catch {
            debugPrint("Could not fetch: \(error.localizedDescription)")
        }

        return fetchResult
    }
}
