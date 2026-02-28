//
//  SettingsView.swift
//  ShotKeep
//
//  Created by Fatin on 25/02/26.
//


import SwiftUI

struct SettingsView : View {
    @EnvironmentObject private var coordinator: NavigationCoordinator
    //@ObservedObject var viewModel: SettingsViewModel
    @ObservedObject var config: AppConfigViewModel
    
    var body: some View {
        VStack {
            
            TitleView(title: "Settings",
                      subTitle: "Configure file locations",
                      leadingImageName: "arrow.left")
            
            Divider()
                .padding([.leading, .trailing])
            
            FolderSelectionView(title: "Source Folder",
                                subTitle: "Where to monitor for new screenshots?",
                                selectedFolderPath: "~/\(config.sourceFolderDisplayName)") {
                config.chooseSourceFolder()
            }
            
            FolderSelectionView(title: "Destination Folder",
                                subTitle: "Where to save organized creenshots?",
                                selectedFolderPath: "~/\(config.destinationFolderDisplayName)") {
                config.chooseDestinationFolder()
            }
            
            Divider()
                .padding([.leading, .trailing])
            
            HowItWorksView()
                .padding()
            
            
        }
    }
    
}


struct HowItWorksView: View {
    let items: [String] = ["Screenshots are automatically detected from source folder",
                           "Files are organized by date(Year/Month/Day)",
                           "Original files are safely moved (not copied)"]
    
    var body: some View {
        VStack(spacing: 5) {
            CardView(backgroundColor: .howItWorksCard) {
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
        .padding(.bottom, 20)
    }
}

