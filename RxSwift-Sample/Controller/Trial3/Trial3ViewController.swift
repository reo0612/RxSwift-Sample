
import UIKit
import RxSwift
import RxCocoa

final class Trial3ViewController: UIViewController {

    @IBOutlet weak private var trialLabel: UILabel!
    @IBOutlet weak private var trialTextField: UITextField!
    @IBOutlet weak private var trialButton: UIButton!
    private let dispoceBag = DisposeBag()
    // SampleViewModelTypeプロトコルをsampleViewModelの型にする事によって
    // VCがViewModelにアクセスする時は必ずinputsかoutputsを経由しないといけなくなる
    // これによって、viewModelがインターフェース(input, output)でないプロパティに直接アクセスしてしまうことを防ぐ
    private var sampleViewModel: SampleViewModelType = SampleViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindInputStream()
        bindOutputStream()
    }
    // 入力
    private func bindInputStream() {
        // ViewModelに入力する
        // bindでViewModel.input.textObserverにストリームを送る
        trialTextField.rx.text.orEmpty
            .bind(to: sampleViewModel.input.textObserver)
            .disposed(by: dispoceBag)
        
        trialButton.rx.tap
            .bind(to: sampleViewModel.input.tapObserver)
            .disposed(by: dispoceBag)
    }
    
    // 出力
    private func bindOutputStream() {
        // ViewModelの出力を受け取る
        sampleViewModel.output.textObservable
            .bind(to: trialLabel.rx.text)
            .disposed(by: dispoceBag)
        
        sampleViewModel.output.tapObservable
            .subscribe {[weak self] _ in
                guard let self = self else { return }
                let url = URL(string: "https://ramendb.supleks.jp/")
                Router.showWeb(from: self, url: url!)
            }.disposed(by: dispoceBag)
    }

}
