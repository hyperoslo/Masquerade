import UIKit
import Masquerade
import Spots
import Brick
import Tailor

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, SpotsDelegate {

  var window: UIWindow?
  var masquerade = MasqueradeConfigurator()

  lazy var navigationController: UINavigationController = { [unowned self] in
    let controller = UINavigationController(rootViewController: self.viewController)
    return controller
    }()

  lazy var viewController: Controller = {
    let spot = ListSpot(component: Component(items: self.masquerade.items))
    let controller = Controller(spots: [spot])
    controller.delegate = self

    return controller
    }()

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

    window = UIWindow(frame: UIScreen.main.bounds)
    window?.rootViewController = navigationController
    window?.makeKeyAndVisible()

    return true
  }
}

extension AppDelegate {

  func didSelect(item: Item, in spot: Spotable) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate,
      let kind: String = item.meta.resolve(keyPath: "kind"),
      let itemKind = appDelegate.masquerade.lookup[kind],
      let view = itemKind.init() as? Masqueradable
      else { return }

    let spot: Spotable = Factory.resolve(component: type(of: view).variations())
    let controller = Controller(cacheKey: kind)
    controller.spots = [spot]
    controller.cache()

    navigationController.pushViewController(controller,
                                            animated: true)
  }
}
