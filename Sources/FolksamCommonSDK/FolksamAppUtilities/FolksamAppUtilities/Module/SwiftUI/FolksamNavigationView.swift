//
//  FolksamNavigationView.swift
//  FolksamAppUtilities
//
//  Created by Johan Torell on 2021-11-09.
//

import SwiftUI

@available(iOS 13.0, *)
public struct FolksamNavigationView<Content: View>: View {
    var content: () -> Content

    public init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }

    public var body: some View {
        content()
    }
}

// struct FolksamNavigationView_Previews: PreviewProvider {
//    static var previews: some View {
//        FolksamNavigationView()
//    }
// }
