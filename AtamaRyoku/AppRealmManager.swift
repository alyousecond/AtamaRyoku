//
//  AppRealmManager.swift
//  AtamaRyoku
//
//  Created by Yuji Sugaya on 2017/08/19.
//  Copyright © 2017年 Yuji Sugaya. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

struct AppRealmManager {
    func setUp() {
        let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let containerPath = (documentPath as NSString).appendingPathComponent("AtamaRyoku.realm")
        //let containerPath = (FileManager.default.di as NSString).appendingPathComponent()
        let config = Realm.Configuration(
            
            fileURL: URL.init(fileURLWithPath: containerPath),
            
            // 新しいスキーマバージョンを設定します。以前のバージョンより大きくなければなりません。
            // （スキーマバージョンを設定したことがなければ、最初は0が設定されています）
            schemaVersion: 2,
            
            // マイグレーション処理を記述します。古いスキーマバージョンのRealmを開こうとすると
            // 自動的にマイグレーションが実行されます。
            migrationBlock: { migration, oldSchemaVersion in
                // 最初のマイグレーションの場合、`oldSchemaVersion`は0です
                if (oldSchemaVersion < 3) {
                    // 何もする必要はありません！
                    // Realmは自動的に新しく追加されたプロパティと、削除されたプロパティを認識します。
                    // そしてディスク上のスキーマを自動的にアップデートします。
                    migration.enumerateObjects(ofType: RankingRLM.className()) { oldObject, newObject in
                        newObject!["day"] = dayString(date: oldObject!["rankingDate"] as! Date)
                    }
                }
        })
        
        // デフォルトRealmに新しい設定を適用します
        Realm.Configuration.defaultConfiguration = config
        
        // Realmファイルを開こうとしたときスキーマバージョンが異なれば、
        // 自動的にマイグレーションが実行されます
        let _ = try! Realm()
    }
}
