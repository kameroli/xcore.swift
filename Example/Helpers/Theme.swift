//
// Xcore
// Copyright © 2016 Xcore
// MIT license, see LICENSE file for details
//

extension Theme {
    public static func start() {
        set(theme: .current)

        UIButton.defaultAppearance.apply {
            $0.configuration = .callout
            $0.height = AppConstants.uiControlsHeight
            $0.isHeightSetAutomatically = true
            $0.highlightedAnimation = .scale
            $0.configurationAttributes.apply {
                // Styles Updates
                $0[.base].font = .app(style: .body)
                $0[.base].textColor = current.buttonTextColor
                $0[.base].tintColor = current.tintColor

                $0[.callout].textColor = .white
                $0[.callout].backgroundColor = .orange
                $0[.calloutSecondary].backgroundColor = .green
                $0[.pill].backgroundColor = .gray

                // Toggle Styles
                $0[.checkbox].font = .app(style: .caption2)
                $0[.checkbox].tintColor = current.toggleColor
                $0[.radioButton].tintColor = current.toggleColor
            }
        }

        MarkupText.appearance.apply {
            $0.isLabelEnabled = true
            $0.isTextViewEnabled = true
        }

        LabelTextView.appearance().apply {
            $0.font = .app(style: .body)
        }
    }
}
