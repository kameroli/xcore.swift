//
// Xcore
// Copyright © 2017 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

public enum Currency {}

/*
public struct Currency: Equatable, MutableAppliable {
    public init(_ amount: Double? = nil) {
        self.amount = amount
    }

    /// A property to change the formatting style.
    ///
    /// The default value is `.none`.
    public var style: Components.Style = .none

    /// A property to change the attributes to adjust font sizes.
    ///
    /// The default value is `.body`.
    public var attributes: Components.Attributes = .body

    /// A boolean property to indicate whether the color changes based on the amount
    /// using the `positiveColor` and `negativeColor` properties.
    ///
    /// - Note: If this is `false` then `positiveColor` property's value is used.
    ///
    /// The default value is `false`.
    public var isColored = false

    /// A property to indicate whether the output shows the sign (+/-).
    ///
    /// The default value is `false`.
    public var isSigned = false

    /// The color to use when the amount is positive.
    ///
    /// This value is ignored if the `colored` property is `false`.
    ///
    /// The default value is `.appleGreen`.
    public var positiveColor: UIColor = .appleGreen

    /// The color to use when the amount is negative.
    ///
    /// This value is ignored if the `colored` property is `false`.
    ///
    /// The default value is `.appleBlue`.
    public var negativeColor: UIColor = .appleBlue

    /// The custom color to use when the amount is `0`.
    /// This value is ignored if the `colored` property is `false`.
    ///
    /// The default value is `nil`.
    public var zeroAmountColor: UIColor?

    /// The custom string to use when the amount is `0`.
    /// This value is ignored if the `shouldDisplayZeroAmounts` property is `true`.
    ///
    /// The default value is `--`.
    public var customZeroAmountString: String = "--"

    public var shouldDisplayZeroAmounts = true

    /// A property to indicate whether the cents are rendered as superscript.
    ///
    /// The default value is `true`.
    public var shouldSuperscriptCents = true

    public var accessibilityLabel: String? {
        guard let amount = amount else {
            return nil
        }

        return CurrencyFormatter.shared.string(from: amount, style: format)
    }

    public var amount: Double?

    public func value() -> NSAttributedString? {
        attributedString()?.foregroundColor(foregroundColor)
    }

    private func attributedString() -> NSMutableAttributedString? {
        guard let amount = amount else {
            return nil
        }

        if amount == 0 && !shouldDisplayZeroAmounts {
            return NSMutableAttributedString(string: " " + customZeroAmountString)
        }

        let value = isSigned ? amount : abs(amount) // +/- represented by color

        return CurrencyFormatter.shared.format(
            amount: value,
            attributes: style,
            formattingStyle: format,
            superscriptCents: shouldSuperscriptCents
        )
    }

    private var foregroundColor: UIColor {
        guard isColored, let amount = amount else {
            return positiveColor
        }

        var color: UIColor

        if let zeroAmountColor = zeroAmountColor, amount == 0 {
            color = zeroAmountColor
        } else {
            color = amount >= 0 ? positiveColor : negativeColor
        }

        return color
    }
}

// MARK: - Currency

extension Currency: StringRepresentable {
    public var stringSource: StringSourceType {
        guard let value = value() else {
            return .string("")
        }

        return .attributedString(value)
    }
}
*/
