//
// Xcore
// Copyright © 2019 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

/// A wrapper type to encode information for any `ImageRepresentable` with list
/// of plugins.
///
/// It enables a simple way to encode plugins with any `ImageRepresentable`
/// instance and query them anytime in a type safe way.
///
/// **For example**:
///
/// ```swift
/// func setIcon(_ icon: ImageRepresentable) {
///     let newIcon = icon
///         .alignment(.leading)
///         .transform(.tintColor(.white))
///         .alignment(.trailing) // last one wins when using plugin.
///
///     let iconView = UIImageView()
///     iconView.setImage(newIcon)
///
///     let transform: ImageTransform = newIcon.plugin()!
///     print(transform.id)
///     // "TintColorImageTransform-tintColor:(#FFFFFF)"
///
///     let alignment: ImageRepresentableAlignment = newIcon.plugin()!
///     print(alignment)
///     // "trailing"
/// }
/// ```
struct PluginImage: ImageRepresentable {
    private let base: ImageRepresentable
    private var plugins: [ImageRepresentablePlugin]

    init() {
        self.base = ""
        self.plugins = []
    }

    init(_ base: ImageRepresentable, plugins: [ImageRepresentablePlugin]) {
        self.base = base
        self.plugins = plugins
    }

    /// Adds a new plugin at the end of the collection.
    mutating func add(_ plugin: ImageRepresentablePlugin) {
        plugins.append(plugin)
    }

    /// Removes the given plugin.
    mutating func remove(_ plugin: ImageRepresentablePlugin) {
        let ids = plugins.map { $0.id }

        guard let index = ids.firstIndex(of: plugin.id) else {
            return
        }

        plugins.remove(at: index)
    }
}

// MARK: - ImageRepresentable

extension PluginImage {
    var imageSource: ImageSourceType {
        base.imageSource
    }

    var bundle: Bundle {
        base.bundle
    }
}

// MARK: - Collection

extension PluginImage: MutableCollection, RangeReplaceableCollection, BidirectionalCollection {
    var startIndex: Int {
        0
    }

    var endIndex: Int {
        plugins.count
    }

    subscript(index: Int) -> ImageRepresentablePlugin {
        get { plugins[index] }
        set { plugins[index] = newValue }
    }

    /// Returns the position immediately after the given index.
    ///
    /// - Parameter i: A valid index of the collection. `i` must be less than
    /// `endIndex`.
    /// - Returns: The index value immediately after `i`.
    func index(after i: Int) -> Int {
        i + 1
    }

    /// Returns the position immediately before the given index.
    ///
    /// - Parameter i: A valid index of the collection. `i` must be greater than
    ///   `startIndex`.
    /// - Returns: The index value immediately before `i`.
    func index(before i: Int) -> Int {
        i - 1
    }

    func makeIterator() -> ArrayIterator<ImageRepresentablePlugin> {
        .init(plugins)
    }

    mutating func replaceSubrange<C: Collection>(_ subRange: Range<Int>, with newElements: C) where C.Iterator.Element == Element {
        plugins.replaceSubrange(subRange, with: newElements)
    }
}
