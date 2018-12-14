//
//  JOEmojiableBtnDelegate.swift
//  JOEmojiableBtn
//
//  Created by Jorge R Ovalle Z on 4/11/18.
//

import Foundation

/// Describes a type that is informed of events occurring within a `JOEmojiableBtn`.
public protocol JOEmojiableDelegate: class {

    /// The user selected an option from the sender.
    ///
    /// - Parameters:
    ///   - sender: The `JOEmojiableBtn` which is sending the action.
    ///   - index: Index of the selected option.
    func selectedOption(_ sender: JOEmojiableBtn, index: Int)

    /// The user cancelled the option selection.
    ///
    /// - Parameter sender: The `JOEmojiableBtn` which is sending the action.
    func cancelledAction(_ sender: JOEmojiableBtn)
}
