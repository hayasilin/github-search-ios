//
//  DBManager+RecentSearch.swift
//  GithubSearch
//
//  Created by kuanwei on 2021/5/15.
//

import Foundation

// MARK: Recent Search

extension DBManager {
    func storeRecentSearchTerm(searchTerm: String) -> Bool {
        guard let queue = dbQueue else {
            return false
        }

        let tableName = DBManager.tableRecentSearch
        // REPLACE INTO:
        // case 1: insert this seachTerm into table if it doesn't exist in table
        // case 2: delete the seachTerm row and append it to the last row of table
        let tableColumns = [RecentSearchColumns.term.rawValue, RecentSearchColumns.time.rawValue]
        let columnNames = tableColumns.joined(separator: ",")
        let valueNames = ":\(tableColumns.joined(separator: ",:"))"
        let command = String(format: "REPLACE INTO %@ (\(columnNames)) VALUES (\(valueNames))", tableName)

        let parameters: [String : Any] = [
            RecentSearchColumns.term.rawValue: searchTerm,
            RecentSearchColumns.time.rawValue: Date().timeIntervalSince1970
        ]

        var success: Bool = false
        queue.inDatabase { db in
            success = db.executeUpdate(command, withParameterDictionary: parameters)
            if !success {
                Logger.log(db.lastErrorMessage(), level: .error)
            }
        }
        return success
    }

    func retrieveRecentSearchTermList(completion: @escaping ([String]?) -> Void) {
        guard let queue = dbQueue else {
            completion(nil)
            return
        }
        DispatchQueue.global().async {
            var recentSearchTermList = [String]()
            let tableName = DBManager.tableRecentSearch
            queue.inDatabase { db in
                do {
                    let queryString = String(format: "SELECT * FROM %@ ORDER BY \(RecentSearchColumns.time.rawValue) DESC", tableName)
                    let resultSet = try db.executeQuery(queryString, values: [])

                    while resultSet.next(),
                        let recentSearchTerm = resultSet.string(forColumn: RecentSearchColumns.term.rawValue) {
                            recentSearchTermList.append(recentSearchTerm)
                    }
                } catch {
                    Logger.log(db.lastErrorMessage(), level: .error)
                }
            }
            completion(recentSearchTermList)
        }
    }

    func deleteRecentSearchTerm(_ searchTerm: String) -> Bool {
        guard let queue = dbQueue else {
            return false
        }

        let tableName = DBManager.tableRecentSearch
        var success: Bool = false
        queue.inDatabase { db in
            let queryString = String(format: "DELETE FROM %@ WHERE \(RecentSearchColumns.term.rawValue)=?", tableName)
            success = db.executeUpdate(queryString, withArgumentsIn: [searchTerm])
        }
        return success
    }

    func deleteAllRecentSearches() -> Bool {
        return deleteAllRowsInTable(tableName: DBManager.tableRecentSearch)
    }
}
