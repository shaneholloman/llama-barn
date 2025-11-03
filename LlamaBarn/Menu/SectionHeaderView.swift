import AppKit

final class SectionHeaderView: NSView {
  private let label = Typography.makeTertiaryLabel()
  private let container = NSView()

  init(title: String) {
    super.init(frame: .zero)
    translatesAutoresizingMaskIntoConstraints = false
    wantsLayer = true
    setup(title: title)
  }

  required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

  override var intrinsicContentSize: NSSize { NSSize(width: Layout.menuWidth, height: 18) }

  private func setup(title: String) {
    // Accessibility
    setAccessibilityElement(true)
    setAccessibilityRole(.staticText)
    setAccessibilityLabel(title)

    label.stringValue = title

    addSubview(container)
    container.addSubview(label)

    container.pinToSuperview(
      leading: Layout.outerHorizontalPadding,
      trailing: Layout.outerHorizontalPadding
    )
    label.pinToSuperview(
      top: 2,
      leading: Layout.innerHorizontalPadding,
      trailing: Layout.innerHorizontalPadding,
      bottom: 2
    )
  }
}
