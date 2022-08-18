//
//  DetailView.swift
//  H4X0R - SwiftUI
//
//  Created by 2lup on 02.08.2022.
//

import SwiftUI
// импортируем WebKit, так как WebView нету в SwiftUI
import WebKit

struct DetailView: View {
    
    let url: String?
    
    var body: some View {
        WebView(urlString: url)
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(url: "https://www.google.com")
    }
}
