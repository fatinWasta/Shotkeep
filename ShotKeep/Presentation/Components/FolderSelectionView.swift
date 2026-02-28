//
//  FolderSelectionView.swift
//  ShotKeep
//
//  Created by Fatin on 26/02/26.
//

import SwiftUI

struct FolderSelectionView: View {
    var title: String
    var subTitle: String
    var selectedFolderPath: String
    
    let selectFolderAction: () -> Void

    var body: some View {
        CardView {
            VStack(alignment: .leading) {
                HStack {
                    Image(systemName: "folder")
                    Text (title)
                        .font(.system(size: 14, weight: .semibold))
                }
                
                Text(subTitle)
                
                HStack {
                    CardView(backgroundColor: .buttonSecondary) {
                        HStack{
                            Text(selectedFolderPath)
                                .foregroundColor(.gray)
                            Spacer()
                        }
                       
                    }
                    
                    SKButton(title: "Browse",
                             image: Image(systemName: "arrow.forward.folder.fill"),
                             width: 100,
                             height: 40,
                             backgroundColor: .buttonSecondary
                    ) {
                        selectFolderAction()
                    }
                }

            }
        }
        .padding()
    }
}
