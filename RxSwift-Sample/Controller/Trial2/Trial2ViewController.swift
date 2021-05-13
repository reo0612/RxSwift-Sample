
import UIKit
import RxSwift
import RxCocoa
import RxGesture

final class Trial2ViewController: UIViewController {

    @IBOutlet weak private var colorNameLabel: UILabel!
    @IBOutlet weak private var redView: UIView!
    @IBOutlet weak private var blueView: UIView!
    @IBOutlet weak private var yellowView: UIView!
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // タップした時
        redView.rx.tapGesture()
            .when(.recognized)
            .subscribe {[weak self] _ in
                self?.colorNameLabel.text = "red"
                UIView.animate(withDuration: 0.2) {
                    self?.redView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                    
                } completion: { _ in
                    UIView.animate(withDuration: 0.2) {
                        self?.redView.transform = .identity
                    }
                }
                
            }.disposed(by: disposeBag)
        
        // 下にスワイプした時
        blueView.rx.swipeGesture(.down)
            .when(.recognized)
            .subscribe {[weak self] _ in
                self?.colorNameLabel.text = "blue"
                
                UIView.animate(withDuration: 0.2) {
                    self?.blueView.transform = CGAffineTransform(scaleX: 1, y: 2)
                    
                } completion: { _ in
                    UIView.animate(withDuration: 0.2) {
                        self?.blueView.transform = .identity
                    }
                }
                
            }.disposed(by: disposeBag)
        
        // 右か左にスワイプした時
        yellowView.rx.swipeGesture(.left, .right)
            .when(.recognized)
            .subscribe {[weak self] _ in
                self?.colorNameLabel.text = "yellow"
                
                UIView.animate(withDuration: 0.2) {
                    self?.yellowView.transform = CGAffineTransform(scaleX: 2, y: 1)
                }completion: { _ in
                    UIView.animate(withDuration: 0.2) {
                        self?.yellowView.transform = .identity
                    }
                }
                
            }.disposed(by: disposeBag)
    }
    
}
