//
//  Created with ♥ by BanklessDAO contributors on 2021-09-30.
//  Copyright (C) 2021 BanklessDAO.

//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU Affero General Public License as
//  published by the Free Software Foundation, either version 3 of the
//  License, or (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU Affero General Public License for more details.
//
//  You should have received a copy of the GNU Affero General Public License
//  along with this program.  If not, see https://www.gnu.org/licenses/.
//
    

import Foundation

class SimpleDependencyContainer: DependencyContainer {
    typealias ProtocolResolver = (Any) -> Void
    typealias TypeResolver = () -> Any
    
    private let parentContainer: DependencyContainer?
    private var protocolResolvers: [ProtocolResolver] = []
    private var typeResolvers: [String: TypeResolver] = [:]
    
    init(parentContainer: DependencyContainer? = nil) {
        self.parentContainer = parentContainer
    }
    
    private func register(_ resolver: @escaping ProtocolResolver) {
        protocolResolvers.append(resolver)
    }
    
    private func key<T>(_ type: T.Type) -> String {
        String(reflecting: type)
    }
    
    func register<T>(_ resolver: @escaping (inout T) -> Void) {
        register { object in
            guard var object = object as? T else { return }
            
            resolver(&object)
        }
    }
    
    func register<T>(_ resolver: @escaping () -> T) {
        typeResolvers[key(T.self)] = resolver
    }
    
    func resolve(_ object: Any?) {
        guard let object = object else { return }
        
        parentContainer?.resolve(object)
        
        protocolResolvers.forEach { resolver in
            resolver(object)
        }
    }
    
    func resolve<T>() -> T? {
        typeResolvers[key(T.self)]?() as? T ?? parentContainer?.resolve()
    }
}
