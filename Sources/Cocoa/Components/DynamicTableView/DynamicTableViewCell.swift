//
// Xcore
// Copyright © 2016 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

open class DynamicTableViewCell: XCTableViewCell {
    private var data: DynamicTableModel!
    private var imageAndTitleSpacingConstraint: NSLayoutConstraint?
    private var contentConstraints: NSLayoutConstraint.Edges!
    private var imageSizeConstraints: NSLayoutConstraint.Size!
    private var minimumContentHeightConstraint: NSLayoutConstraint?
    private var labelsStackViewConstraints: (top: NSLayoutConstraint?, bottom: NSLayoutConstraint?)

    /// The distance that the view is inset from the enclosing content view.
    ///
    /// The default value is `UIEdgeInsets(top: 14, left: 15, bottom: 15, right: 15)`.
    @objc open dynamic var contentInset = UIEdgeInsets(top: 14, left: 15, bottom: 15, right: 15) {
        didSet {
            contentConstraints.update(from: contentInset)

            // Update stack view constraints
            labelsStackViewConstraints.top?.constant = contentInset.top
            labelsStackViewConstraints.bottom?.constant = contentInset.bottom
        }
    }

    /// The default value is `44`.
    @objc open dynamic var minimumContentHeight: CGFloat = 44 {
        didSet {
            minimumContentHeightConstraint?.constant = minimumContentHeight
        }
    }

    /// The default size is `55`.
    @objc open dynamic var imageSize: CGSize = 55 {
        didSet {
            updateImageSizeIfNeeded()
        }
    }

    /// The space between image and text.
    ///
    /// The default value is `.minimumPadding`.
    @objc open dynamic var textImageSpacing: CGFloat = .minimumPadding {
        didSet {
            updateTextImageSpacingIfNeeded()
        }
    }

    /// The space between `title` and `subtitle` labels.
    ///
    /// The default value is `.minimumPadding / 2`.
    @objc open dynamic var interLabelSpacing: CGFloat {
        get { labelsStackView.spacing }
        set { labelsStackView.spacing = newValue }
    }

    /// The default value is `false`.
    @objc open dynamic var isImageViewHidden: Bool = false {
        didSet {
            guard oldValue != isImageViewHidden else { return }
            avatarView.isHidden = isImageViewHidden
            updateImageSizeIfNeeded()
            updateTextImageSpacingIfNeeded()
        }
    }

    /// The default value is `false`.
    @objc open dynamic var isSubtitleLabelHidden: Bool = false {
        didSet {
            guard oldValue != isSubtitleLabelHidden else { return }
            if isSubtitleLabelHidden {
                labelsStackView.removeArrangedSubview(subtitleLabel)
                subtitleLabel.removeFromSuperview()
            } else {
                labelsStackView.addArrangedSubview(subtitleLabel)
            }
        }
    }

    /// The default value is `true`.
    @objc open dynamic var isImageViewRounded = true {
        didSet {
            roundAvatarViewCornersIfNeeded()
        }
    }

    // MARK: - Subviews

    private lazy var labelsStackView = UIStackView(arrangedSubviews: [
        titleLabel,
        subtitleLabel
    ]).apply {
        $0.axis = .vertical
        $0.spacing = .minimumPadding / 2
    }

    public let avatarView = UIImageView().apply {
        $0.isContentModeAutomaticallyAdjusted = true
        $0.clipsToBounds = true
        $0.tintColor = .appTint
        $0.enableSmoothScaling()

        // Border
        $0.layer.masksToBounds = true
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.black.alpha(0.08).cgColor
    }

    public let titleLabel = UILabel().apply {
        $0.font = .app(style: .body)
        $0.textColor = Theme.current.textColor
        $0.numberOfLines = 0
    }

    public let subtitleLabel = UILabel().apply {
        $0.font = .app(style: .subheadline)
        $0.textColor = Theme.current.textColorSecondary
        $0.numberOfLines = 0
    }

    open override func prepareForReuse() {
        super.prepareForReuse()
        separatorInset = 0
    }

    /// The default implementation of this method does nothing.
    ///
    /// Subclasses can override it to perform additional actions, This method is
    /// called when `UITableView` invokes
    /// `tableView:willDisplayCell:forRowAtIndexPath:` delegate method.
    open func cellWillAppear(_ indexPath: IndexPath, data: DynamicTableModel) {}

    // MARK: - Setup Methods

    open override func commonInit() {
        clipsToBounds = true
        backgroundColor = .clear
        separatorInset = UIEdgeInsets(left: .defaultPadding)
        contentView.addSubview(avatarView)
        contentView.addSubview(labelsStackView)
        roundAvatarViewCornersIfNeeded()
        setupConstraints()
    }

    private func setupConstraints() {
        avatarView.translatesAutoresizingMaskIntoConstraints = false
        labelsStackView.translatesAutoresizingMaskIntoConstraints = false

        // Constraints for Labels Stack View
        labelsStackView.anchor.make {
            $0.vertically.greaterThanOrEqualToSuperview().inset(contentInset).priority(.stackViewSubview)
            $0.centerY.equalToSuperview()
        }

        imageSizeConstraints = NSLayoutConstraint.Size(avatarView.anchor.size.equalTo(imageSize).constraints)

        // Avatar Center
        avatarView.anchor.make {
            $0.centerY.equalToSuperview()
        }

        imageAndTitleSpacingConstraint = labelsStackView.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: textImageSpacing).activate()

        // Content Constraints
        contentConstraints = NSLayoutConstraint.Edges(
            top: avatarView.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor, constant: contentInset.top).priority(.defaultHigh).activate(),
            bottom: contentView.bottomAnchor.constraint(greaterThanOrEqualTo: avatarView.bottomAnchor, constant: contentInset.bottom).priority(.defaultHigh).activate(),
            leading: avatarView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: contentInset.left).activate(),
            trailing: contentView.trailingAnchor.constraint(equalTo: labelsStackView.trailingAnchor, constant: contentInset.right).activate()
        )

        minimumContentHeightConstraint = NSLayoutConstraint(item: contentView, height: minimumContentHeight, priority: .defaultLow).activate()
    }

    // MARK: - Hooks

    private var onHighlight: ((_ highlighted: Bool, _ animated: Bool) -> Void)?
    open func onHighlight(_ callback: @escaping (_ highlighted: Bool, _ animated: Bool) -> Void) {
        onHighlight = callback
    }

    private var onSelect: ((_ selected: Bool, _ animated: Bool) -> Void)?
    open func onSelect(_ callback: @escaping (_ selected: Bool, _ animated: Bool) -> Void) {
        onSelect = callback
    }

    open override func setSelected(_ selected: Bool, animated: Bool) {
        onSelect?(selected, animated)
    }

    open override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        onHighlight?(highlighted, animated)
    }

    // MARK: - StateMask

    private var willTransitionToState: ((_ state: StateMask) -> Void)?
    @nonobjc open func willTransitionToState(_ callback: @escaping (_ state: StateMask) -> Void) {
        willTransitionToState = callback
    }

    open override func willTransition(to state: StateMask) {
        super.willTransition(to: state)
        willTransitionToState?(state)
    }

    private var didTransitionToState: ((_ state: StateMask) -> Void)?
    @nonobjc open func didTransitionToState(_ callback: @escaping (_ state: StateMask) -> Void) {
        didTransitionToState = callback
    }

    open override func didTransition(to state: StateMask) {
        super.didTransition(to: state)
        didTransitionToState?(state)
    }
}

// MARK: - Helpers

extension DynamicTableViewCell {
    private func updateImageSizeIfNeeded() {
        let size = isImageViewHidden ? .zero : imageSize
        imageSizeConstraints.update(from: size)
        roundAvatarViewCornersIfNeeded()
    }

    private func updateTextImageSpacingIfNeeded() {
        let spacing = isImageViewHidden ? 0 : textImageSpacing
        imageAndTitleSpacingConstraint?.constant = spacing
    }

    private func roundAvatarViewCornersIfNeeded() {
        avatarView.layer.cornerRadius = isImageViewRounded ? imageSize.height / 2 : 0
    }
}

// MARK: - Setters

extension DynamicTableViewCell {
    open func configure(_ data: DynamicTableModel) {
        self.data = data
        isImageViewHidden = data.image == nil
        isSubtitleLabelHidden = data.subtitle == nil
        titleLabel.setText(data.title)
        subtitleLabel.setText(data.subtitle)
        avatarView.setImage(data.image)
    }
}

// MARK: - UIAppearance Properties

extension DynamicTableViewCell {
    @objc public dynamic var avatarBorderColor: UIColor? {
        get {
            guard let borderColor = avatarView.layer.borderColor else {
                return nil
            }

            return UIColor(cgColor: borderColor)
        }
        set { avatarView.layer.borderColor = newValue?.cgColor }
    }

    @objc public dynamic var avatarBorderWidth: CGFloat {
        get { avatarView.layer.borderWidth }
        set { avatarView.layer.borderWidth = newValue }
    }

    @objc public dynamic var avatarCornerRadius: CGFloat {
        get { avatarView.layer.cornerRadius }
        set { avatarView.layer.cornerRadius = newValue }
    }

    @objc public dynamic var titleTextColor: UIColor {
        get { titleLabel.textColor }
        set { titleLabel.textColor = newValue }
    }

    @objc public dynamic var titleFont: UIFont {
        get { titleLabel.font }
        set { titleLabel.font = newValue }
    }

    @objc public dynamic var subtitleTextColor: UIColor {
        get { subtitleLabel.textColor }
        set { subtitleLabel.textColor = newValue }
    }

    @objc public dynamic var subtitleFont: UIFont {
        get { subtitleLabel.font }
        set { subtitleLabel.font = newValue }
    }
}
