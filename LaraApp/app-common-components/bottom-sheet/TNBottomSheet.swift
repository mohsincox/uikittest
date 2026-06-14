//
//  TNBottomSheet.swift
//  LaraApp
//
//  Copyright © 2026 Technonext Software Ltd. All rights reserved.
//

import SwiftUI

struct TNBottomSheet<Content: View>: View {
    @Binding var isShowing: Bool

    let content: Content
    let backgroundColor: Color
    let isOnBackgroundTapEnabled: Bool
    let isDragToDismissEnabled: Bool
    let isBottomIgnored: Bool
    let backgroundOpacity: CGFloat
    let topCornerRadius: CGFloat

    @State private var dragOffset: CGFloat = 0
    @GestureState private var isDragGestureActive: Bool = false

    init(
        isShowing: Binding<Bool>,
        backgroundColor: Color = Color(.systemBackground),
        isOnBackgroundTapEnabled: Bool = true,
        isDragToDismissEnabled: Bool = true,
        isBottomIgnored: Bool = true,
        backgroundOpacity: CGFloat = 0.3,
        topCornerRadius: CGFloat = 24,
        @ViewBuilder content: () -> Content
    ) {
        self._isShowing = isShowing
        self.backgroundColor = backgroundColor
        self.isOnBackgroundTapEnabled = isOnBackgroundTapEnabled
        self.isDragToDismissEnabled = isDragToDismissEnabled
        self.isBottomIgnored = isBottomIgnored
        self.backgroundOpacity = backgroundOpacity
        self.topCornerRadius = topCornerRadius
        self.content = content()
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            if isShowing {
                Color.black
                    .opacity(backgroundOpacity)
                    .ignoresSafeArea()
                    .contentShape(Rectangle())
                    .onTapGesture {
                        if isOnBackgroundTapEnabled { isShowing = false }
                    }

                VStack(spacing: 0) {
                    Capsule()
                        .fill(Color(.systemGray3))
                        .frame(width: 36, height: 5)
                        .padding(.top, 8)

                    content
                        .padding(.bottom, isBottomIgnored ? (UIApplication.shared.safeAreaInsets?.bottom ?? 0) : 0)
                }
                .background(backgroundColor)
                .cornerRadius(topCornerRadius, corners: [.topLeft, .topRight])
                .shadow(color: Color.black.opacity(0.16), radius: 8, x: 0, y: -3)
                .offset(y: dragOffset)
                .transition(.move(edge: .bottom))
                .zIndex(1)
                .gesture(isDragToDismissEnabled ? dragGesture : nil)
                .onChange(of: isDragGestureActive) { isActive in
                    if !isActive {
                        withAnimation(.easeInOut(duration: 0.1)) { dragOffset = 0 }
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        .ignoresSafeArea()
        .animation(.easeInOut, value: isShowing)
    }

    private var dragGesture: some Gesture {
        DragGesture()
            .updating($isDragGestureActive) { _, state, _ in state = true }
            .onChanged { value in
                guard value.translation.height > 0 else { return }
                dragOffset = value.translation.height
            }
            .onEnded { value in
                let crossedDragThreshold = value.translation.height > 50
                let crossedSpeedThreshold = value.predictedEndLocation.y > value.startLocation.y + 200
                if crossedDragThreshold || crossedSpeedThreshold {
                    withAnimation(.easeInOut(duration: 0.1)) { isShowing = false }
                }
                withAnimation(.easeInOut(duration: 0.3)) { dragOffset = 0 }
            }
    }
}

private extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

private struct RoundedCorner: Shape {
    var radius: CGFloat
    var corners: UIRectCorner

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

private extension UIApplication {
    var safeAreaInsets: UIEdgeInsets? {
        connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }?
            .safeAreaInsets
    }
}
