import SwiftUI

struct TNCommonButton: View {
    let title: String
    var isEnabled: Bool = true
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 52)
                .background(isEnabled ? Color.blue : Color.gray)
                .cornerRadius(12)
        }
        .disabled(!isEnabled)
        .padding(.horizontal, 20)
    }
}
