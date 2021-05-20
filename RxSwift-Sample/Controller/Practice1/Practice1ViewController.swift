
import UIKit
import RxSwift
import RxCocoa
import RxOptional

final class Practice1ViewController: UIViewController {

    @IBOutlet weak private var nameTextField: UITextField!
    @IBOutlet weak private var tableView: UITableView! {
        didSet {
            tableView.register(UINib(nibName: GithubTableViewCell.className, bundle: nil), forCellReuseIdentifier: GithubTableViewCell.className)
        }
    }
    
    @IBOutlet weak private var sortTypeSegementedControl: UISegmentedControl!
    
    let disposeBag = DisposeBag()
    
    private let githubViewModel = GithubViewModel()
    private lazy var input: GithubViewModelInput = githubViewModel
    private lazy var output: GithubViewModelOutput = githubViewModel
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        bindInputStream()
        bindOutputStream()
    }
    
    private func bindInputStream() {
        // 文字列のストリーム
        // 入力されて5秒以上, nil及びemptyではない, 変化している, 文字数0以上
        let searchTextObservable = nameTextField.rx.text
            .debounce(RxTimeInterval.milliseconds(500), scheduler: MainScheduler.instance)
            .distinctUntilChanged().filterNil().filter({ $0.isNotEmpty })
        
        //ソートのストリーム
        let sortTypeObservable = Observable.merge(
            // just: 特定の観測可能なアイテム(ここではIntってこと？)を返す
          Observable.just(sortTypeSegementedControl.selectedSegmentIndex),
            sortTypeSegementedControl.rx.controlEvent(.valueChanged).map { self.sortTypeSegementedControl.selectedSegmentIndex }
        ).map { $0 == 0 }
        // ViewModel(Observer)にストリームを送信
        searchTextObservable.bind(to: input.searchTextObserver).disposed(by: disposeBag)
        sortTypeObservable.bind(to: input.sortTypeObserver).disposed(by: disposeBag)
    }
    
    private func bindOutputStream() {
        output.changeModelsObservable.observe(on: MainScheduler.instance).subscribe { _ in
                // observe(on: MainScheduler.instance)を使用してメインスレッドで処理する
                self.tableView.reloadData()
            
        } onError: { error in
            print(error.localizedDescription)
        output.modelsObservable.bind(to: tableView.rx.items(cellIdentifier: GithubTableViewCell.className, cellType: GithubTableViewCell.self)) {[weak self] _, element, cell in
            guard let self = self else { return }
            cell.configure(githubModel: element)
            
        }.disposed(by: disposeBag)
        
        tableView.rx.modelSelected(GithubModel.self).subscribe {[weak self] githubModel in
            guard let self = self else { return }
            guard let githubModel = githubModel.element else { return }
            Router.showWeb(from: self, url: URL(string: githubModel.htmlUrl)!)
        }.disposed(by: disposeBag)
    }
    
}

extension PracticeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = output.models[indexPath.row]
        Router.showWeb(from: self, url: URL(string: model.htmlUrl)!)
    }
}

extension PracticeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        output.models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: GithubTableViewCell.className, for: indexPath) as! GithubTableViewCell
        let githubModel = output.models[indexPath.row]
        cell.configure(githubModel: githubModel)
        return cell
    }

}
