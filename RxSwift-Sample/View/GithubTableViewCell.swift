
import UIKit

final class GithubTableViewCell: UITableViewCell {

    static var className: String { String(describing: GithubTableViewCell.self) }
    
    @IBOutlet weak private var nameLabel: UILabel!
    
    func configure(githubModel: GithubModel) {
        nameLabel.text = githubModel.name
    }
}
