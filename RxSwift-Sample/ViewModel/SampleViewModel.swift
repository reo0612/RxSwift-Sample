
import Foundation
import RxSwift
import RxCocoa

protocol SampleViewModelInput {
    // 外部からの入力(VC)をObserverで受け取っている
    var textObserver: AnyObserver<String> { get }
    var tapObserver: AnyObserver<Void> { get }
}

protocol SampleViewModelOutput {
    // 加工して返す
    var textObservable: Observable<String> { get }
    var tapObservable: Observable<Void> { get }
}

protocol SampleViewModelType {
    var input: SampleViewModelInput { get }
    var output: SampleViewModelOutput { get }
}

final class SampleViewModel: SampleViewModelInput, SampleViewModelOutput {
    // 入力
    var textObserver: AnyObserver<String>
    var tapObserver: AnyObserver<Void>
    
    // 出力
    var textObservable: Observable<String>
    var tapObservable: Observable<Void>
    
    //初期化時にObserverで受信した値をVCに送るためにacceptでObservableにイベントを送る
    init() {
        // PublishRelayは.onNextのみ流せる
        // つまり、.errorや.completedが流れてこないことを保証する
        // 初期値を持たない
        let _textObservable = PublishRelay<String>()
        let _tapObservable = PublishRelay<Void>()
        
        // Observableを初期化している
        // VCに結果を渡したいのでObservable
        self.textObservable = _textObservable.asObservable()
        self.tapObservable = _tapObservable.asObservable()
        
        self.textObserver = AnyObserver<String>() { text in
            guard let text = text.element else {
                return
            }
            // VCに結果を返すためにObservableにonNextイベントを送る
            _textObservable.accept(text)
        }
        self.tapObserver = AnyObserver<Void>() { tap in
            guard let tap: Void = tap.element else {
                return
            }
            _tapObservable.accept(tap)
        }
    }
}

extension SampleViewModel: SampleViewModelType {
    var input: SampleViewModelInput {
        return self
    }
    
    var output: SampleViewModelOutput {
        return self
    }
    
}
