//
//  SongTableViewController.swift
//  playlist
//
//  Created by Atsuki Demizu on 2016/11/06.
//  Copyright © 2016年 Atsuki Demizu. All rights reserved.
//

import UIKit
import MediaPlayer

class SongTableViewController : UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let query = MPMediaQuery.artists()
        if let collections = query.collections {
            print("collections count: \(collections.count)")
            if let collection = collections.first {
                print("collection count: \(collection.count)")
                if let item = collection.representativeItem {
                    print("representive item: \(item.title)")
                }
            }
        }
        if let items = query.items {
            print("items count: \(items.count)")
            if let item = items.first {
                print("item: \(item.title)")
            }
        }
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return nil
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return nil
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "songCell", for: indexPath) as! SongTableViewCell
        cell.titleLabel.text = "sample title"
        cell.artistLabel.text = "sample artist"
        return cell
    }
}
