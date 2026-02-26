//
//  SettingsView.swift
//  ShotKeep
//
//  Created by Fatin on 25/02/26.
//


import SwiftUI

struct SettingsView : View {
    @EnvironmentObject private var coordinator: NavigationCoordinator
    
    var body: some View {
        VStack {
            
            TitleView(title: "Settings",
                      subTitle: "Configure file locations",
                      leadingImageName: "arrow.left")
            
            Divider()
                .padding([.leading, .trailing])
            
            FolderSelectionView(title: "Source Folder",
                                subTitle: "Where to monitor for new screenshots?",
                                selectedFolderPath: "~/Relative selected source path")
            
            FolderSelectionView(title: "Destination Folder",
                                subTitle: "Where to save organized creenshots?",
                                selectedFolderPath: "~/Relative selected destination path")
            
            Divider()
                .padding([.leading, .trailing])
            
            HowItWorksView()
            
            Divider()
                .padding([.leading, .trailing])
            
            HStack {
                SKButton(title: "Cancel",
                         width: 180,
                         height: 40,
                         backgroundColor: .secondary
                ) {
                    //perform action here
                }
                
                SKButton(title: "Save Changes",
                         width: 180,
                         height: 40
                ) {
                    //perform action here
                }
            }
            .padding()
            
        }
        //.frame(width: 500, height: 600)
    }
    
}

#Preview {
    SettingsView()
        .environmentObject(NavigationCoordinator())
}

struct HowItWorksView: View {
    let items: [String] = ["Screenshots are automatically detected from source folder",
                           "Files are organized by date(Year/Month/Day)",
                           "Original files are safely moved (not copied)"]
    
    var body: some View {
        VStack {
            CardView(backgroundColor: .indigo) {
                HStack {
                    VStack(alignment: .leading) {
                        Text("How it Works")
                            .font(.headline)
                        
                        ForEach(items, id: \.self) { item in
                            HStack(alignment: .top, spacing: 8) {
                                Text("•")
                                Text(item)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        }
                    }
                    Spacer()
                }
            }
            
        }
        .padding()
    }
}

