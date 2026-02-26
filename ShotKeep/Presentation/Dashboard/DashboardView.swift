//
//  DashboardView.swift
//  ShotKeep
//
//  Created by Fatin on 25/02/26.
//

import SwiftUI

struct DashboardView : View {
    @State private var isOn = false
    
    var body: some View {
        VStack {
            TitleView(title: "Shotkeep",
                      subTitle: "To keep your screenshots organized",
                      trailingImageName: "gearshape")
            Divider()
                .padding([.leading, .trailing])
            
            StatusView(isOn: $isOn,
                       onToggle: { /* handle toggle change */ })
            
            SKButton(title: "Organize Now",
                     image: nil) {
                debugPrint("Org now!")
            }
                     .padding()
            
            Divider()
                .padding([.leading, .trailing])
            
            SummeryView()
            
            Divider()
                .padding([.leading, .trailing])
            
            LastRunView()
            
            Spacer()
        }
        .frame(width: 500, height: 600)
       
    }
    
}

#Preview {
    DashboardView()
}


struct LastRunView: View {
    var body: some View {
        HStack {
            Text("Last Organised,")
                .font(.system(.subheadline,
                              weight: .medium))
            Text("2hrs ago")
                .font(.system(.subheadline,
                              weight: .medium))
            
            Spacer()
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

struct SummeryView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Summery")
                .font(.headline)
            
            HStack {
                Spacer()
                CardView(backgroundColor: .green) {
                    VStack {
                        Text("Total Organized")
                        
                        Text("1023")
                            .font(.system(size: 40, weight: .bold))
                    }
                    
                }
                
                CardView(backgroundColor: .indigo) {
                    VStack{
                        Text("This Week")
                        
                        Text("43")
                            .font(.system(size: 40, weight: .bold))
                    }
                    
                }
                Spacer()
                
            }
        }
        .padding()
        
    }
    
}

struct StatusView: View {
    @Binding var isOn: Bool
    var onToggle: () -> Void
    
    var body: some View {
        CardView(backgroundColor: .red) {
            HStack() {
                Circle()
                    .frame(width: 10, height: 10)
                VStack(alignment: .leading) {
                    
                    Text("Inactive")
                        .font(.headline)
                    Text("Auto-organize is disabled")
                        .font(.subheadline)
                }
                
                Spacer()
                Toggle("", isOn: $isOn)
                    .toggleStyle(.switch)
                    .tint(.red)
                    .labelsHidden()
                    .padding()
                    .onChange(of: isOn) {
                        onToggle()
                    }
            }
        }
        .padding()
    }
}


struct TitleView: View {
    
    @EnvironmentObject private var coordinator: NavigationCoordinator
    
    var title: String
    var subTitle: String
    var leadingImageName: String?
    var trailingImageName: String?
    
    var body: some View {
        HStack {
       
            if let leadingImageName, !leadingImageName.isEmpty {
                Button(action: {
                    coordinator.pop()
                }) {
                    Image(systemName: leadingImageName)
                        .font(.largeTitle)
                        .foregroundColor(.white)
                }
                .padding([.leading])
            }
                        
            VStack (alignment: .leading) {
                Text(title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text(subTitle)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
            }
            .padding()
            
            Spacer()
            
            if let trailingImageName, !trailingImageName.isEmpty {
                Button(action: {
                    coordinator.push(.settings)
                }) {
                    Image(systemName: trailingImageName)
                        .font(.largeTitle)
                        .foregroundColor(.white)
                }
                .padding([.trailing])
            }
            
            
        }
        
    }
}

#Preview {
    TitleView(title: "Settings", subTitle: "Configure file locations")
}

