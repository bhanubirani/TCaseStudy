//
//  SequenceType+Extensions.swift
//  HarmonyKit
//
//  Copyright (c) 2015 Target. All rights reserved.
//

import Foundation

extension Sequence {
    func detect(_ selectElement: (Iterator.Element) -> Bool) -> Iterator.Element? {
        for element in self {
            if selectElement(element) {
                return element
            }
        }
        return nil
    }
}
