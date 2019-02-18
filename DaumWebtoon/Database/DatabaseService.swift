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
            dateTime INTEGER,
            episodeId TEXT PRIMARY KEY,
            FOREIGN KEY(episodeId) REFERENCES \(TableCategory.episode)(id)
        )
        """
        try? database.create(with: sql)
    }
    
    private func createRecentTable() {
        let sql = """
        CREATE TABLE IF NOT EXISTS \(TableCategory.recent) (
            dateTime INTEGER,
            episodeId TEXT PRIMARY KEY,
            FOREIGN KEY(episodeId) REFERENCES \(TableCategory.episode)(id)
        )
        """
        try? database.create(with: sql)
    }
    
    // MARK: - Select
    func selectInEpisode(with episode: Episode) -> [Episode]? {
        let sql = """
        SELECT * FROM \(TableCategory.episode)
        WHERE id = '\(episode.id)'
        """
        guard let episodes = try? database.selectInEpisode(with: sql) else { return nil }
        return episodes
    }
    
    func selectInDependent(from category: TableCategory) -> [Episode]? {
        let another = TableCategory.episode
        let sql = """
        SELECT \(another).id, \(another).duration,
            \(another).audio, \(another).image,
            \(another).thumbnail, \(another).description,
            \(another).channelTitle, \(another).title,
            \(category).dateTime
        FROM \(another) INNER JOIN \(category)
        ON \(another).id = \(category).episodeId
        """
        guard let episodes = try? database.selectInEpisode(with: sql) else { return nil }
        return episodes
    }
    
    func isFavoriteEpisode(of episode: Episode) -> Bool {
        let category = TableCategory.favorite
        let another = TableCategory.episode
        let sql = """
        SELECT \(another).id, \(another).duration,
        \(another).audio, \(another).image,
        \(another).thumbnail, \(another).description,
        \(another).channelTitle, \(another).title,
        \(category).dateTime
        FROM \(another) INNER JOIN \(category)
        ON \(another).id = \(category).episodeId
        WHERE \(category).episodeId = '\(episode.id)'
        """
        guard let episdoes = try? database.selectInEpisode(with: sql) else { return false }
        let isFavorite = episdoes.count == 1 ? true : false
        return isFavorite
    }
    
    private func hasDependentEpisode(of episode: Episode, from category: TableCategory) -> Bool {
        let another = TableCategory.episode
        let sql = """
        SELECT \(another).id, \(another).duration,
        \(another).audio, \(another).image,
        \(another).thumbnail, \(another).description,
        \(another).channelTitle, \(another).title,
        \(category).dateTime
        FROM \(another) INNER JOIN \(category)
        ON \(another).id = \(category).episodeId
        WHERE \(category).episodeId = '\(episode.id)'
        """
        guard let episdoes = try? database.selectInEpisode(with: sql) else { return false }
        let isFavorite = episdoes.count == 1 ? true : false
        return isFavorite
    }
    
    // MARK: - Favorite
    func manageFavoriteEpisode(with episode: Episode, state: Bool) {
        state ? delete(from: .favorite, target: episode) : addFavoriteEpisode(with: episode)
    }
    
    private func addFavoriteEpisode(with episode: Episode) {
        /*
         1. 에피소드 테이블에서 찾기
         2. 에피소드 테이블에 없으면 에피소드 테이블에 insert, favorite 테이블에 insert
         3. 에피소드 테이블에 있으면 favorite 테이블에만 insert
         */
        if let findEpisodes = selectInEpisode(with: episode),
            findEpisodes.count > 0 {
            self.insertInEpisode(with: episode)
        }
        self.insertInDependent(with: episode, from: .favorite)
    }
    
    // MARK: - Recent
    func addRecentEpisode(with episode: Episode) {
        /*
         1. 에피소드 테이블에서 찾기
         2. 에피소드 테이블에 없으면 에피소드 테이블에 insert, recent 테이블에 insert
         3. 에피소드 테이블에 있고 recent 테이블에 없으면 insert
         4. 에피소드 테이블에 있고 recent 테이블에 있으면 update (dateTime)
         */
        if let findEpisodes = selectInEpisode(with: episode),
            findEpisodes.count > 0 {
            self.insertInEpisode(with: episode)
        }
        
        if hasDependentEpisode(of: episode, from: .recent) {
            self.insertInDependent(with: episode, from: .recent)
        }
        
        updateEpisode(of: episode, from: .recent)
    }
    
    private func updateEpisode(of episode: Episode, from category: TableCategory) {
        let sql = """
        UPDATE \(category)
        SET dateTime = \(dateTime())
        WHERE episodeId = '\(episode.id)'
        """
        try? database.update(with: sql)
    }
    
    // MARK: - Insert
    private func insertInEpisode(with episode: Episode) {
        let sql = """
        INSERT INTO \(TableCategory.episode) (
            id, duration, audio, image, thumbnail, description, channelTitle, title)
            VALUES (?,?,?,?,?,?,?,?)
        """
        try? database.insertInEpisode(with: sql, episode: episode)
    }
    
    private func insertInDependent(with episode: Episode, from category: TableCategory) {
        let sql = """
        INSERT INTO \(category) (
        dateTime, episodeId)
        VALUES (?,?)
        """
        let data = DependentTable(dateTime: dateTime(), episodeId: episode.id)
        try? database.insertInDependent(with: sql, data: data)
    }
    
    // MARK: - Delete
    private func delete(from category: TableCategory, target episode: Episode) {
        let idName = category == .episode ? "id" : "episodeId"
        let sql = "DELETE FROM \(category) WHERE \(idName) = '\(episode.id)'"
        try? database.delete(with: sql)
    }
    
    // MARK: - DateTime ( for Insert )
    private func dateTime() -> Int {
        let date = Date()
        let timeInterval = date.timeIntervalSince1970
        return Int(timeInterval)
    }
}
