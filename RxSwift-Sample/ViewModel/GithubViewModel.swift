
import Foundation
import RxSwift
import RxCocoa
import NSObject_Rx

// 入力に関するプロトコル
protocol GithubViewModelInput {
    var searchTextObserver: AnyObserver<String> { get }
    var sortTypeObserver: AnyObserver<Bool> { get }
}

// 出力に関するプロトコル
protocol GithubViewModelOutput {
    var changeModelsObservable: Observable<Void> { get }
    var models: [GithubModel] { get }
    var modelsObservable: Observable<[GithubModel]> { get }
}

final class GithubViewModel: GithubViewModelInput, GithubViewModelOutput, HasDisposeBag {
    // inputについての記述
    // 入力側の定型文
    // Observable(VCからイベントを流し) -> Observerで受信 -> そのイベントをRelayに流す
    private let searchText = PublishRelay<String>()
    lazy var searchTextObserver: AnyObserver<String> = .init { event in
        guard let event = event.element else { return }
        // ObserverなのでViewControllerから流れてきたイベントをここで受け取る
        // Observable(発信者)にイベントを発信させるにはacceptを使用する
        self.searchText.accept(event)
    }
    // 入力側の定型文
    private let sortType = PublishRelay<Bool>()
    lazy var sortTypeObserver: AnyObserver<Bool> = .init { event in
        guard let event = event.element else { return }
        self.sortType.accept(event)
    }
    
    // outputについての記述
    // 出力側の定型文
    // 結果をVCに返すのでObservableを使用する
    private let _changeModelsObservable = PublishRelay<Void>()
    // Observableを代入し変数changeModelsObservableを初期化する
    lazy var changeModelsObservable = _changeModelsObservable.asObservable()
    private let _modelsObservable = PublishRelay<[GithubModel]>()
    lazy var modelsObservable = _modelsObservable.asObservable()
    
    // 最後に取得したデータ
    var models: [GithubModel] = []
    
    // 初期化時
    init() {
        // combineLatest:
        // 複数のObsrvableを監視し、常に最新の値をまとめて送信する
        // 用途:
        // 複数の変数を監視する必要がある場合（複数入力のバリデーションなど）,複数の値を組み合わせる処理
        
        // flatMapLatest:
        // 新たなObservableが生成されると前のObservableのsubscribeを中止し、最新のObservableをsubscribeする
        // 前のObservableのsubscribeを中止するためストリームが増えない
        // 用途:
        // 一番新しい処理結果を利用したいという実装（文字入力、API通信の結果表示など）
        
        Observable.combineLatest(
            searchText,
            sortType)
            .flatMapLatest({ (searchWord, sortType) -> Observable<[GithubModel]> in
                GithubAPI.shared.rx.get(searchWord: searchWord, isDesc: sortType)
                
            }).bind(to: _modelsObservable).disposed(by: disposeBag)
        
        // map:
        // Observableのイベントの要素を別の値に変換する(ここではModelにしている？)
        // 用途:
        // すべてのイベントに対して処理を適応したい場合
                
        }).map { [weak self] models in
            // 最後に得たデータを保存する
            self?.models = models
            // 値が更新したことを告げるためだけのストリームを流すのでVoidにする
            return
        }.bind(to: _changeModelsObservable).disposed(by: disposeBag)
    }
}
