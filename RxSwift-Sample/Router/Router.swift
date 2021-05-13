
import UIKit
import SafariServices

final class Router {
    static func showRoot(window: UIWindow) {
        let mainVC = UIStoryboard.main
        let navMainVC = UINavigationController(rootViewController: mainVC)
        window.rootViewController = navMainVC
        window.makeKeyAndVisible()
    }
    
    static func showTrial1(from: UIViewController) {
        let trial1 = UIStoryboard.trial1
        from.navigationController?.pushViewController(trial1, animated: true)
    }
    
    static func showTrial2(from: UIViewController) {
        let trial2 = UIStoryboard.trial2
        from.navigationController?.pushViewController(trial2, animated: true)
    }
    
    static func showTrial3(from: UIViewController) {
        let trial3 = UIStoryboard.trial3
        from.navigationController?.pushViewController(trial3, animated: true)
    }
    
    static func showPractice(from: UIViewController) {
        let practice = UIStoryboard.practice
        from.navigationController?.pushViewController(practice, animated: true)
    }
    
    static func showWeb(from: UIViewController, url: URL) {
        let safariVC = SFSafariViewController(url: url)
        from.present(safariVC, animated: true, completion: nil)
    }
}
