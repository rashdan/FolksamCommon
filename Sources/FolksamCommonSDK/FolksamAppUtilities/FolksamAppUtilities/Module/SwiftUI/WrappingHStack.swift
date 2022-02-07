//
//  WrappingHStack.swift
//  feature_AudioClaim
//
//  Created by Johan Torell on 2021-11-03.
//

import Foundation
import SwiftUI

@available(iOS 13.0, *)
public struct WrappingHStack<Model, V>: View where Model: Hashable, V: View {
    public typealias ViewGenerator = (Model) -> V

    var models: [Model]
    var viewGenerator: ViewGenerator
    var horizontalSpacing: CGFloat = 2
    var verticalSpacing: CGFloat = 0

    public init(models: [Model], viewGenerator: @escaping ViewGenerator, horizontalSpacing: CGFloat = 2, verticalSpacing: CGFloat = 0) {
        self.models = models
        self.viewGenerator = viewGenerator
        self.horizontalSpacing = horizontalSpacing
        self.verticalSpacing = verticalSpacing
    }

    @State private var totalHeight
        = CGFloat.zero // << variant for ScrollView/List
    //    = CGFloat.infinity   // << variant for VStack

    public var body: some View {
        VStack {
            GeometryReader { geometry in
                self.generateContent(in: geometry)
            }
        }
        .frame(height: totalHeight) // << variant for ScrollView/List
        // .frame(maxHeight: totalHeight) // << variant for VStack
    }

    private func generateContent(in geometry: GeometryProxy) -> some View {
        var width = CGFloat.zero
        var height = CGFloat.zero

        return ZStack(alignment: .topLeading) {
            ForEach(self.models, id: \.self) { models in
                viewGenerator(models)
                    .padding(.horizontal, horizontalSpacing)
                    .padding(.vertical, verticalSpacing)
                    .alignmentGuide(.leading, computeValue: { dimension in
                        if abs(width - dimension.width) > geometry.size.width {
                            width = 0
                            height -= dimension.height
                        }
                        let result = width
                        if models == self.models.last! {
                            width = 0 // last item
                        } else {
                            width -= dimension.width
                        }
                        return result
                    })
                    .alignmentGuide(.top, computeValue: { _ in
                        let result = height
                        if models == self.models.last! {
                            height = 0 // last item
                        }
                        return result
                    })
            }
        }.background(viewHeightReader($totalHeight))
    }

    private func viewHeightReader(_ binding: Binding<CGFloat>) -> some View {
        return GeometryReader { geometry -> Color in
            let rect = geometry.frame(in: .local)
            DispatchQueue.main.async {
                binding.wrappedValue = rect.size.height
            }
            return .clear
        }
    }
}
