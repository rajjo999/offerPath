import SwiftUI

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content
    ) -> some View {
        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self.opacity(!shouldShow ? 1 : 0)
        }
    }
    
    func ifEmpty<Content: View>(
        _ isEmpty: Bool,
        @ViewBuilder content: () -> Content
    ) -> some View {
        Group {
            if isEmpty {
                content()
            } else {
                self
            }
        }
    }
}
