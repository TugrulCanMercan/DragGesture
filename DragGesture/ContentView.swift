//
//  ContentView.swift
//  DragGesture
//
//  Created by Tuğrul Can MERCAN (Dijital Kanallar Uygulama Geliştirme Müdürlüğü) on 31.08.2022.
//

import SwiftUI

struct ContentView: View {
    @GestureState var gestureOffset:CGFloat = .zero
    @State var offset: CGFloat = .zero
    @State var lastStoredOffset:CGFloat = .zero
    @State var homeOpacity: Double = 0.1
    var sideBarWidth =  UIScreen.main.bounds.width / 1.5
    var body: some View {
        VStack {
            GeometryReader { proxy in
                let width = proxy.size.width
                HStack(spacing:0) {
                    Rectangle()
                        .fill(.red)
                        .frame(width: sideBarWidth)
                    Rectangle()
                        .fill(.blue.opacity(homeOpacity))
                        .frame(width: proxy.size.width)
                    Rectangle()
                        .fill(.green)
                        .frame(width: proxy.size.width)
                }
                .offset(x:offset - sideBarWidth)
                .gesture(
                    DragGesture()
                        .updating($gestureOffset, body: {value, out, _ in
                            out = value.translation.width
                        })
                        .onChanged({ value in
                            print(sideBarWidth)
                            let trans = value.translation.width
                            let lastOffset = trans + lastStoredOffset
                            if trans != 0 {
                                if lastOffset < sideBarWidth && -lastOffset < width {
                                    offset = lastOffset
                                    if lastOffset > 0 && lastOffset < sideBarWidth {
                                        homeOpacity = lastOffset / sideBarWidth
                                    }
                                }
                            } else {
                                offset = offset
                            }
                            print(offset)
                        })
                        .onEnded({ value in
                            let trans = value.translation.width
                            let sideBarTrans = sideBarWidth / 3
                            if trans > 0 {
                                if (lastStoredOffset + trans) < sideBarTrans {
                                    if -(lastStoredOffset + trans) > (width - sideBarTrans) {
                                        offset = lastStoredOffset
                                    } else {
                                        offset = 0
                                    }
                                  
                                }else {
                                    offset = sideBarWidth
                                }
                               
                            } else {
                                if (lastStoredOffset + trans) < (sideBarWidth - sideBarTrans) {
                                    if -(lastStoredOffset + trans) > (sideBarWidth - sideBarTrans) {
                                        offset = -width
                                    } else {
                                        offset = 0
                                    }
                                  
                                }else {
                                    offset = sideBarWidth
                                }
                            }
                            
                            lastStoredOffset = offset
                        })
                )
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
