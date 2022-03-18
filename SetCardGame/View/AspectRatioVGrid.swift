//
//  AspectRatioVGrid.swift
//  SetCardGame
//
//  Created by Raúl Carrancá on 15/03/22.
//

import SwiftUI

struct AspectRatioVGrid<Item, ItemView>: View where ItemView: View, Item: Identifiable {
    var items: [Item]
    var aspectRatio: CGFloat
    var content: (Item) -> ItemView
    
    // init is needed in order to declare @ViewBuider types
    // closures are reference types. '(Item) -> ItemView' points to the function and the compiler needs to know it will have to hold on to content or in other word if it can inline the function, therefore @escaping
    init(items: [Item], aspectRatio: CGFloat, @ViewBuilder content: @escaping (Item) -> ItemView) {
        self.items = items
        self.aspectRatio = aspectRatio
        self.content = content
    }
    
    var body: some View {
        GeometryReader { geometry in
            //VStack is a flexible space, so by placing LazyVGrid inside we make sure our items take all available space and communicate this intntion
            VStack {
                let width: CGFloat = widthThatFits(itemCount: items.count, in: geometry.size, itemsAspectRatio: aspectRatio)
                LazyVGrid(columns: [adaptiveGridItem(width: width)], spacing: 0) {
                    ForEach(items) { item in
                        content(item).aspectRatio(aspectRatio, contentMode: .fit)
                    }
                }
                Spacer(minLength: 0)
            }
        }
    }
    
    private func adaptiveGridItem(width: CGFloat) -> GridItem {
        var gridItem = GridItem(.adaptive(minimum: width))
        gridItem.spacing = 0
        return gridItem
    }
    
    // widthThatFits() assumes spacing between cards = 0, spacing is generated trough padding in EMGV
    private func widthThatFits(itemCount: Int, in availableSize: CGSize, itemsAspectRatio: CGFloat) -> CGFloat {
        // minimum amount of columns = 1
        var columnCount = 1
        // minimum amoun of rows starts = itemCount
        var rowCount = itemCount
        
        repeat {
            let itemWidth = availableSize.width / CGFloat(columnCount)
            let itemHeight = itemWidth / itemsAspectRatio
            // availableSize is given by GeometryReader, therefore repeat until rowCount * itemHeight < available height
            if CGFloat(rowCount) * itemHeight < availableSize.height {
                break
            }
            columnCount += 1
            // rowCount is inferred as Int, therefore is rounded down, i.e. 4 + (2 - 1) / 2 = 2, not 2.5!!!
            rowCount = (itemCount + (columnCount - 1)) / columnCount
        // repeat loop is performed while columnCount < itemCount OR until rowCount * itemHeight < available height, otherwise all items end up in one row
        } while columnCount < itemCount
        if columnCount > itemCount {
            columnCount = itemCount
        }
        return floor(availableSize.width / CGFloat(columnCount))
    }
}
