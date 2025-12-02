import AppKit

final class DividerWithActionView: NSView {
  private let line = NSBox()
  private let button = HoverButton()
  private let onToggle: () -> Void

  init(onToggle: @escaping () -> Void) {
    self.onToggle = onToggle
    super.init(frame: .zero)
    translatesAutoresizingMaskIntoConstraints = false
    setup()
    refresh()
  }

  required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

  override var intrinsicContentSize: NSSize {
    NSSize(width: Layout.menuWidth, height: 16)
  }

  private func setup() {
    // Line
    line.boxType = .separator
    line.translatesAutoresizingMaskIntoConstraints = false
    addSubview(line)

    // Button
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setButtonType(.toggle)
    button.toolTip = "Show quantized models"
    button.target = self
    button.action = #selector(buttonClicked)

    // Use a system symbol that represents "compressed" or "options"
    // "arrow.up.left.and.arrow.down.right" is compress
    // "square.stack.3d.up" is models
    // Let's use a filter-like icon or just a generic one.
    // Given the context, maybe it was a custom icon or a system one.
    // I'll use 'line.3.horizontal.decrease' (filter) as it filters/unfilters models.
    // Or 'square.stack.3d.down.right'
    let image = NSImage(
      systemSymbolName: "square.stack.3d.down.right",
      accessibilityDescription: "Show quantized models")
    button.image = image
    button.image?.isTemplate = true

    addSubview(button)

    NSLayoutConstraint.activate([
      // Button on the right
      button.trailingAnchor.constraint(
        equalTo: trailingAnchor, constant: -Layout.outerHorizontalPadding),
      button.centerYAnchor.constraint(equalTo: centerYAnchor),
      button.widthAnchor.constraint(equalToConstant: 18),
      button.heightAnchor.constraint(equalToConstant: 16),

      // Line takes remaining space
      line.leadingAnchor.constraint(
        equalTo: leadingAnchor,
        constant: Layout.outerHorizontalPadding + Layout.innerHorizontalPadding),
      line.trailingAnchor.constraint(equalTo: button.leadingAnchor, constant: -8),
      line.centerYAnchor.constraint(equalTo: centerYAnchor),
    ])
  }

  @objc private func buttonClicked() {
    onToggle()
    refresh()
  }

  func refresh() {
    button.state = UserSettings.showQuantizedModels ? .on : .off
    // Update tint color based on state if needed
    button.contentTintColor = button.state == .on ? .controlAccentColor : .secondaryLabelColor
  }
}

private class HoverButton: NSButton {
  override init(frame frameRect: NSRect) {
    super.init(frame: frameRect)
    isBordered = false
    title = ""
    imagePosition = .imageOnly
  }

  required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
