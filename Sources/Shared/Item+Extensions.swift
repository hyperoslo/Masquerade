import Fashion
import Tailor
import UIKit

public extension Item {

  var styles: String {
    set { meta["styles"] = newValue }
    get { return meta.property("styles") ?? "" }
  }

  var imageHeight: CGFloat {
    set { meta["image-height"] = newValue }
    get { return meta.property("image-height") ?? 80.0 }
  }

  var dynamicHeight: Bool {
    set { meta["dynamic-height"] = newValue }
    get { return meta.property("dynamic-height") ?? false }
  }
}
