import SwiftUI

struct ProgressView: View {
    
    let progress: Double
    
    init(progress: Double) {
        self.progress = progress < 1 ? progress : 1
    }
    
    var body: some View {
        GeometryReader { geometryProxy in
            HStack (spacing: 2) {
                Color
                    .cBlue
                    .frame(width: geometryProxy.size.width*progress)
                    .cornerRadius(4, corners: cornersFor(progress, isLeftView: true))
                Color
                    .cViolet
                    .frame(width: geometryProxy.size.width - geometryProxy.size.width*progress)
                    .cornerRadius(4, corners: cornersFor(progress, isLeftView: false))
            }
        }
    }
}

private extension ProgressView {
    
    func cornersFor(_ progress: Double, isLeftView: Bool) -> UIRectCorner {
        
        let allRectCorners: UIRectCorner = [.topLeft, .bottomLeft, .topRight, .bottomRight]
        
        switch isLeftView {
        case true:
            return progress == 1 ? allRectCorners : [.topLeft, .bottomLeft]
        case false:
            return progress == 0 ? allRectCorners : [.topRight, .bottomRight]
        }
    }
    
}

struct ProgressView_Previews: PreviewProvider {
    static var previews: some View {
        ProgressView(progress: 0.67)
    }
}
