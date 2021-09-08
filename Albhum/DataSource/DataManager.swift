//
//  DataManager.swift
//  Albhum
//
//  Created by Sudha on 08/09/21.
//

import SwiftEx83
import RxSwift
import Alamofire
import RxAlamofire
import SwiftyJSON

typealias DataManager = RestServiceApi
let FILE_NAME = "albhumlist"
let ALBHUM_LIST_ENDPOINT = "albums"

extension DataManager
{
    
    static func getAlbhumList(serverSync : Bool) -> Observable<[AlbumsListResponse]> {
        
        //If the sync is taped, the request will send to server instead of fetching from local. request will send to server if serverSync is true
        guard serverSync else
        {
            //Verify the data is already stored locally. if so, get the data and don't hit the server
            if let list = getSavedAlbhumList()
            {
                return Observable.just(list)
            }
            return syncAlbhumList()
        }
        return syncAlbhumList()
        
    }
    
    //Hit the server to get the albhum list
    static func syncAlbhumList() -> Observable<[AlbumsListResponse]> {
        
        return get(url: serverUrl(ALBHUM_LIST_ENDPOINT)).map {(data: [AlbumsListResponse]) -> [AlbumsListResponse] in
            saveAlbhumList(albhumlist : data)
            return data
        }
    }
    
    //Returns the complete URL to hit the server
    private static func serverUrl(_ endpoint: String) -> String {
        return Configuration.getAPI() + endpoint
    }
    
    //Save albhum list locally
    private static func saveAlbhumList(albhumlist : [AlbumsListResponse])
    {
        do
        {
            try albhumlist.saveToFile(fileName: FILE_NAME)
        }
        catch
        {
            print("error")
        }
        
    }
    
    //Get stored albhum list
    private static func getSavedAlbhumList() -> [AlbumsListResponse]?
    {
        do {
            if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                let url = dir.appendingPathComponent(FILE_NAME)
                let data = try Data(contentsOf: url)
                let decoded = try JSONDecoder().decode([AlbumsListResponse].self, from: data)
                return decoded
            } else {
                //throw some error
            }
        } catch {
            print("error in reading file", error.localizedDescription)
        }
        return nil
    }
    
}

extension Array where Element: Encodable {
    
    func saveToFile(fileName: String) throws {
        do {
            let data = try JSONEncoder().encode(self)
            if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                let fileURL = dir.appendingPathComponent(fileName)
                try data.write(to: fileURL)
            } else {
                //throw some error
            }
        } catch {
            throw error
        }
    }
    
}
