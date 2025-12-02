import AppKit
import Foundation

/// Header row showing server status.
final class HeaderView: NSView {

  private unowned let server: LlamaServer
  private let serverStatusLabel = Typography.makeSecondaryLabel()
  private let backgroundView = NSView()

  init(server: LlamaServer) {
    self.server = server
    super.init(frame: .zero)
    translatesAutoresizingMaskIntoConstraints = false
    setup()
    refresh()
  }

  required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

  override var intrinsicContentSize: NSSize { NSSize(width: Layout.menuWidth, height: 40) }

  private func setup() {
    wantsLayer = true
    backgroundView.wantsLayer = true

    serverStatusLabel.allowsEditingTextAttributes = true
    serverStatusLabel.isSelectable = true

    addSubview(backgroundView)
    backgroundView.addSubview(serverStatusLabel)

    backgroundView.pinToSuperview(
      leading: Layout.outerHorizontalPadding,
      trailing: Layout.outerHorizontalPadding
    )
    serverStatusLabel.pinToSuperview(
      top: 6,
      leading: Layout.innerHorizontalPadding,
      trailing: Layout.innerHorizontalPadding,
      bottom: 6
    )
  }

  func refresh() {
    // Update server status based on server state.
    if server.isRunning {
      let host =
        UserSettings.exposeToNetwork ? (LlamaServer.getLocalIpAddress() ?? "0.0.0.0") : "localhost"
      let linkText = "\(host):\(LlamaServer.defaultPort)"
      let full = "Running on \(linkText)"
      let url = URL(string: "http://\(linkText)/")!

      let paragraphStyle = NSMutableParagraphStyle()
      paragraphStyle.lineBreakMode = .byTruncatingTail

      var baseAttributes = Typography.makeSecondaryAttributes(color: Typography.primaryColor)
      baseAttributes[.paragraphStyle] = paragraphStyle

      let attributed = NSMutableAttributedString(string: full, attributes: baseAttributes)

      if let linkRange = full.range(of: linkText) {
        attributed.addAttributes(
          [
            .link: url,
            .foregroundColor: NSColor.linkColor,
            .underlineStyle: NSUnderlineStyle.single.rawValue,
          ],
          range: NSRange(linkRange, in: full)
        )
      }
      serverStatusLabel.attributedStringValue = attributed
      serverStatusLabel.toolTip = "Open llama-server"
    } else {
      serverStatusLabel.attributedStringValue = NSAttributedString(
        string: "Select a model to run",
        attributes: Typography.secondaryAttributes
      )
      serverStatusLabel.toolTip = nil
    }

    needsDisplay = true
  }

}
