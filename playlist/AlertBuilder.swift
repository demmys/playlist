//
//  AlertBuilder.swift
//  playlist
//
//  Created by 出水　厚輝 on 2016/12/24.
//  Copyright © 2016年 Atsuki Demizu. All rights reserved.
//

import UIKit
import MediaPlayer

class AlertBuilder {
    static let TITLE_ACTION_INSERT = "Add next"
    static let TITLE_ACTION_APPEND = "Add last"
    static let TITLE_ACTION_CANCEL = "Cancel"

    private weak var _presentingViewController: UIViewController?
    
    init(presentingViewController: UIViewController) {
        _presentingViewController = presentingViewController
    }

    func presentAddPlaylistAlert(title: String?, items: [MPMediaItem]) {
        let controller = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
        let insertAction = UIAlertAction(title: AlertBuilder.TITLE_ACTION_INSERT, style: .default) { _ in
            PlayerService.shared.insertSongs(items)
        }
        let appendAction = UIAlertAction(title: AlertBuilder.TITLE_ACTION_APPEND, style: .default) { _ in
            PlayerService.shared.appendSongs(items)
        }
        let cancelAction = UIAlertAction(title: AlertBuilder.TITLE_ACTION_CANCEL, style: .cancel)
        controller.addAction(insertAction)
        controller.addAction(appendAction)
        controller.addAction(cancelAction)
        _presentingViewController?.present(controller, animated: true, completion: nil)
    }
}
