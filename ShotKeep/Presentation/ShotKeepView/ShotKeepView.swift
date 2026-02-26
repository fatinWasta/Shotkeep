    //
    //  ContentView.swift
    //  ShotKeep
    //
    //  Created by Fatin on 21/02/26.
    //

import SwiftUI
import UniformTypeIdentifiers
import Combine
import AppKit

enum Summery: String, CaseIterable {
    case week
    case today
}

struct ShotKeepView: View {
    @State private var isExpanded = false
    @State private var showImporter = false
    
    @StateObject private var viewModel: ShotKeepViewModel
    let menuViewWidth: CGFloat = 500

    init(viewModel: ShotKeepViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack {
            
            Text("Screenshots To organise: \(viewModel.sourceScreenshots.count)")
            
            VStack {
                    Text("Source:\(viewModel.getSourceDirectoryPath())")
                    
                    
                    Button("Choose Folder to read SS") {
                        viewModel.chooseSourceFolder()
                    }
                
                Button("Choose Folder for shotkeep SS") {
                    viewModel.chooseDestinationFolder()
                }
                
                Button( action: {
                    viewModel.moveAllScreenshots(to: viewModel.destinationDirectory)
                }) {
                    Text("Move Screenshots")
                }
                
                SettingsLink {
                    Label("Settings", systemImage: "gearshape")
                }   
            }
            
            
            Button(action: {
                NSApplication.shared.terminate(nil)
            }) {
                Image(systemName: "xmark.circle")
            }
            .help("Quit")
            
        }
        .frame(width: menuViewWidth)
        .padding()
    }
    
}


#Preview {
        //ShotKeepView()
}
