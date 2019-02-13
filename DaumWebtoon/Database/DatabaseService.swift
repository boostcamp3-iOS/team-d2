//
//  DatabaseService.swift
//  DaumWebtoon
//
//  Created by oingbong on 13/02/2019.
//  Copyright © 2019 Gaon Kim. All rights reserved.
//

import Foundation

enum Category: CustomStringConvertible {
    case favorite, recent
    
    var description: String {
        switch self {
        case .favorite:
            return "FavoriteEpisode"
        case .recent:
            return "RecentEpisode"
        }
    }
}

class DatabaseService {
    let database = Database()
    let favorite = "Favorite"
    let recent = "Recent"
    
    // MARK: - Create
    func createTable() {
        createFavoriteTable()
        createRecentTable()
    }
    
    private func createFavoriteTable() {
        let sql = "CREATE TABLE IF NOT EXISTS \(favorite) (id TEXT PRIMARY KEY, duration INTEGER, audio TEXT, image TEXT, thumbnail TEXT, description TEXT, channelTitle TEXT, title TEXT, dateTime TEXT)"
        try? database.create(with: sql)
    }
    
    private func createRecentTable() {
        let sql = "CREATE TABLE IF NOT EXISTS \(recent) (id TEXT PRIMARY KEY, duration INTEGER, audio TEXT, image TEXT, thumbnail TEXT, description TEXT, channelTitle TEXT, title TEXT, dateTime TEXT)"
        try? database.create(with: sql)
    }
    
    // MARK: - Select
    func select(from category: Category) -> [Episode]? {
        let tableName = category == .favorite ? favorite : recent
        let sql = "SELECT * FROM \(tableName)"
        guard let episode = try? database.select(with: sql) else { return nil }
        return episode
    }
    
    // MARK: - Insert
    func insert(to category: Category, with episode: Episode) {
        let tableName = category == .favorite ? favorite : recent
        let sql = "INSERT INTO \(tableName) (id, duration, audio, image, thumbnail, description, channelTitle, title, dateTime) VALUES (?,?,?,?,?,?,?,?,?)"
        try? database.insert(with: sql, episode: episode)
    }
    
    // MARK: - Delete
    func delete(from category: Category, target episode: Episode) {
        let tableName = category == .favorite ? favorite : recent
        let sql = "DELETE FROM \(tableName) WHERE id = \(episode.id)"
        try? database.delete(with: sql)
    }
    
    // MARK: - DateTime ( for Insert )
    func dateTime() -> Int {
        let date = Date()
        let timeInterval = date.timeIntervalSince1970
        return Int(timeInterval)
    }
}
