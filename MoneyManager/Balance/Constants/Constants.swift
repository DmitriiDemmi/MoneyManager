import SwiftUI

extension Font {
    static let p12: Font = .system(size: 12, weight: .regular)
    static let p12s: Font = .system(size: 12, weight: .semibold)
    static let p15: Font = .system(size: 15, weight: .regular)
    static let p15s: Font = .system(size: 15, weight: .semibold)
    static let p17: Font = .system(size: 17, weight: .regular)
    static let p17s: Font = .system(size: 17, weight: .semibold)
    static let p40: Font = .system(size: 40, weight: .regular)
    static let p40s: Font = .system(size: 40, weight: .semibold)
    static let p52: Font = .system(size: 52, weight: .semibold)
    static let p52s: Font = .system(size: 52, weight: .semibold)
}

extension Color {
    static let cBlue: Color = Color(hex: 0x383AD1)
    static let cGray: Color = Color(hex: 0x949494)
    static let cViolet: Color = Color(hex: 0x8058BF)
    static let cGreen: Color = Color(hex: 0x359F58)
    static let cRed: Color = Color(hex: 0xD0021B)
}

enum Insets: CGFloat {
    case i0 = 0
    case i2 = 2
    case i4 = 4
    case i6 = 6
    case i8 = 8
    case i10 = 10
    case i12 = 12
    case i24 = 24
    case i30 = 30
}
