
import UIKit
import RxSwift
import RxCocoa

final class Trial1ViewController: UIViewController {
    
    @IBOutlet weak private var trialLabel: UILabel!
    @IBOutlet weak private var trialTextField: UITextField!
    // 観測状態からの解放を行う際に使う
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // orEmpty：受け取る値をStringに限定（String?からStringに変換） 空文字とnilは監視しない
        // bind：受け取った値とUIパーツへの関連付けをする
        // disposed：観測対象から除外する
        
        // rx.text~というのはRxSwifが提供しているObservable(監視されるもの, 監視可能なもの)である
        // 今回は、textFieldにtextが入力されたタイミングでイベントが発生する
        // そして、bindで受け取ってlabelに関連付けしている？
        trialTextField.rx.text.orEmpty
            .bind(to: trialLabel.rx.text)
            .disposed(by: disposeBag)
    }

}
