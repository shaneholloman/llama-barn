import AppKit
import Foundation

/// Header row showing server status.
final class HeaderView: NSView {

  private unowned let server: LlamaServer
  private let stackView = NSStackView()
  private let statusLabel = Typography.makeSecondaryLabel()
  private let linkButton = NSButton()
  private let backgroundView = NSView()

  private var currentUrl: URL?

  init(server: LlamaServer) {
    self.server = server
    super.init(frame: .zero)
    translatesAutoresizingMaskIntoConstraints = false
    setup()
    refresh()
  }

  required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

  private func setup() {
    wantsLayer = true
    backgroundView.wantsLayer = true

    widthAnchor.constraint(equalToConstant: Layout.menuWidth).isActive = true

    addSubview(backgroundView)
    backgroundView.addSubview(stackView)

    backgroundView.pinToSuperview(
      leading: Layout.outerHorizontalPadding,
      trailing: Layout.outerHorizontalPadding
    )

    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.pinToSuperview(
      top: 6,
      leading: Layout.innerHorizontalPadding,
      trailing: Layout.innerHorizontalPadding,
      bottom: 6
    )

    stackView.orientation = .horizontal
    stackView.spacing = 0
    stackView.alignment = .firstBaseline
    stackView.distribution = .fill

    // Link Button Configuration
    linkButton.isBordered = false
    linkButton.setButtonType(.momentaryChange)
    linkButton.imagePosition = .noImage
    linkButton.target = self
    linkButton.action = #selector(openLink)

    stackView.addArrangedSubview(statusLabel)
    stackView.addArrangedSubview(linkButton)

    // Spacer
    let spacer = NSView()
    spacer.setContentHuggingPriority(.init(1), for: .horizontal)
    stackView.addArrangedSubview(spacer)
  }

  func refresh() {
    // Update server status based on server state.
    if server.isRunning {
      let host =
        UserSettings.exposeToNetwork ? (LlamaServer.getLocalIpAddress() ?? "0.0.0.0") : "localhost"
      let linkText = "\(host):\(LlamaServer.defaultPort)"
      let url = URL(string: "http://\(linkText)/")!

      self.currentUrl = url

      statusLabel.stringValue = "Running on "
      statusLabel.textColor = Typography.secondaryColor

      let attrTitle = NSAttributedString(
        string: linkText,
        attributes: [
          .foregroundColor: NSColor.linkColor,
          .font: Typography.secondary,
          .underlineStyle: NSUnderlineStyle.single.rawValue,
        ]
      )
      linkButton.attributedTitle = attrTitle
      linkButton.isHidden = false
    } else {
      statusLabel.stringValue = "Select a model to run"
      statusLabel.textColor = Typography.secondaryColor
      linkButton.isHidden = true
      linkButton.toolTip = nil
      currentUrl = nil
    }

    needsDisplay = true
  }

  @objc private func openLink() {
    if let url = currentUrl {
      NSWorkspace.shared.open(url)
    }
  }

}
