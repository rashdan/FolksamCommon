//
//  FolksamList.swift
//  FolksamAppUtilities
//
//  Created by Johan Torell on 2021-11-09.
//
// SwiftUI List wrapper that hopefully works on all iOS 13+

import SwiftUI

#if !os(macOS)
public struct FolksamList<Content: View>: View {
    public var content: () -> Content

    public init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
        if #available(iOS 14.0, *) {
            // iOS 14 doesn't have extra separators below the list by default.
        } else {
            // To remove only extra separators below the list:
            UITableView.appearance().tableFooterView = UIView()
        }

        // To remove all separators (for ios 13)
        UITableView.appearance().separatorStyle = .none
    }

    public var body: some View {
        if #available(iOS 15.0, *) {
            List {
                content().listRowSeparator(.hidden)
            }
            .listStyle(.plain)
            .listRowSeparator(.hidden)
        } else if #available(iOS 14.0, *) {
            ScrollView {
                LazyVStack {
                    content()
                }
            }
        } else {
            List {
                content()
            }
        }
    }
}

// struct FolksamList_Previews: PreviewProvider {
//    static var previews: some View {
//        FolksamList {
//            Text("hej")
//        }
//    }
// }
#endif
