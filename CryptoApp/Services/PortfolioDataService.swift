//
//  PortfolioDataService.swift
//  CryptoApp
//
//  Created by Habibur Rahman on 15/1/24.
//

import Foundation
import CoreData

class PortfolioDataService {
    private let container : NSPersistentContainer
    private let containerName : String = "PortfolioContainer"
    private let portfolioEntityName : String = "PortfolioEntity"
    
    @Published var savedEntities : [PortfolioEntity] = []
    
    init() {
        container = NSPersistentContainer(name: containerName)
        container.loadPersistentStores { (_,error ) in
            if let error = error {
                print("Error Loading core data \(error.localizedDescription)")
            }
            self.getPortfolio()
        }
    }
    
    
    func updatePortfolio(coin : CoinModel, amount : Double){
       
        if let entity = savedEntities.first(where: { $0.coinId == coin.id }){
            
            if amount > 0 {
                update(entity: entity, amount: amount)
            }else
            {
                delete(entity: entity)
            }
        }else{
            add(coin: coin, amount: amount)
        }
        
       
    }
    
    private func getPortfolio(){
        let request = NSFetchRequest<PortfolioEntity>(entityName: portfolioEntityName)
        
        do{
           savedEntities = try container.viewContext.fetch(request)
        }catch{
            print("Error fetching Portfolio entity \(error.localizedDescription)")
        }
    }
    
    private func add(coin : CoinModel, amount : Double){
        let entity = PortfolioEntity(context: container.viewContext)
        entity.coinId = coin.id
        entity.amount = amount
        applyChanges()
    }
    
    private func update(entity : PortfolioEntity, amount : Double){
        entity.amount = amount
        applyChanges()
    }
    
    private func delete(entity : PortfolioEntity){
        container.viewContext.delete(entity)
        applyChanges()
    }
   
    private func applyChanges(){
        save()
        getPortfolio()
    }
    
    private func save (){
        do{
            try container.viewContext.save()
        }catch{
            print("Error saving core data \(error)")
        }
    }
    
    
}
