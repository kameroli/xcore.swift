//
// Xcore
// Copyright © 2019 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

final class SeparatorViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Separators"
        view.backgroundColor = Theme.current.backgroundColor
        setupContentView()
    }

    private func setupContentView() {
        let stackView = UIStackView(arrangedSubviews: [
            createSeparatorsVertical(),
            createSeparatorsHorizontal()
        ]).apply {
            $0.axis = .vertical
            $0.spacing = .maximumPadding
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .maximumPadding),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -.maximumPadding),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func createSeparatorsVertical() -> UIStackView {
        UIStackView(arrangedSubviews: [
            SeparatorView(axis: .vertical),
            SeparatorView(style: .dot, axis: .vertical),
            SeparatorView(axis: .vertical, backgroundColor: .systemRed),
            SeparatorView(axis: .vertical, backgroundColor: .systemPurple),
            SeparatorView(style: .dot, axis: .vertical, backgroundColor: .systemRed),
            SeparatorView(style: .dot, axis: .vertical, backgroundColor: .systemBlue),
            SeparatorView(style: .dash(value: [2, 4]), axis: .vertical, backgroundColor: .systemPurple),
            SeparatorView(axis: .vertical, backgroundColor: .systemBlue, thickness: 4)
        ]).apply {
            $0.axis = .horizontal
            $0.spacing = .maximumPadding
            $0.distribution = .equalSpacing
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.heightAnchor.constraint(equalToConstant: 200).activate()
        }
    }

    private func createSeparatorsHorizontal() -> UIStackView {
        let appliedSeparator = SeparatorView().apply {
            $0.lineCap = .square
            $0.thickness = 10
            $0.style = .dash(value: [1, 15, 10, 20])
        }

        let freeSeparator = SeparatorView(backgroundColor: .systemBlue, automaticallySetThickness: false).apply {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.heightAnchor.constraint(equalToConstant: 12).activate()
        }

        let bigDotsSeparator = SeparatorView(backgroundColor: .systemGreen).apply {
            $0.thickness = 10
            $0.style = .dot
        }

        return UIStackView(arrangedSubviews: [
            SeparatorView(),
            SeparatorView(style: .dot),
            SeparatorView(backgroundColor: .systemRed),
            SeparatorView(backgroundColor: .systemPurple),
            SeparatorView(style: .dot, backgroundColor: .systemRed),
            SeparatorView(style: .dot, backgroundColor: .systemBlue),
            SeparatorView(style: .dash(value: [2, 5]), backgroundColor: .systemPurple),
            SeparatorView(backgroundColor: .systemPurple, thickness: 5),
            SeparatorView(style: .plain, backgroundColor: .systemPurple, thickness: 2),
            SeparatorView(style: .dot, backgroundColor: .systemPurple, thickness: 2),
            appliedSeparator,
            freeSeparator,
            bigDotsSeparator
        ]).apply {
            $0.axis = .vertical
            $0.spacing = .maximumPadding
        }
    }
}
