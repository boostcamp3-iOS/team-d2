//
//  Database.swift
//  DaumWebtoon
//
//  Created by oingbong on 13/02/2019.
//  Copyright © 2019 Gaon Kim. All rights reserved.
//

import Foundation
import SQLite3

class Database {
    enum SQLError: Error {
        case open
        case prepare
        case step
        case bind
        case other
    }
    
    var db: OpaquePointer?
    var stmt: OpaquePointer?
    
    private func dbPath() -> String {
        let fileManager = FileManager.default
        // Create
        guard let docPathUrl = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else { return "" }
        let dbPath = docPathUrl.appendingPathComponent("podcase.sqlite").path
        return dbPath
    }
    
    func create(with sql: String) throws {
        guard open() else { throw SQLError.open }
        defer { close() }
        
        guard prepare(with: sql) else { throw SQLError.prepare }
        defer { finalize() }
        
        guard step() == SQLITE_DONE else { throw SQLError.step }
    }
    
    func select(with sql: String) throws -> [Episode] {
        let dbPath = self.dbPath()

        guard open() else { throw SQLError.open }
        defer { close() }

        guard prepare(with: sql) else { throw SQLError.prepare }
        defer { finalize() }

        var episodes = [Episode]()
        while step() == SQLITE_ROW {
            let id = columnText(at: 0)
            let duration = columnInt(at: 1)
            let audio = columnText(at: 2)
            let image = columnText(at: 3)
            let thumbnail = columnText(at: 4)
            let description = columnText(at: 5)
            let channelTitle = columnText(at: 6)
            let title = columnText(at: 7)
            let dateTime = columnInt(at: 8)
            let episode = Episode(id: id, duration: Int(duration), audio: audio, image: image, thumbnail: thumbnail, description: description, channelTitle: channelTitle, title: title, dateTime: Int(dateTime))
            episodes.append(episode)
        }
        return episodes
    }
    
    func insert(with sql: String, episode: Episode) throws {
        guard open() else { throw SQLError.open }
        defer { close() }

        guard prepare(with: sql) else { throw SQLError.prepare }
        guard bindText(with: episode.id, at: 0) else { throw SQLError.bind }
        guard bindInt(with: episode.duration, at: 1) else { throw SQLError.bind }
        guard bindText(with: episode.audio, at: 2) else { throw SQLError.bind }
        guard bindText(with: episode.image, at: 3) else { throw SQLError.bind }
        guard bindText(with: episode.thumbnail, at: 4) else { throw SQLError.bind }
        guard bindText(with: episode.description, at: 5) else { throw SQLError.bind }
        guard bindText(with: episode.channelTitle, at: 6) else { throw SQLError.bind }
        guard bindText(with: episode.title, at: 7) else { throw SQLError.bind }
        guard bindInt(with: episode.dateTime, at: 8) else { throw SQLError.bind }
        guard step() == SQLITE_DONE else { throw SQLError.step }
    }

    func delete(with sql: String) throws {
        guard open() else { throw SQLError.open }
        defer { close() }

        guard prepare(with: sql) else { throw SQLError.prepare }
        guard step() == SQLITE_DONE else { throw SQLError.step }
    }

    func drop() {
        let dbPath = self.dbPath()
        let fileManager = FileManager.default
        let fileUrl = URL(fileURLWithPath: dbPath)
        do {
            try fileManager.removeItem(at: fileUrl)
        } catch let error {
            print(error.localizedDescription)
        }
    }
}

// MARK: - Basic Method
extension Database {
    private func open() -> Bool {
        let dbPath = self.dbPath()
        return sqlite3_open(dbPath, &db) == SQLITE_OK ? true : false
    }
    
    private func close() {
        sqlite3_close(db)
    }
    
    private func prepare(with sql: String) -> Bool {
        return sqlite3_prepare(db, sql, -1, &stmt, nil) == SQLITE_OK ? true : false
    }
    
    private func finalize() {
        sqlite3_finalize(stmt)
    }
    
    private func step() -> Int32 {
        return sqlite3_step(stmt)
    }
    
    private func bindText(with text: String?, at index: Int32) -> Bool {
        guard let text = text else {
            sqlite3_bind_null(stmt, index)
            return true
        }
        let transient = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
        return sqlite3_bind_text(stmt, index, text, -1, transient) == SQLITE_OK ? true : false
    }
    
    private func bindInt(with value: Int?, at index: Int32) -> Bool {
        guard let value = value else {
            sqlite3_bind_null(stmt, index)
            return true
        }
        return sqlite3_bind_int(stmt, index, Int32(value)) == SQLITE_OK ? true : false
    }
    
    private func columnText(at index: Int32) -> String {
        guard let text = sqlite3_column_text(stmt, index) else { return "" }
        let result = String(cString: text)
        return result
    }
    
    private func columnInt(at index: Int32) -> Int32 {
        return sqlite3_column_int(stmt, index)
    }
    
    private func errorMessage() -> String {
        let result = String(cString: sqlite3_errmsg(db))
        return result
    }
}
