//
//  SequenceExtention.swift
//  NaviGay
//
//  Created by Dmitry Zasenko on 21.06.23.
//

import Foundation

extension Sequence where Element: Hashable {
    func uniqued() -> [Element] {
        var set = Set<Element>()
        return filter { set.insert($0).inserted }
    }
}
