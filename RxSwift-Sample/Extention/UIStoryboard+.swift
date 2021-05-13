
import UIKit

extension UIStoryboard {
    static var main: MainViewController {
        UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() as! MainViewController
    }
    
    static var trial1: Trial1ViewController {
        UIStoryboard(name: "Trial1", bundle: nil).instantiateInitialViewController() as! Trial1ViewController
    }
    
    static var trial2: Trial2ViewController {
        UIStoryboard(name: "Trial2", bundle: nil).instantiateInitialViewController() as! Trial2ViewController
    }
    
    static var trial3: Trial3ViewController {
        UIStoryboard(name: "Trial3", bundle: nil).instantiateInitialViewController() as! Trial3ViewController
    }
    
    static var practice: PracticeViewController {
        UIStoryboard(name: "Practice", bundle: nil).instantiateInitialViewController() as! PracticeViewController
    }
}
