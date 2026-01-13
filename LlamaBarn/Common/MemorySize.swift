import Foundation

/// A value type for memory sizes with unit conversions.
/// Uses binary units (1 KB = 1024 bytes) to match Activity Monitor and system tools.
struct MemorySize: Comparable, CustomStringConvertible {
  /// Raw value in bytes
  let bytes: Int64

  // MARK: - Initializers

  init(bytes: Int64) {
    self.bytes = bytes
  }

  static func bytes(_ value: Int64) -> MemorySize {
    MemorySize(bytes: value)
  }

  static func kb(_ value: Double) -> MemorySize {
    MemorySize(bytes: Int64(value * 1_024))
  }

  static func mb(_ value: Double) -> MemorySize {
    MemorySize(bytes: Int64(value * 1_048_576))
  }

  static func gb(_ value: Double) -> MemorySize {
    MemorySize(bytes: Int64(value * 1_073_741_824))
  }

  // MARK: - Conversions

  var kb: Double { Double(bytes) / 1_024 }
  var mb: Double { Double(bytes) / 1_048_576 }
  var gb: Double { Double(bytes) / 1_073_741_824 }

  // MARK: - Arithmetic

  static func + (lhs: MemorySize, rhs: MemorySize) -> MemorySize {
    MemorySize(bytes: lhs.bytes + rhs.bytes)
  }

  static func - (lhs: MemorySize, rhs: MemorySize) -> MemorySize {
    MemorySize(bytes: lhs.bytes - rhs.bytes)
  }

  static func * (lhs: MemorySize, rhs: Double) -> MemorySize {
    MemorySize(bytes: Int64(Double(lhs.bytes) * rhs))
  }

  // MARK: - Comparable

  static func < (lhs: MemorySize, rhs: MemorySize) -> Bool {
    lhs.bytes < rhs.bytes
  }

  // MARK: - CustomStringConvertible

  /// Human-readable format (e.g., "1.5 GB", "256 MB")
  var description: String {
    if gb >= 1 {
      return String(format: "%.1f GB", gb)
    } else if mb >= 1 {
      return String(format: "%.0f MB", mb)
    } else {
      return String(format: "%.0f KB", kb)
    }
  }

  // MARK: - Constants

  static let zero = MemorySize(bytes: 0)
}
