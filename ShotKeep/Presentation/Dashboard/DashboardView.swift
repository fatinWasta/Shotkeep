//
//  DashboardView.swift
//  ShotKeep
//
//  Created by Fatin on 25/02/26.
//

import SwiftUI

struct DashboardView : View {
    @State private var isOn = false
    
    @ObservedObject var viewModel: DashboardViewModel
    
    var body: some View {
        VStack {
            TitleView(title: "Shotkeep",
                      subTitle: "To keep your screenshots organized",
                      trailingImageName: "gearshape")
            Divider()
                .padding([.leading, .trailing])
            
            StatusView(isOn: $viewModel.isMonitoringEnabled,
                       statusColor: viewModel.monitoringStatusColor,
                       status: viewModel.monitoringStatusText,
                       description: viewModel.monitoringDescription,
                       unOrganisedScreenshotsCount: viewModel.sourceScreenshots.count)
            
            SKButton(title: "Organize Now",
                     image: nil,
                     backgroundColor: .buttonPrimary) {
                viewModel.moveAllScreenshots()
            }
                     .padding()
            
            Divider()
                .padding([.leading, .trailing])
            
            SummeryView(totalOrganised: viewModel.destinationScreenshots.count)
            
            Divider()
                .padding([.leading, .trailing])
            
            LastRunView(atDate: viewModel.lastOrganizedText)
            
            Spacer()
        }
        .frame(width: 500, height: 600)
        .alert(item: $viewModel.activeAlert) { alert in
            Alert(
                title: Text(alert.title),
                message: Text(alert.message),
                dismissButton: .default(Text("OK"))
            )
        }
       
    }
    
}

struct LastRunView: View {
    var atDate: String
    var body: some View {
        HStack {
            Text("Last Organised,")
                .font(.system(.subheadline,
                              weight: .medium))
            Text("\(atDate)")
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

//TODO: This needs to be updated once organizer logic is completed
struct SummeryView: View {
    var totalOrganised: Int
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Summery")
                .font(.headline)
            
            HStack {
                Spacer()
                CardView(backgroundColor: .green) {
                    VStack {
                        Text("Total Organized")
                        
                        Text("\(totalOrganised)")
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
    var statusColor: Color
    var status: String
    var description: String
    var unOrganisedScreenshotsCount: Int
    
    var body: some View {
        CardView(backgroundColor: .statusCard) {
            HStack() {
                Circle()
                    .fill(statusColor)
                    .frame(width: 10, height: 10)
                
                VStack(alignment: .leading) {
                    
                    Text(status)
                        .font(.headline)
                    Text(description)
                        .font(.subheadline)
                    
                    if !isOn {
                        Text("You currently have \(unOrganisedScreenshotsCount) unorganized screenshots.")
                            .font(.subheadline)
                    }
                }
                
                Spacer()
                Toggle("", isOn: $isOn)
                    .toggleStyle(.switch)
                    .tint(.red)
                    .labelsHidden()
                    .padding()
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

