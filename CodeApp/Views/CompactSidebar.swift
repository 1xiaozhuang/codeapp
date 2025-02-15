//
//  CompactSidebar.swift
//  Code
//
//  Created by Ken Chung on 26/11/2022.
//

import SwiftUI

struct CompactSidebar: View {
    @EnvironmentObject var App: MainApp
    @EnvironmentObject var stateManager: MainStateManager
    @EnvironmentObject var activityBarManager: ActivityBarManager

    @SceneStorage("activitybar.selected.item") var activeItemId: String = DefaultUIState
        .ACTIVITYBAR_SELECTED_ITEM
    @SceneStorage("sidebar.visible") var isSideBarVisible: Bool = DefaultUIState.SIDEBAR_VISIBLE

    var body: some View {
        HStack(spacing: 0) {
            VStack {
                HStack {
                    Button(action: {
                        withAnimation(.easeIn(duration: 0.2)) {
                            isSideBarVisible.toggle()
                        }
                    }) {
                        Image(systemName: "sidebar.left")
                            .font(.system(size: 17))
                            .foregroundColor(Color.init("T1"))
                            .padding(5)
                            .contentShape(
                                RoundedRectangle(
                                    cornerRadius: 8, style: .continuous)
                            )
                            .hoverEffect(.highlight)
                            .frame(
                                minWidth: 0, maxWidth: 20, minHeight: 0,
                                maxHeight: 20
                            )
                            .padding()
                    }.sheet(isPresented: $stateManager.showsNewFileSheet) {
                        NewFileView(
                            targetUrl: App.workSpaceStorage
                                .currentDirectory.url
                        ).environmentObject(App)
                    }

                    Spacer()

                }
                .overlay {
                    Menu {
                        Picker(
                            selection: $activeItemId,
                            label: Text("Section")
                        ) {
                            ForEach(activityBarManager.items) {
                                Label($0.title, systemImage: $0.iconSystemName)
                                    .tag($0.itemID)
                            }
                        }
                    } label: {
                        HStack {
                            Text(
                                activityBarManager.itemForItemID(itemID: activeItemId)?.title ?? ""
                            )
                            .bold()
                            .lineLimit(1)
                            .foregroundColor(Color.init("T1"))

                            Image(systemName: "chevron.down.circle.fill")
                                .symbolRenderingMode(.hierarchical)
                        }.frame(width: 200.0)
                    }
                }
                .background(
                    Color.init(id: "sideBar.background")
                        .ignoresSafeArea(.container, edges: .top)
                )
                .frame(height: 40)

                if let item = activityBarManager.itemForItemID(itemID: activeItemId) {
                    item.view
                        .background(Color.init(id: "sideBar.background"))
                }
            }
            .frame(width: 280.0)
            .background(Color.init(id: "sideBar.background"))

            ZStack {
                Color.black.opacity(0.001)
                Spacer()
            }.onTapGesture {
                withAnimation(.easeIn(duration: 0.2)) {
                    isSideBarVisible.toggle()
                }
            }
        }
    }
}
