//
//  PopWindowContentView.swift
//  AIText
//
//  Created by will Suo on 2025/3/30.
//

import Foundation
import SwiftUI

struct PopWindowContentView: View {
    var body: some View {
        VStack(spacing: 12) {
            VStack(spacing: 2) {
                HStack {
                    Text("Selection")
                    Spacer()
                }
                GroupBox {
                    HStack {
                        Text(verbatim: SelectionManager.shared.getSelectedText() ?? "")
                            .lineLimit(1)
                            .foregroundColor(.secondary)
                    }
                }
            }
            
            VStack(alignment: .leading) {
                HStack {
                    Text("Result")
                    Spacer()
                }
                
                GroupBox {
                    HStack {
                        VStack(alignment: .leading) {
                            ScrollView {                            
                                Text("Result Text Here, Result Text HereResult Text HereResult Text HereResult Text Here")
                                    .selectionDisabled(false)
                            }
                            Spacer()
                        }
                        Spacer()
                    }
                }
            }
        }
        .padding(8)
        .frame(width: 200, height: 300)
        .cornerRadius(12)
        .background(.clear)
    }
}


#Preview {
    PopWindowContentView()
}
