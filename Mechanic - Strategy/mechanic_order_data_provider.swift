//
//  mechanic_id_provider.swift
//  Mechanic - Strategy
//
//  Created by Reza Shirazian on 2016-04-17.
//  Copyright © 2016 Reza Shirazian. All rights reserved.
//

import Foundation

class MechanicOrderDataProvider {
  static let instace = MechanicOrderDataProvider()
  private var data: [Int:Int]

  private init() {
    data = [Int:Int]()
  }

  func getMechanicIdFromOrderId(orderId: Int) -> Int? {
    return data[orderId]
  }

  func addMechanicOrder(order: Order, mechanic: Mechanic) {
    data[order.orderId] = mechanic.mechanicId
  }
}
