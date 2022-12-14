import CoreData
import Foundation

struct StorageProvider {
    let persistentContainer: NSPersistentContainer

    static let shared = StorageProvider()

    private init() {
        persistentContainer = NSPersistentContainer(name: "BeerPunk")

        persistentContainer.loadPersistentStores { description, error in
            if let error {
                fatalError(error.localizedDescription)
            }
        }
    }
}

extension StorageProvider {
    func beerIsFavorite(beer: Beer) -> Bool{
        beer.id % 2 == 0
//        don't look at me ...
//        let fetchRequest = Beer.fetchRequest()
//        let predicate = NSPredicate(format: "id == %i", beer.id)
//        fetchRequest.predicate = predicate
//        do {
//            let result = try persistentContainer.viewContext.fetch(fetchRequest)
//            return result.count == 1
//        }
//        catch {
//            // Todo: Handle me :)
//            print(error)
//            return false
//        }
    }
}
