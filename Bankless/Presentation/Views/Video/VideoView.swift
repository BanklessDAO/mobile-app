//
//  Created with ♥ by BanklessDAO contributors on 2021-11-17.
//  Copyright (C) 2021 BanklessDAO.

//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU Affero General Public License as
//  published by the Free Software Foundation, either version 3 of the
//  License, or (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU Affero General Public License for more details.
//
//  You should have received a copy of the GNU Affero General Public License
//  along with this program.  If not, see https://www.gnu.org/licenses/.
//
    

import Foundation
import UIKit
import Cartography
import RxSwift
import RxCocoa
import Kingfisher
import AVKit

class VideoView: BaseView<VideoViewModel> {
    // MARK: - Constants -
    
    private static let playControlSize: CGSize = .init(width: 100, height: 100)
    private static let playButtonIcon: UIImage = .init(named: "play")!
    
    // MARK: - Properties -
    
    private var videoPlayer: AVPlayer!
    private var playerController: AVPlayerViewController!
    
    // MARK: - Subviews -
    
    private var thumbnailImageView: UIImageView!
    private var curtainView: UIView!
    private var playButton: UIButton!
    
    // MARK: - Initializers -
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        videoPlayer?.pause()
    }
    
    // MARK: - Setup -
    
    private func setUp() {
        clipsToBounds = true
        
        setUpSubviews()
        setUpConstraints()
    }
    
    private func setUpSubviews() {
        playerController = AVPlayerViewController()
        if #available(iOS 11.0, *) {
            playerController.entersFullScreenWhenPlaybackBegins = true
            playerController.exitsFullScreenWhenPlaybackEnds = true
        }
        insertSubview(playerController.view, at: 0)
        
        thumbnailImageView = UIImageView()
        thumbnailImageView.contentMode = .scaleAspectFill
        addSubview(thumbnailImageView)
        
        curtainView = UIView()
        curtainView.backgroundColor = .black.withAlphaComponent(0.80)
        addSubview(curtainView)
        
        playButton = UIButton(type: .custom)
        playButton.setImage(VideoView.playButtonIcon, for: .normal)
        playButton.rx.tap.asDriver()
            .drive(onNext: { [weak self] in self?.play() })
            .disposed(by: disposer)
        addSubview(playButton)
    }
    
    private func setUpConstraints() {
        constrain(playerController.view, self) { (player, view) in
            player.edges == view.edges
        }
        
        constrain(
            thumbnailImageView, curtainView, playButton, self
        ) { (thumbnail, curtain, play, view) in
            thumbnail.edges == view.edges
            curtain.edges == view.edges
            
            play.center == view.center
            play.width == VideoView.playControlSize.width
            play.height == VideoView.playControlSize.height
        }
    }
    
    override func bindViewModel() {
        let output = viewModel.transform(input: .init())
        
        output.thumbnailURL
            .drive(onNext: { [weak self] url in self?.thumbnailImageView.kf.setImage(with: url) })
            .disposed(by: disposer)
        output.contentURL
            .drive(onNext: { [weak self] url in self?.set(contentURL: url) })
            .disposed(by: disposer)
    }
    
    // MARK: - Transitions -
    
    private func set(contentURL: URL) {
        playerController.player?.pause()
        
        let item = AVPlayerItem(url: contentURL)
    
        videoPlayer = AVPlayer(playerItem: item)
        playerController.player = videoPlayer
    }
    
    private func play() {
        videoPlayer?.play()
        
        playButton.isHidden = true
        thumbnailImageView.isHidden = true
    }
}
