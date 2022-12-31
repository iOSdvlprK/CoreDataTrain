//
//  Service.swift
//  CoreDataTrain
//
//  Created by joe on 2022/12/31.
//

import Foundation

struct Service {
    
    static let shared = Service()
    
    let urlString = "https://api.letsbuildthatapp.com/intermediate_training/companies"
    
    func downloadCompaniesFromServer() {
        print("Attempting to download companies..")
        
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { data, resp, err in
            print("Finished downloading")
            
            if let err = err {
                print("Failed to download companies:", err)
                return
            }
            
            guard let data = data else { return }
//            let string = String(data: data, encoding: .utf8)
//            print(string)
            let jsonDecoder = JSONDecoder()
            do {
                let jsonCompanies = try jsonDecoder.decode([JSONCompany].self, from: data)
                jsonCompanies.forEach { jsonCompany in
                    print(jsonCompany.name)
                    
                    jsonCompany.employees?.forEach({ jsonEmployee in
                        print("  \(jsonEmployee.name)")
                    })
                }
            } catch let jsonDecodeErr {
                print("Failed to decode:", jsonDecodeErr)
            }
            
        }.resume()
    }
}

struct JSONCompany: Decodable {
    let name: String
    let founded: String?
    var employees: [JSONEmployee]?
}

struct JSONEmployee: Decodable {
    let name: String
    let type: String
    let birthday: String
}
