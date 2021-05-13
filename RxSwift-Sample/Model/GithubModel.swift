
import Foundation

struct GithubResponce: Codable {
    let items: [GithubModel]?
}

struct GithubModel: Codable {
    let name: String
    let htmlUrl: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case htmlUrl = "html_url"
    }
}
