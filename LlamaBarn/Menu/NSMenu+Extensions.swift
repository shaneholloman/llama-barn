import AppKit

extension NSMenu {
  /// Returns the index of the first separator item, or nil if none exists.
  var indexOfFirstSeparator: Int? {
    items.firstIndex { $0.isSeparatorItem }
  }

  /// Returns the index of the last separator item, or nil if none exists.
  var indexOfLastSeparator: Int? {
    items.lastIndex { $0.isSeparatorItem }
  }

  /// Inserts a list of items starting at the specified index.
  func insertItems(_ newItems: [NSMenuItem], at index: Int) {
    var insertIndex = index
    for item in newItems {
      insertItem(item, at: insertIndex)
      insertIndex += 1
    }
  }

  /// Replaces all items after the given anchor item until the next separator or end of menu.
  /// - Parameters:
  ///   - anchor: The item after which replacement begins.
  ///   - newItems: The new items to insert.
  func replaceItems(after anchor: NSMenuItem, with newItems: [NSMenuItem]) {
    guard let anchorIndex = items.firstIndex(of: anchor) else { return }

    // Remove existing items after anchor until next separator
    let startIndex = anchorIndex + 1
    while startIndex < items.count {
      let item = items[startIndex]
      if item.isSeparatorItem { break }
      removeItem(at: startIndex)
    }

    // Insert new items
    insertItems(newItems, at: startIndex)
  }
}
