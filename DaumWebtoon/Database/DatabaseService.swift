//
//  DatabaseService.swift
//  DaumWebtoon
//
//  Created by oingbong on 13/02/2019.
//  Copyright © 2019 Gaon Kim. All rights reserved.
//

import Foundation

enum TableCategory: CustomStringConvertible {
    case episode
    case favorite
    case recent
    
    var description: String {
        switch self {
        case .episode:
            return "Episode"
        case .favorite:
            return "FavoriteEpisode"
        case .recent:
            return "RecentEpisode"
        }
    }
}

struct DependentTable {
    let dateTime: Int
    let episodeId: String
}

class DatabaseService {
    private let database = Database()
    
    // MARK: - Create
    func createTable() {
        createEpisodeTable()
        createFavoriteTable()
        createRecentTable()
    }
    
    private func createEpisodeTable() {
        let sql = """
        CREATE TABLE IF NOT EXISTS \(TableCategory.episode) (
            id TEXT PRIMARY KEY,
            duration INTEGER,
            audio TEXT,
            image TEXT,
            thumbnail TEXT,
            description TEXT,
            channelTitle TEXT,
            title TEXT
        )
        """
        try? database.create(with: sql)
    }
    
    private func createFavoriteTable() {
        let sql = """
        CREATE TABLE IF NOT EXISTS \(TableCategory.favorite) (
            dateTime INTEGER PRIMARY KEY,
            CONSTRAINT episodeId FOREIGN KEY(id) REFERENCES \(TableCategory.episode)(id)
        )
        """
        try? database.create(with: sql)
    }
    
    private func createRecentTable() {
        let sql = """
        CREATE TABLE IF NOT EXISTS \(TableCategory.recent) (
            dateTime INTEGER PRIMARY KEY,
            CONSTRAINT episodeId FOREIGN KEY(id) REFERENCES \(TableCategory.episode)(id)
        )
        """
        try? database.create(with: sql)
    }
    
    // MARK: - Select
    func selectInEpisode(with episode: Episode) -> [Episode]? {
        let sql = """
        SELECT * FROM \(TableCategory.episode)
        WHERE id = \(episode.id)
        """
        guard let episodes = try? database.selectInEpisode(with: sql) else { return nil }
        return episodes
    }
    
    func selectInDependent(with episode: Episode, from category: TableCategory) -> [Episode]? {
        let another = TableCategory.episode
        let sql = """
        SELECT \(another).id, \(another).audio,
            \(another).image, \(another).thumbnail,
            \(another).description, \(another).channelTitle,
            \(another).title,
            \(category).dateTime
        FROM \(another) INNER JOIN \(category)
        ON \(another).id = \(category).episodeId
        """
        guard let episodes = try? database.selectInEpisode(with: sql) else { return nil }
        return episodes
    }
    
    // MARK: - Insert
    func insertInEpisode(with episode: Episode) {
        let sql = """
        INSERT INTO \(TableCategory.episode) (
            id, duration, audio, image, thumbnail, description, channelTitle, title)
            VALUES (?,?,?,?,?,?,?,?)
        """
        try? database.insertInEpisode(with: sql, episode: episode)
    }
    
    func insertInDependent(with episode: Episode, from category: TableCategory) {
        let sql = """
        INSERT INTO \(category) (
        dateTime, episodeId)
        VALUES (?,?)
        """
        let data = DependentTable(dateTime: dateTime(), episodeId: episode.id)
        try? database.insertInDependent(with: sql, data: data)
    }
    
    // MARK: - Delete
    func delete(from category: TableCategory, target episode: Episode) {
        let idName = category == .episode ? "id" : "episodeId"
        let sql = "DELETE FROM \(category) WHERE \(idName) = \(episode.id)"
        try? database.delete(with: sql)
    }
    
    // MARK: - DateTime ( for Insert )
    func dateTime() -> Int {
        let date = Date()
        let timeInterval = date.timeIntervalSince1970
        return Int(timeInterval)
    }
}
