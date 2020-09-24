//
//  CoreData.swift
//  Course3FinalTask
//
//  Created by Aleksey Bardin on 19.09.2020.
//  Copyright © 2020 Bardincom. All rights reserved.
//  swiftlint:disable force_cast

import Foundation
import CoreData

extension CoreDataManager {
  static let shared = CoreDataManager(modelName: Model.name)
}

final class CoreDataManager {
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

  func save() {
    guard getContext().hasChanges else { return }

    do {
      try getContext().save()
    } catch {
      let nserror = error as NSError
      fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
    }
  }

  func save(context: NSManagedObjectContext) {
    guard context.hasChanges else { return }
    context.mergePolicy = NSMergePolicy(merge: .mergeByPropertyObjectTrumpMergePolicyType)

    do {
      try context.save()
    } catch {
      let nserror = error as NSError
      fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
    }
  }

  func createObject<T: NSManagedObject>(from entity: T.Type) -> T {
    let context = getContext()
    let object = NSEntityDescription.insertNewObject(forEntityName: String(describing: entity), into: context) as! T
    return object
  }

  func delete(object: NSManagedObject) {
    let context = getContext()
    context.delete(object)
    save(context: context)
  }

  func fetchData<T: NSManagedObject>(for entity: T.Type) -> [T] {
    let context = getContext()
    let request: NSFetchRequest<T>
    var fetchResult = [T]()
    var timeSortDescriptor = NSSortDescriptor(key: #keyPath(PostOffline.createdTime), ascending: false)

    request = entity.fetchRequest() as! NSFetchRequest<T>

    if T() is UserOffline {
      timeSortDescriptor = NSSortDescriptor(key: #keyPath(UserOffline.id), ascending: true)
    }

    request.sortDescriptors = [timeSortDescriptor]

    do {
      fetchResult = try context.fetch(request)
    } catch {
      debugPrint("Could not fetch: \(error.localizedDescription)")
    }

    return fetchResult
  }
}
