//
//  Resolver.swift
//  ReqresApp
//
//  Created by AnangNugraha on 07/11/23.
//

import Foundation

protocol Resolver {
    func resolve<Service>(_ serviceType: Service.Type) -> Service
}

extension Resolver {
    func base<Service>(for type: Service.Type) -> () -> Service {
        return {
            self.resolve(type)
        }
    }
}

class Container: Resolver {
   
    let bases: [ServiceBasePool]
    
    init() {
        self.bases = []
    }
    
    private init(bases: [ServiceBasePool]) {
        self.bases = bases
    }
    
    // MARK: - Register
    
    func register<T>(_ baseInterface: T.Type, instance: T) -> Container {
        return register(baseInterface) { _ in instance}
    }
    
    func register<Service>(_ type: Service.Type, _ base: @escaping (Resolver) -> Service) -> Container {
        assert(!bases.contains(where: { $0.types(type) }))
        let newBase = ServiceBase<Service>(type, base: { resolver in
           base(resolver)
        })
        return .init(bases: bases + [ServiceBasePool(newBase)])
    }
    
    // MARK: Resolver
    
    func resolve<Service>(_ type: Service.Type) -> Service {
        guard let base = bases.first(where: { $0.types(type)}) else {
            fatalError("No service base found")
        }
        return base.resolve(self)
    }
    
    func base<Service>(for type: Service.Type) -> () -> Service {
        guard let base = bases.first(where: { $0.types(type) }) else {
            fatalError("No suitable factory found")
        }
        
        return { base.resolve(self) }
    }
}
