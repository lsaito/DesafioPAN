//
//  Repository.swift
//  DesafioPAN
//
//  Created by Lucas Saito on 18/10/2018.
//  Copyright © 2018 Otias. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class TheMovieDB {
    static let shared = TheMovieDB()
    
    let baseURL = "https://api.themoviedb.org/3"
    let api_key = "271253d65cac98d5079059c725fed688"
    private var configuration: TheMovieDB.Configuration.Response!
    
    func getURLRequest(endpoint: String, parameters: [String: Any]? = [:]) -> String {
        var URLRequest = ""
        
        URLRequest.append(contentsOf: self.baseURL)
        URLRequest.append(contentsOf: endpoint)
        URLRequest.append(contentsOf: "?api_key=")
        URLRequest.append(contentsOf: self.api_key)
        URLRequest.append(contentsOf: "&")
        
        if let parametersFormattedString = parameters?.reduce(into: String(), { (params, arg1) in
            let (key, value) = arg1
            var valueCast: String = ""
            if let valueStr = value as? String {
                valueCast = valueStr
            } else if let valueInt = value as? Int {
                valueCast = String(valueInt)
            } else if let valueBool = value as? Bool {
                valueCast = String(valueBool)
            }
            params += "&" + key + "=" + valueCast
        }) {
            URLRequest.append(contentsOf: parametersFormattedString)
        }
        
        return URLRequest
    }
    
    func fetchConfiguration(request: TheMovieDB.Configuration.Request, completionHandler: @escaping (TheMovieDB.Configuration.Response) -> Void)
    {
        let urlRequest = self.getURLRequest(endpoint: "/configuration")
        var request = URLRequest(url: URL(string: urlRequest)!)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request, completionHandler: { data, response, error -> Void in
            do {
                let jsonDecoder = JSONDecoder()
                let responseModel = try jsonDecoder.decode(TheMovieDB.Configuration.Response.self, from: data!)
                
                DispatchQueue.main.async {
                    completionHandler(responseModel)
                }
            } catch {
                print("JSON Serialization error")
                print(error)
            }
        }).resume()
    }
    
    func getConfiguration(completionHandler: @escaping (TheMovieDB.Configuration.Response) -> Void) {
        if (self.configuration != nil) {
            completionHandler(self.configuration)
        } else {
            if let localConfiguration = getMostRecentLocalConfiguration() {
                self.configuration = localConfiguration
                completionHandler(self.configuration)
            } else {
                self.fetchConfiguration(request: TheMovieDB.Configuration.Request()) { (response) in
                    self.saveLocalConfiguration(configuration: response)
                    self.configuration = response
                    completionHandler(self.configuration)
                }
            }
        }
    }
    
    private func saveLocalConfiguration(configuration: TheMovieDB.Configuration.Response) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let entityConfiguration = NSEntityDescription.entity(forEntityName: "Configuration", in: context)
        let entityConfigurationImages = NSEntityDescription.entity(forEntityName: "ConfigurationImages", in: context)
        
        let newConfigurationImages = NSManagedObject(entity: entityConfigurationImages!, insertInto: context)
        newConfigurationImages.setValue(configuration.images?.base_url, forKey: "base_url")
        newConfigurationImages.setValue(configuration.images?.secure_base_url, forKey: "secure_base_url")
        newConfigurationImages.setValue(configuration.images?.backdrop_sizes, forKey: "backdrop_sizes")
        newConfigurationImages.setValue(configuration.images?.logo_sizes, forKey: "logo_sizes")
        newConfigurationImages.setValue(configuration.images?.poster_sizes, forKey: "poster_sizes")
        newConfigurationImages.setValue(configuration.images?.profile_sizes, forKey: "profile_sizes")
        newConfigurationImages.setValue(configuration.images?.still_sizes, forKey: "still_sizes")
        
        let newConfiguration = NSManagedObject(entity: entityConfiguration!, insertInto: context)
        newConfiguration.setValue(newConfigurationImages, forKey: "images")
        newConfiguration.setValue(configuration.change_keys, forKey: "change_keys")
        newConfiguration.setValue(Date(), forKey: "update_date")
        
        do {
            try context.save()
        } catch {
            print("Failed saving")
        }
    }
    
    private func getMostRecentLocalConfiguration() -> TheMovieDB.Configuration.Response? {
        var configuration: TheMovieDB.Configuration.Response?
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Configuration")
        request.sortDescriptors = [NSSortDescriptor(key: "update_date", ascending: false)]
        request.fetchLimit = 1
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                var configurationImage: Images?
                if let images = data.value(forKey: "images") as? NSManagedObject {
                    configurationImage = Images.init(
                        base_url: images.value(forKey: "base_url") as? String,
                        secure_base_url: images.value(forKey: "secure_base_url") as? String,
                        backdrop_sizes: images.value(forKey: "backdrop_sizes") as? [String],
                        logo_sizes: images.value(forKey: "logo_sizes") as? [String],
                        poster_sizes: images.value(forKey: "poster_sizes") as? [String],
                        profile_sizes: images.value(forKey: "profile_sizes") as? [String],
                        still_sizes: images.value(forKey: "still_sizes") as? [String]
                    )
                }
                configuration = TheMovieDB.Configuration.Response.init(
                    images: configurationImage,
                    change_keys: data.value(forKey: "change_keys") as? [String]
                )
            }
        } catch {
            print("Failed")
            return nil
        }
        
        return configuration
    }
}
