//
//  HitsList.swift
//  
//
//  Created by Vladislav Fitc on 29/03/2021.
//

import Foundation
import SwiftUI

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
public struct HitsList<Row: View, Item: Codable, NoResults: View>: View {
  
  @ObservedObject public var hitsObservable: HitsObservableController<Item>
  public var row: (Item?, Int) -> Row
  public var noResults: (() -> NoResults)?
  
  public init(_ hitsObservable: HitsObservableController<Item>,
              @ViewBuilder row: @escaping (Item?, Int) -> Row,
              @ViewBuilder noResults: @escaping () -> NoResults) {
    self.hitsObservable = hitsObservable
    self.row = row
    self.noResults = noResults
  }
            
  public var body: some View {
    if let noResults = noResults?(), hitsObservable.hits.isEmpty {
      noResults
    } else {
      if #available(iOS 14.0, OSX 11.0, tvOS 14.0, *) {
        ScrollView(showsIndicators: false) {
          LazyVStack() {
            ForEach(0..<hitsObservable.hits.count, id: \.self) { index in
              row(atIndex: index)
            }
          }
        }.id(hitsObservable.scrollID)
      } else {
        List(0..<hitsObservable.hits.count, id: \.self) { index in
          row(atIndex: index)
        }.id(hitsObservable.scrollID)
      }
    }
  }
  
  private func row(atIndex index: Int) -> some View {
    row(hitsObservable.hits[index], index).onAppear {
      hitsObservable.notify(index: index)
    }
  }

}

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
public extension HitsList where NoResults == Never {
  
  init(_ hitsObservable: HitsObservableController<Item>,
       @ViewBuilder row: @escaping (Item?, Int) -> Row) {
    self.hitsObservable = hitsObservable
    self.row = row
    self.noResults = nil
  }
  
}

#if os(iOS)
@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
struct HitsView_Previews : PreviewProvider {
  
  static var previews: some View {
    let hitsObservable: HitsObservableController<String> = .init()
    NavigationView {
      HitsList(hitsObservable) { string, index in
        VStack {
          HStack {
            Text(string ?? "---")
              .frame(maxWidth: .infinity, minHeight: 30, maxHeight: .infinity, alignment: .leading)
              .padding(.horizontal, 16)
          }
          Divider()
        }
      } noResults: {
        Text("No results")
      }
      .padding(.top, 20)
      .onAppear {
        hitsObservable.hits = ["One", "Two", "Three"]
      }.navigationBarTitle("Hits")
    }
    NavigationView {
      HitsList(hitsObservable) { string, index in
        VStack {
          HStack {
            Text(string ?? "---")
          }
          Divider()
        }
      } noResults: {
        Text("No results")
      }.navigationBarTitle("Hits")
    }
  }
}
#endif
