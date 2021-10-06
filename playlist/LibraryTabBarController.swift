//
//  LibraryTabBarController.swift
//  playlist
//
//  Created by Atsuki Demizu on 2016/12/11.
//  Copyright © 2016年 Atsuki Demizu. All rights reserved.
//

import UIKit

class LibraryTabBarController : UITabBarController, PlayerServiceDelegate {
    private var _miniPlayer: MiniPlayerView?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let miniPlayer = Bundle.main.loadNibNamed("MiniPlayerView", owner: self, options: nil)?.first as? MiniPlayerView else {
            return
        }
        miniPlayer.frame.origin.y = tabBar.frame.origin.y - miniPlayer.bounds.size.height
        miniPlayer.isHidden = true
        miniPlayer.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewDidTap)))
        view.addSubview(miniPlayer)
        _miniPlayer = miniPlayer
    
        PlayerService.shared.delegate = self
    }

    /*
     * Interface Builder callbacks
     */
    @objc func viewDidTap(_ sender: AnyObject) {
        guard let controller = storyboard?.instantiateViewController(withIdentifier: "playerViewController") as? PlayerViewController else {
            return
        }
        present(controller, animated: true, completion: nil)
    }
    
    /*
     * PlayerServiceDelegate
     */
    func playlistDidSet() {
        _miniPlayer?.present()
    }
}
