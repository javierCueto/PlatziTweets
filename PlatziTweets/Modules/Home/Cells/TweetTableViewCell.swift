//
//  TweetTableViewCell.swift
//  PlatziTweets
import UIKit
import Kingfisher

class TweetTableViewCell: UITableViewCell {
    //MARK: - IBOutlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var tweetImageView: UIImageView!
    @IBOutlet weak var videoButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    
    
    //las celdas nunca deben invocar un view controllers
    
    @IBAction func openVideoAction() {
        guard let videoUrl = videoURL else{
            return
        }
        
        needsToShowVideo?(videoUrl)
    }
    
    private var videoURL: URL?
    var needsToShowVideo: ((_ url: URL )-> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupCellWith(post: Post){
        videoButton.isHidden = !post.hasVideo
        nameLabel.text = post.author.names
        nickNameLabel.text = post.author.nickname
        messageLabel.text = post.text
        if post.hasImage{
            tweetImageView.isHidden = false
            tweetImageView.kf.setImage(with: URL(string: post.imageUrl))
        }else{
            tweetImageView.isHidden = true
        }
        
        videoURL = URL(string: post.videoUrl)
    }
    
}
