    //
    //  ContentView.swift
    //  ShotKeep
    //
    //  Created by Fatin on 21/02/26.
    //

import SwiftUI
import UniformTypeIdentifiers
import Combine

enum Summery: String, CaseIterable {
    case week
    case today
}

struct ShotKeepView: View {
    @State private var isExpanded = false
    @State private var showImporter = false
    
    @StateObject private var viewModel: ShotKeepViewModel
    
    init(viewModel: ShotKeepViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack {
            
            Text("Screenshots To organise: \(viewModel.screenshots.count)")
            
            VStack {
                Button("Choose Folder") {
                    viewModel.chooseSourceFolder()
                }
                
                Button( action: {
                    
                }) {
                    Text("Move Screenshots")
                }
                .help("Quit")
            }
            
            
            Button(action: {
                NSApplication.shared.terminate(nil)
            }) {
                Image(systemName: "xmark.circle")
            }
            .help("Quit")
            
        }
        .padding()
    }
    
}


#Preview {
        //ShotKeepView()
}
