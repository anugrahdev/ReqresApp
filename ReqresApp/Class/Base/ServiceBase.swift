//
//  ServiceBase.swift
//  ReqresApp
//
//  Created by AnangNugraha on 07/11/23.
//

import Foundation

protocol ServiceBaseProtocol {
    associatedtype Service
    func resolve(_ resolver: Resolver) -> Service
}

extension ServiceBaseProtocol {
    
    func type<T>(_ type: T.Type) -> Bool {
        return type == Service.self
    }
    
}

class ServiceBase<Service>: ServiceBaseProtocol {
    
    private let base: (Resolver) -> Service
    
    init(_ serviceType: Service.Type, base: @escaping (Resolver) -> Service) {
        self.base = base
    }
    
    func resolve(_ resolver: Resolver) -> Service {
        return base(resolver)
    }
    
}

final class ServiceBasePool {
    
    private let resolve: (Resolver) -> Any
    private let types: (Any.Type) -> Bool
    
    init<T: ServiceBaseProtocol>(_ serviceBase: T) {
        self.resolve = { resolver -> Any in
            serviceBase.resolve(resolver)
        }
        self.types = { $0 == T.Service.self}
    }
    
    func resolve<Service>(_ resolver: Resolver) -> Service {
        return self.resolve(resolver) as! Service
    }
    
    func types<Service>(_ type: Service.Type) -> Bool {
        return self.types(type)
    }
    
}
