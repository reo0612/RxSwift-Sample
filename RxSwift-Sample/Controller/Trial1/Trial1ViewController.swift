
import UIKit
import RxSwift
import RxCocoa

final class Trial1ViewController: UIViewController {
    
    @IBOutlet weak private var trialLabel: UILabel!
    @IBOutlet weak private var trialTextField: UITextField!
    // 内部でDisposableを貯めておいて自身が解放された時に保持しているDisposableをdispose(廃棄)する
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // rx.text~というのはRxSwifが提供しているObservableである
        // 今回は、textFieldにtextが入力されたタイミングでイベントが発生してlabelと繋げる
        
        // orEmpty：受け取る値をStringに限定（String?からStringに変換） 空文字とnilは監視しない
        // bind(to: ~)：Observable/Observerに対してbindメソッドを使うと指定したものにイベントストリームを接続可能、単方向のデータバインディング、subscribeと同じ
        // disposed：DisposableをDisposeBagに貯める処理をしてくれる
        
        // bind利用(subscribeして値をセット)
//        trialTextField.rx.text.orEmpty
//            .bind(to: trialLabel.rx.text)
//            .disposed(by: disposeBag)
        
        // subscribe利用
        // 循環参照が起こるので弱参照にする
        trialTextField.rx.text.orEmpty.subscribe {[weak self] text in
            self?.trialLabel.text = text
            
        }.disposed(by: disposeBag)
    }
}
