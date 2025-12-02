import SwiftUI

struct FooterButtonStyle: ButtonStyle {
  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .font(Font(Typography.secondary))
      // fixes: inverse color on mouse down
      .foregroundColor(Color(nsColor: .tertiaryLabelColor))
      .padding(.horizontal, 5)
      .padding(.vertical, 2)
      .background(
        RoundedRectangle(cornerRadius: 5)
          .fill(configuration.isPressed ? Color(nsColor: .lbSubtleBackground) : Color.clear)
      )
      .overlay(
        RoundedRectangle(cornerRadius: 5)
          .stroke(Color(nsColor: .separatorColor), lineWidth: 1)
      )
      .controlSize(.small)
  }
}

struct FooterView: View {
  var onCheckForUpdates: () -> Void
  var onOpenSettings: () -> Void
  var onQuit: () -> Void

  var body: some View {
    HStack(spacing: 0) {
      Button(action: onCheckForUpdates) {
        Text(appVersionText)
          .font(Font(Typography.secondary))
          .foregroundColor(Color(nsColor: .secondaryLabelColor))
      }
      .buttonStyle(.plain)

      Text(" · llama.cpp \(AppInfo.llamaCppVersion)")
        .font(Font(Typography.secondary))
        .foregroundColor(Color(nsColor: .tertiaryLabelColor))

      Spacer()

      Button("Settings", action: onOpenSettings)
        .buttonStyle(FooterButtonStyle())

      Button("Quit", action: onQuit)
        .buttonStyle(FooterButtonStyle())
        .padding(.leading, 5)
    }
    .padding(.horizontal, Layout.outerHorizontalPadding + Layout.innerHorizontalPadding)
    .padding(.vertical, 6)
    .frame(width: Layout.menuWidth)
  }

  private var appVersionText: String {
    #if DEBUG
      return "dev"
    #else
      return AppInfo.shortVersion == "0.0.0"
        ? "build \(AppInfo.buildNumber)"
        : AppInfo.shortVersion
    #endif
  }
}
