
import UIKit

final class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction private func showTrial(_ sender: UIButton) {
        Router.showTrial1(from: self)
    }
    
    @IBAction private func showTrial2(_ sender: UIButton) {
        Router.showTrial2(from: self)
    }
    
    @IBAction private func showTrial3(_ sender: UIButton) {
        Router.showTrial3(from: self)
    }
    
    @IBAction private func showPractice1(_ sender: UIButton) {
        Router.showPractice1(from: self)
    }
}
