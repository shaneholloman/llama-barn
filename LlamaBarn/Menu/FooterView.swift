import SwiftUI

struct FooterView: View {
  var onCheckForUpdates: () -> Void
  var onOpenSettings: () -> Void
  var onQuit: () -> Void

  var body: some View {
    HStack(spacing: 0) {
      Button(action: onCheckForUpdates) {
        Text(appVersionText)
          .font(Font(Typography.primary))
          .foregroundColor(Color(nsColor: .tertiaryLabelColor))
      }
      .buttonStyle(.plain)

      Text(" · llama.cpp \(AppInfo.llamaCppVersion)")
        .font(Font(Typography.primary))
        .foregroundColor(Color(nsColor: .tertiaryLabelColor))

      Spacer()

      Button("Settings", action: onOpenSettings)
        .font(Font(Typography.secondary))
        .buttonStyle(.bordered)
        .controlSize(.small)
        .keyboardShortcut(",")

      Button("Quit", action: onQuit)
        .font(Font(Typography.secondary))
        .buttonStyle(.bordered)
        .controlSize(.small)
        .padding(.leading, 8)
    }
    .padding(.horizontal, Layout.outerHorizontalPadding + Layout.innerHorizontalPadding)
    .padding(.vertical, 6)
    .frame(width: Layout.menuWidth)
  }

  private var appVersionText: String {
    #if DEBUG
      return "🔨"
    #else
      return AppInfo.shortVersion == "0.0.0"
        ? "build \(AppInfo.buildNumber)"
        : AppInfo.shortVersion
    #endif
  }
}
