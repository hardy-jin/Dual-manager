//
//  workItem.swift
//  Dual
//
//  Created by Khoi Nguyen on 4/25/21.
//

import Foundation
import UIKit

class workItem {

private var pendingRequestWorkItem: DispatchWorkItem?

func perform(after: TimeInterval, _ block: @escaping () -> Void) {
    // Cancel the currently pending item
    pendingRequestWorkItem?.cancel()

    // Wrap our request in a work item
    let requestWorkItem = DispatchWorkItem(block: block)

    pendingRequestWorkItem = requestWorkItem

    DispatchQueue.main.asyncAfter(deadline: .now() + after, execute: requestWorkItem)
}
}
