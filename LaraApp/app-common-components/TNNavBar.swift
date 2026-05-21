import SwiftUI

struct TNNavBar: View {
    var title: String = ""
    var leadingButtonAction: (() -> Void)?
    var trailingButtonTitle: String = ""
    var trailingButtonAction: (() -> Void)?
    
    var menuButtonAction: (() -> Void)?

    var body: some View {
        HStack(spacing: 0) {
            leadingButton
            Spacer()
            titleView
            Spacer()
            trailingButton
        }
        .padding(.horizontal, 8)
        .frame(height: 56)
        .background(Color(.systemBackground))
        .overlay(Rectangle().frame(height: 0.5).foregroundColor(Color(.separator)), alignment: .bottom)
    }

    @ViewBuilder
    private var leadingButton: some View {
        Group {
            if let action = menuButtonAction {
                Button(action: action) {
                    Image(systemName: "line.3.horizontal")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(.primary)
                        .frame(width: 44, height: 44)
                }
            } else if let action = leadingButtonAction {
                Button(action: action) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.primary)
                        .frame(width: 44, height: 44)
                }
            } else {
                Color.clear.frame(width: 44, height: 44)
            }
        }
    }

    @ViewBuilder
    private var titleView: some View {
        if !title.isEmpty {
            Text(title).font(.headline).foregroundColor(.primary)
        }
    }

    @ViewBuilder
    private var trailingButton: some View {
        if !trailingButtonTitle.isEmpty, let action = trailingButtonAction {
            Button(trailingButtonTitle, action: action)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.blue)
                .frame(width: 60, height: 44)
        } else {
            Color.clear.frame(width: 60, height: 44)
        }
    }
}
