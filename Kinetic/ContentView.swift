import SwiftUI
import Wave

struct ContentView: View {
    @State var offsetStart: CGSize = .zero
    @State var isDragging: Bool = false
    @State var offset: CGSize = .zero
    @State var offsetAnimator = SpringAnimator<CGSize>(spring: .defaultAnimated)
    
    var body: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(.blue)
            .frame(width:100, height: 100)
            .offset(offset)
            .gesture(dragGesture)
            .onAppear {
                offsetAnimator.value = offset
                offsetAnimator.valueChanged = { value in
                    offset = value
                }
            }
            .overlay {
                Text("OFFSET: \(offset.height)").monospaced()
            }
    }
    
    var dragGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                if !isDragging {
                    isDragging = true
                    offsetStart = offset
                }
                offsetAnimator.target = offsetStart + value.translation
                offsetAnimator.mode = .nonAnimated
                offsetAnimator.start()
            }
            .onEnded { value in
                isDragging = false
                offsetAnimator.velocity = value.velocity
                offsetAnimator.target = .zero
                offsetAnimator.mode = .animated
                offsetAnimator.start()
            }
    }
}

extension CGSize {
    static func + (lhs: CGSize, rhs: CGSize) -> CGSize {
        CGSize(
            width: lhs.width + rhs.width,
            height: lhs.height + rhs.height
        )
    }
}

#Preview {
    ContentView()
}
