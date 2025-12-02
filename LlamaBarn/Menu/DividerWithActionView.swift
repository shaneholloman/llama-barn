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

    updateButtonState()
  }

  @objc private func buttonClicked() {
    onToggle()
    updateButtonState()
  }

  private func updateButtonState() {
    button.state = UserSettings.showQuantizedModels ? .on : .off

    let color =
      UserSettings.showQuantizedModels ? Typography.primaryColor : Typography.secondaryColor
    button.attributedTitle = NSAttributedString(
      string: "Q",
      attributes: [
        .font: Typography.secondary,
        .foregroundColor: color,
      ]
    )
  }

  private class HoverButton: NSButton {
    private var trackingArea: NSTrackingArea?
    var isHovered = false { didSet { needsDisplay = true } }

    override init(frame frameRect: NSRect) {
      super.init(frame: frameRect)
      isBordered = false
      wantsLayer = true
      focusRingType = .none
      (cell as? NSButtonCell)?.highlightsBy = .contentsCellMask
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func updateTrackingAreas() {
      super.updateTrackingAreas()
      if let trackingArea = trackingArea { removeTrackingArea(trackingArea) }
      trackingArea = NSTrackingArea(
        rect: bounds,
        options: [.mouseEnteredAndExited, .activeAlways],
        owner: self,
        userInfo: nil
      )
      addTrackingArea(trackingArea!)
    }

    override func mouseEntered(with event: NSEvent) { isHovered = true }
    override func mouseExited(with event: NSEvent) { isHovered = false }

    override func draw(_ dirtyRect: NSRect) {
      if isHovered || state == .on {
        let color: NSColor =
          state == .on ? .tertiaryLabelColor.withAlphaComponent(0.25) : .quaternaryLabelColor
        color.setFill()
        let path = NSBezierPath(roundedRect: bounds, xRadius: 3, yRadius: 3)
        path.fill()
      }
      super.draw(dirtyRect)
    }
  }
}
