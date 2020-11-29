//
//  MovieDetailViewController.swift
//  KMovies
//
//  Created by Justin Kumpe on 11/28/20.
//

import Foundation
import UIKit
import Kingfisher
import KumpeHelpers
import YoutubeKit

class MovieDetailViewController: UIViewController, YTSwiftyPlayerDelegate {

// MARK: scrollViews
    @IBOutlet weak var scrollView: UIScrollView!

// MARK: playerViews
    @IBOutlet weak var playerView: UIView!
    var player: YTSwiftyPlayer!

// MARK: labels
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelReleaseDate: UILabel!
    @IBOutlet weak var labelRating: UILabel!
    @IBOutlet weak var labelOverview: UILabel!
    @IBOutlet weak var textOverview: UILabel!

// MARK: buttons
    @IBOutlet weak var imageBackground: UIButton!

// MARK: properties
    var selectedMovie: TMDb_Movie!
    var trailerKey: String = ""

// MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.isDirectionalLockEnabled = true
    }

// MARK: viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        labelTitle.text = selectedMovie.title ?? "Unknown Title"
        labelReleaseDate.text = "Release Date: \(selectedMovie.release_date ?? "Unknown")"
        labelRating.text = "Rating: \(selectedMovie.vote_average ?? 0)/10"
        textOverview.text = selectedMovie.overview ?? ""
        if trailerKey == "" {
            playerView.isHidden = true
            imageBackground.isHidden = false
        }
        if let backgroundImage = selectedMovie.backdrop_path {
            let imageUrl = URL(string: "\(TMDb_Constants.BackDropUrl.w780.baseUrl)\(backgroundImage)")
            imageBackground.kf.setBackgroundImage(with: imageUrl, for: .normal)
        }
    }

// MARK: viewDidAppear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        TMDb_Client.getMovieTrailer(movie: selectedMovie) { (success, trailerKey) in
            if success {
                self.trailerKey = trailerKey!
                self.buildVideoPlayer()

            }
        }
    }

// MARK: viewWillDisappear
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        player.stopVideo()
    }

// MARK: buildVideoPlayer
    func buildVideoPlayer() {
        player = YTSwiftyPlayer(
            frame: CGRect(x: 0, y: 0, width: playerView.bounds.width, height: playerView.bounds.height),
            playerVars: [.videoID(trailerKey), .playsInline(true), VideoEmbedParameter.showRelatedVideo(false)])
        player.autoplay = true
        player.delegate = self
        playerView.addSubview(player)
        player.autoplay = true
        #if !targetEnvironment(simulator)
            playVideo()
        #endif
    }

// MARK: playVideo
    func playVideo() {
        player.loadPlayer()
        player.loadVideo(contentURL: "\(TMDb_Constants.trailerBaseURL)\(self.trailerKey)")
    }

    func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView.contentOffset.x>0 {
            scrollView.contentOffset.x = 0
        }
    }

// MARK: player: didChangeState
    func player(_ player: YTSwiftyPlayer, didChangeState state: YTSwiftyPlayerState) {
        switch state {
        case .ended:
            hidePlayer(true)
        case .playing:
            hidePlayer(false)
        case .unstarted:
            return
        case .paused:
            return
        case .buffering:
            hidePlayer(false)
        case .cued:
            return
        }
    }

// MARK: hidePlayer
    func hidePlayer(_ hide: Bool) {
        imageBackground.isHidden = !hide
        playerView.isHidden = hide
    }

// MARK: pressedBackgroundImage
    @IBAction func pressedBackgroundImage(_ sender: Any) {
        playVideo()
    }

}
