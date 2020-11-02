//
// Xcore
// Copyright © 2020 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

struct Menu: Identifiable {
    let id: UUID
    let title: String
    let subtitle: String?
    let content: () -> AnyView

    init<Content: View>(
        id: UUID = UUID(),
        title: String,
        subtitle: String? = nil,
        content: @autoclosure @escaping () -> Content
    ) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.content = {
            content()
                .navigationTitle(title)
                .eraseToAnyView()
        }
    }
}

// MARK: - CaseIterable

extension Menu: CaseIterable {
    static var allCases: [Self] = [
        separators,
        buttonsUIKit,
        buttons,
        textViewController,
        labelInset
    ]
}

// MARK: - Items

extension Menu {
    static let separators = Self(
        title: "Separators",
        content: WrapUIViewController<SeparatorViewController>()
    )

    static let buttonsUIKit = Self(
        title: "Buttons",
        subtitle: "UIKit",
        content: WrapUIViewController<ButtonsViewController>()
    )

    static let buttons = Self(
        title: "Buttons",
        subtitle: "SwiftUI",
        content: ButtonsView()
    )

    static let textViewController = Self(
        title: "TextViewController",
        content: WrapUIViewController<ExampleTextViewController>()
    )

    static let labelInset = Self(
        title: "Label Inset",
        subtitle: "Label extension to enable \"contentInset\".",
        content: WrapUIViewController<ExampleLabelInsetViewController>()
    )
}
