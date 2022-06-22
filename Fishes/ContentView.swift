//
//  ContentView.swift
//  Fishes
//
//  Created by user on 21/06/22.
//

import SwiftUI
import SwiftyJSON

struct ContentView: View {
    @ObservedObject var pesci = fishParser()
    
    var body: some View {
        NavigationView {
                VStack {
                    List(pesci.fish) { i in
                        Text("Scientific name: \(i.scientificName)").background(.gray)
                        Text("Species name: \(i.speciesName)").background(.white)
                    }
                    
                    NavigationLink(destination: secondView("caccapupu")) {
                        Text("Hit Me!")
                            .fontWeight(.semibold)
                            .font(.title)
                            .padding()
                            .foregroundColor(.white)
                            .background(LinearGradient(gradient: Gradient(colors: [Color(.white),Color(.blue)]), startPoint: .leading, endPoint: .trailing))
                            .cornerRadius(40)
                }
              }
            }
    }
}

struct secondView: View {
    @State var quote = Text("dio")
    var test: String
    var body: some View {
        VStack {
            quote
        }
    }
    
    init(_ test: String) {
        self.test = test
    }
}

/*
 "Scientific Name": "Pristipomoides filamentosus"
 "Species Name": "Crimson Jobfish"
 */

struct fishBase: Identifiable {
    var id: String
    var scientificName: String
    var speciesName: String
}

class fishParser: ObservableObject {
    @Published var fish = [fishBase]()
    
    init() {
        let url = URL(string: "https://www.fishwatch.gov/api/species")!
        let session = URLSession(configuration: .default)
        session.dataTask(with: url) { (data, _, err) in
            if err != nil {
                print(err.debugDescription)
            }
            let json = try! JSON(data: data!)
            print(json)
            for i in json {
                let scientificName = i.1["Scientific Name"].stringValue
                let speciesName = i.1["Species Name"].stringValue
                DispatchQueue.main.async {
                    self.fish.append(fishBase(id: scientificName, scientificName: scientificName, speciesName: speciesName))
                }
            }
        }.resume()
    }
}
