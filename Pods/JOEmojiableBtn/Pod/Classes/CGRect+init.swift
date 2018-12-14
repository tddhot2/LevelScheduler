//
//  CGRect+init.swift
//  JOEmojiableBtn
//
//  Created by Jorge R Ovalle Z on 4/7/18.
//

import Foundation

extension CGRect {

    /// Creates an instance of `CGRect` with the same width and height.
    ///
    /// - Parameters:
    ///   - x: Position in `x` coordinate.
    ///   - y: Position in `y` coordinate.
    ///   - sideSize: Size of the rect side.
    init(x: CGFloat, y: CGFloat, sideSize: CGFloat) {
        self.init(origin: CGPoint(x: x, y: y), size: CGSize(sideSize: sideSize))
    }
}
