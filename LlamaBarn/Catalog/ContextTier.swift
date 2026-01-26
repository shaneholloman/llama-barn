import Foundation

/// Represents a context length tier for running models.
/// The available tiers are determined by user settings.
enum ContextTier: Int, CaseIterable, Identifiable, Comparable {
  case k4 = 4096
  case k8 = 8192
  case k16 = 16384
  case k32 = 32768
  case k64 = 65536
  case k128 = 131072
  case k256 = 262144

  var id: Int { rawValue }

  var label: String {
    switch self {
    case .k4: return "4k"
    case .k8: return "8k"
    case .k16: return "16k"
    case .k32: return "32k"
    case .k64: return "64k"
    case .k128: return "128k"
    case .k256: return "256k"
    }
  }

  var suffix: String {
    "-\(label)"
  }

  static func < (lhs: ContextTier, rhs: ContextTier) -> Bool {
    lhs.rawValue < rhs.rawValue
  }

  /// Returns only the context tiers that are enabled in user settings.
  /// Always includes at least 4k as the minimum required tier.
  static var enabledCases: [ContextTier] {
    let enabledRawValues = UserSettings.enabledContextTiers
    return allCases.filter { enabledRawValues.contains($0.rawValue) }
  }
}
