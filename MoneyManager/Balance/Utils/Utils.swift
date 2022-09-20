import SwiftUI

extension Color {
    init(hex: UInt, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 08) & 0xff) / 255,
            blue: Double((hex >> 00) & 0xff) / 255,
            opacity: alpha
        )
    }
}

extension View {
        
    func padding(top: Insets? = nil, leading: Insets? = nil, bottom: Insets? = nil, trailing: Insets? = nil) -> some View {
        var edgeInsets = EdgeInsets()
        if let top = top {
            edgeInsets.top = top.rawValue
        }
        if let leading = leading {
            edgeInsets.leading = leading.rawValue
        }
        if let bottom = bottom {
            edgeInsets.bottom = bottom.rawValue
        }
        if let trailing = trailing {
            edgeInsets.trailing = trailing.rawValue
        }
        return padding(edgeInsets)
    }
}

struct CornerRadiusStyle: ViewModifier {
    var radius: CGFloat
    var corners: UIRectCorner
    
    struct CornerRadiusShape: Shape {

        var radius = CGFloat.infinity
        var corners = UIRectCorner.allCorners

        func path(in rect: CGRect) -> Path {
            let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            return Path(path.cgPath)
        }
    }

    func body(content: Content) -> some View {
        content
            .clipShape(CornerRadiusShape(radius: radius, corners: corners))
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        ModifiedContent(content: self, modifier: CornerRadiusStyle(radius: radius, corners: corners))
    }
}

