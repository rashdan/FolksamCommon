//
//  SwiftUIActivityIndicator.swift
//  FolksamAppUtilities
//
//  Created by Johan Torell on 2021-11-09.
//

import Foundation
import SwiftUI
import UIKit

@available(iOS 13.0, *)
public struct ActivityIndicator: UIViewRepresentable {
    @Binding var isAnimating: Bool
    let style: UIActivityIndicatorView.Style

    public init(isAnimating: Binding<Bool>, style: UIActivityIndicatorView.Style) {
        _isAnimating = isAnimating
        self.style = style
    }

    public func makeUIView(context _: UIViewRepresentableContext<ActivityIndicator>) -> UIActivityIndicatorView {
        return UIActivityIndicatorView(style: style)
    }

    public func updateUIView(_ uiView: UIActivityIndicatorView, context _: UIViewRepresentableContext<ActivityIndicator>) {
        isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
    }
}

@available(iOS 13.0, *)
public struct LoadingView<Content: View>: View {
    @Binding var isShowing: Bool
    var content: () -> Content

    public init(isShowing: Binding<Bool>, @ViewBuilder content: @escaping () -> Content) {
        _isShowing = isShowing
        self.content = content
    }

    public var body: some View {
        GeometryReader { _ in
            ZStack(alignment: .center) {
                self.content()
                    .disabled(self.isShowing)
                    .blur(radius: self.isShowing ? 3 : 0)

                VStack {
                    ActivityIndicator(isAnimating: .constant(true), style: .large)
                }
                .opacity(self.isShowing ? 1 : 0).disabled(!self.isShowing)
            }
        }
    }
}
