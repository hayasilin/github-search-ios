//
//  DBManager.swift
//  GithubSearch
//
//  Created by kuanwei on 2021/5/15.
//

import Foundation
import FMDB

class DBManager: NSObject {
    static let tableRecentSearch = "recent_search"
    enum RecentSearchColumns: String {
        case term
        case time
    }

    private static let CREATE_TABLE_RECENT_SEARCH_COMMAND = """
    CREATE TABLE IF NOT EXISTS %@(\
    \(RecentSearchColumns.term.rawValue)    text        NOT NULL    PRIMARY KEY,\
    \(RecentSearchColumns.time.rawValue)    double\
    )
    """

    static let shared = DBManager()
    let databaseFileName = "github_search.sqlite"
    var dbURL: URL?
    var dbQueue: FMDatabaseQueue?

    override init() {
        super.init()
        let fileURL = try? FileManager.default
            .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            .appendingPathComponent(databaseFileName)
        dbURL = fileURL
    }

    deinit {
        dbQueue?.close()
    }

    // MARK: DB init & delete

    func initDatabase() {
        guard nil == dbQueue, let url = dbURL else {
            return
        }
        dbQueue = FMDatabaseQueue(url: url)
        createTableIfNotExist()
    }

    func deleteDatabase() {
        dbQueue?.close()
        dbQueue = nil
        guard let url = dbURL else {
            return
        }
        try? FileManager.default.removeItem(at: url)
    }

    func createTableIfNotExist() {
        dbQueue?.inDatabase { db in
            if !db.executeUpdate(String(format: DBManager.CREATE_TABLE_RECENT_SEARCH_COMMAND, DBManager.tableRecentSearch), withArgumentsIn: []) {
                Logger.log("table create failure: \(db.lastErrorMessage())", level: .error)
            }
        }
    }

    // MARK: DB upgrade

    func getUpgradeSqlCommand(withTableName tableName: String, newColumn: String, columnTypeString: String) -> String {
        return "ALTER TABLE \(tableName) ADD \(newColumn) \(columnTypeString)"
    }
}

// MARK: Common operation

extension DBManager {
    func deleteAllRowsInTable(tableName: String) -> Bool {
        guard let queue = dbQueue else {
            return false
        }

        var success: Bool = false
        queue.inDatabase { db in
            let queryString = String(format: "DELETE FROM %@", tableName)
            success = db.executeUpdate(queryString, withArgumentsIn: [])
        }
        return success
    }
}
