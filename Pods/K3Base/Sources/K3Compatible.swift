//
//  K3Compatible.swift
//  K3Base
//
//  Created by K3 on 2018/5/21.
//  Copyright © 2018年 K3. All rights reserved.
//

import Foundation

public class K3Base<BaseType> {
    public var base: BaseType
    init(_ base: BaseType) {
        self.base = base
    }
}

public protocol K3BaseCompatible {
    associatedtype K3BaseCompatibleType
    var k3: K3BaseCompatibleType { get }
    static var k3: K3BaseCompatibleType.Type { get }
}

public extension K3BaseCompatible {
    var k3: K3Base<Self> {
        return K3Base(self)
    }

    static var k3: K3Base<Self>.Type {
        return K3Base.self
    }
}
