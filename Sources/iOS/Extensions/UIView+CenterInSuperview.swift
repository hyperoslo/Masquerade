import UIKit

public extension UIView {

  public func centerInSuperview() {
    guard let superview = superview else { return }

    frame.origin = CGPoint(
      x: superview.frame.width / 2 - frame.width / 2,
      y: superview.frame.height / 2 - frame.height / 2)
  }

  public func centerVertically() {
    guard let superview = superview else { return }

    frame.origin.y = superview.frame.height / 2 - frame.height / 2
  }

  public func centerHorizontally() {
    guard let superview = superview else { return }

    frame.origin.x = superview.frame.width / 2 - frame.width / 2
  }
}
