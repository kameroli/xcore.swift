//
// Xcore
// Copyright © 2015 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

extension UIFont {
    public enum Trait {
        case normal
        case italic
        case monospace
    }

    public static func systemFont(size: CGFloat, weight: Weight = .regular, trait: Trait = .normal) -> UIFont {
        switch trait {
            case .normal:
                return systemFont(ofSize: size, weight: weight)
            case .italic:
                return italicSystemFont(ofSize: size)
            case .monospace:
                return monospacedDigitSystemFont(ofSize: size, weight: weight)
        }
    }
}

extension UIFont {
    func apply(_ trait: Trait) -> UIFont {
        trait == .monospace ? monospacedDigitFont : self
    }

    /// Returns a font matching the given font descriptor.
    ///
    /// - Parameter traits: The new symbolic traits.
    /// - Returns: The new font matching the given font descriptor.
    public func traits(_ traits: UIFontDescriptor.SymbolicTraits...) -> UIFont? {
        guard let descriptor = fontDescriptor.withSymbolicTraits(UIFontDescriptor.SymbolicTraits(traits)) else {
            return nil
        }

        return UIFont(descriptor: descriptor, size: 0)
    }

    public func bold() -> UIFont? {
        traits(.traitBold)
    }

    public func italic() -> UIFont? {
        traits(.traitItalic)
    }

    public func monospace() -> UIFont? {
        traits(.traitMonoSpace)
    }
}

extension UIFont {
    public var monospacedDigitFont: UIFont {
        let featureSettings = [[
            UIFontDescriptor.FeatureKey.featureIdentifier: kNumberSpacingType,
            UIFontDescriptor.FeatureKey.typeIdentifier: kMonospacedNumbersSelector
        ]]
        let attributes = [UIFontDescriptor.AttributeName.featureSettings: featureSettings]
        let oldDescriptor = fontDescriptor
        let newDescriptor = oldDescriptor.addingAttributes(attributes)
        return UIFont(descriptor: newDescriptor, size: 0)
    }
}

extension UIFont {
    public static func printAvailableFontNames() {
        for family in familyNames {
            let count = fontNames(forFamilyName: family).count
            print("▿ \(family) (\(count) \(count == 1 ? "font" : "fonts"))")

            for name in fontNames(forFamilyName: family) {
                print("  - \(name)")
            }
        }
    }
}

extension UIFont {
    private struct AssociatedKey {
        static var textStyle = "textStyle"
    }

    var _textStyle: UIFont.TextStyle? {
        get { associatedObject(&AssociatedKey.textStyle) }
        set { setAssociatedObject(&AssociatedKey.textStyle, value: newValue) }
    }

    public var textStyle: UIFont.TextStyle? {
        _textStyle ?? fontDescriptor.object(forKey: .textStyle) as? UIFont.TextStyle
    }
}

extension UIFont.TextStyle: CaseIterable {
    public static var allCases: [UIFont.TextStyle] = {
        [
            .largeTitle,
            .title1,
            .title2,
            .title3,
            .headline,
            .subheadline,
            .body,
            .callout,
            .footnote,
            .caption1,
            .caption2
        ]
    }()

    private static var headerStyles: [UIFont.TextStyle] = {
        [
            .largeTitle,
            .title1,
            .title2,
            .title3,
            .headline
        ]
    }()

    public var isTitle: Bool {
        UIFont.TextStyle.headerStyles.contains(self)
    }
}
