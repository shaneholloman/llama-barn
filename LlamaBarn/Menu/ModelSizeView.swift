import AppKit
import Foundation

/// Displays the model's file size in the expanded model view.
/// Format: "File size  3.5 GB  (show)"
/// This is an informational row with a clickable "(show)" link to reveal in Finder.
final class ModelSizeView: ItemView {
  private let model: CatalogEntry
  private let actionHandler: ModelActionHandler

  private let label = Theme.secondaryLabel()
  private let showButton = NSButton()

  init(model: CatalogEntry, actionHandler: ModelActionHandler) {
    self.model = model
    self.actionHandler = actionHandler
    super.init(frame: .zero)
    setupLayout()
  }

  required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

  // Compact height for info row (matches VariantItemView)
  override var intrinsicContentSize: NSSize { NSSize(width: Layout.menuWidth, height: 16) }

  // Disable hover highlight since this is an info row, not an interactive item
  override var highlightEnabled: Bool { false }

  private func setupLayout() {
    // Indent to align with model text
    let indent = NSView()
    indent.translatesAutoresizingMaskIntoConstraints = false
    indent.widthAnchor.constraint(equalToConstant: Layout.expandedIndent).isActive = true

    // Build attributed string: "File size  3.5 GB"
    // Label is secondary color, value is more prominent
    let result = NSMutableAttributedString()
    let secondaryAttrs = Theme.secondaryAttributes(color: Theme.Colors.textSecondary)
    let valueAttrs = Theme.secondaryAttributes(color: Theme.Colors.modelIconTint)

    result.append(NSAttributedString(string: "File size  ", attributes: secondaryAttrs))
    result.append(NSAttributedString(string: model.totalSize, attributes: valueAttrs))

    label.attributedStringValue = result

    // Show button styled as text link (matches copy button in VariantItemView)
    showButton.isBordered = false
    showButton.title = "(show)"
    showButton.font = Theme.Fonts.secondary
    showButton.contentTintColor = Theme.Colors.textSecondary
    showButton.target = self
    showButton.action = #selector(didClickShow)

    let stack = NSStackView(views: [indent, label, showButton])
    stack.orientation = .horizontal
    stack.alignment = .centerY
    stack.spacing = 0

    contentView.addSubview(stack)
    // Extra top padding to separate from context variant list
    stack.pinToSuperview(top: 4, leading: 0, trailing: 0, bottom: -2)
  }

  @objc private func didClickShow() {
    actionHandler.showInFinder(model: model)
  }
}
