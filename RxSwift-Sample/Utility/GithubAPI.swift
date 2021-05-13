
import Foundation
import RxSwift

final class GithubAPI {
    static let shared = GithubAPI()
    private init() {}
    
    private let host = "https://api.github.com"
    
    func get(searchWord: String, isDesc: Bool = true, complition: ((Result<[GithubModel], Error>) -> Void)? = nil) {
        let endPoint = "search/repositories"
        let parameter = "q=\(searchWord)&sort=stars&order=\(isDesc ? "desc" : "asc")"
        
        let urlStr = host + "/" + endPoint + "?" + parameter
        
        guard let url = URL(string: urlStr) else {
            print("url Error")
            return
        }
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, responce, error in
            if let error = error {
                complition?(.failure(error))
                return
            }
            
            guard
                let data = data,
                let decodeData = try? JSONDecoder().decode(GithubResponce.self, from: data),
                let models = decodeData.items else {
                    print("decodeError")
                    return
            }
            complition?(.success(models))
            
        }.resume()
    }
}

// 自作のGithubAPIクラスのメソッドをRx対応させる定型文

extension GithubAPI: ReactiveCompatible {}
extension Reactive where Base: GithubAPI {
    func get(searchWord: String, isDesc: Bool = true) -> Observable<[GithubModel]> {
        return Observable.create { observer in
            GithubAPI.shared.get(searchWord: searchWord, isDesc: isDesc) { result in
                switch result {
                case .success(let models):
                    // observerに対してイベントを流している(.onNext)
                    observer.on(.next(models))
                    
                case .failure(let error):
                    // observerに対してイベントを流している(.onError)
                    observer.on(.error(error))
                }
            }
            return Disposables.create()
        // 接続中に1回だけ処理呼ぶ
        }.share(replay: 1, scope: .whileConnected)
    }
}
