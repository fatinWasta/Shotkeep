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
            TitleView()
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
            
            BottomView()
            
            Spacer()
        }
        .frame(minWidth: 300)
    }
    
}

#Preview {
    DashboardView()
}


struct BottomView: View {
    var body: some View {
        HStack {
            Text("Last Organised")
                .font(.system(.subheadline,
                              weight: .medium))
            Spacer()
            Text("2hrs ago")
                .font(.system(.subheadline,
                              weight: .medium))
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
    @State private var isHovered = false
    
    
    var body: some View {
        HStack {
            VStack (alignment: .leading) {
                Text("ShotKeep")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text("To keep your screenshots organized")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
            }
            .padding()
            
            Spacer()
            Button(action: {}) {
                Image(systemName: "gearshape")
                    .font(.largeTitle)
                    .foregroundColor(.white)
            }
            .padding()
            
        }
        
    }
}

