import Brick
import Spots
import Tailor
import UIKit

public enum InputFieldAlignment: String {
  case center = "center", left = "left"
}

open class InputFieldListView: UITableViewCell, SpotConfigurable {

  public enum KeyboardType: String {
    case Number = "number"
    case PhoneNumber = "phone_number"
    case Email = "email"
    case Text = "text"

    public static func defaultValue() -> KeyboardType {
      return .Text
    }
  }

  class Meta: Mappable {
    var keyboardType: KeyboardType = KeyboardType.defaultValue()
    var insets = UIEdgeInsets.zero
    var styles: String = ""
    var alignment: String = InputFieldAlignment.center.rawValue

    required init(_ map: [String : Any]) {
      self.insets.top <- map.property("inset-top")
      self.insets.bottom <- map.property("inset-bottom")
      self.insets.left <- map.property("inset-left")
      self.insets.right <- map.property("inset-right")
      self.styles <- map.property("styles")
      self.alignment <- map.property("alignment")

      if let keyboardType = KeyboardType(rawValue: map.property("keyboard-type") ?? "") {
        self.keyboardType <- keyboardType
      }
    }
  }

  public var preferredViewSize = CGSize(width: 0, height: 180)

  open lazy var textFieldLabel: UILabel = UILabel()
  open lazy var textField: UITextField = UITextField()
  open lazy var loadingView = UIView()

  lazy var gradient: CAGradientLayer = {
    let gradient = CAGradientLayer()
    gradient.colors = [
      UIColor(hex:"#FFFFFF").cgColor,
      UIColor(hex:"#FFFFFF").cgColor,
      UIColor(hex:"#FFFFFF").cgColor,
      UIColor(hex:"#999999").cgColor,
      UIColor(hex:"#FFFFFF").cgColor,
      UIColor(hex:"#FFFFFF").cgColor,
      UIColor(hex:"#FFFFFF").cgColor
    ]
    return gradient
  }()

  lazy var animation: CABasicAnimation = { [unowned self] in
    let animation = CABasicAnimation(keyPath: "position")
    animation.duration = 3.0
    animation.isRemovedOnCompletion = false
    animation.repeatCount = 1000
    animation.autoreverses = false

    return animation
    }()

  var loading: Bool? {
    didSet {
      guard let loading = loading else { return }
      if loading {
        let pointSize = textField.font?.pointSize ?? 1.0
        let textMask = CATextLayer()

        textMask.contentsScale = UIScreen.main.scale
        textMask.frame = CGRect(origin: CGPoint(x: 0, y: pointSize / 2),
                                size: textField.frame.size)
        textMask.foregroundColor = UIColor.white.cgColor
        textMask.string = textField.text
        textMask.font = textField.font
        textMask.fontSize = pointSize
        textMask.alignmentMode = kCAAlignmentCenter

        loadingView.frame = textField.frame
        loadingView.layer.mask = textMask

        animation.fromValue = NSValue(cgPoint: CGPoint(x: -textField.frame.size.width, y: -textField.frame.size.height))
        animation.toValue = NSValue(cgPoint: CGPoint(x: textField.frame.size.width * 2, y: textField.frame.size.height * 2))

        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 0.25)
        gradient.frame.size = textField.frame.size
        gradient.add(animation, forKey: "Change Colors")

        loadingView.backgroundColor = UIColor.white
        loadingView.layer.insertSublayer(gradient, at: 0)
        loadingView.alpha = 0.0

        contentView.addSubview(loadingView)
        textField.alpha = 0.0
        loadingView.alpha = 1.0
      } else {
        UIView.animate(withDuration: 0.1, animations: {
          self.textField.alpha = 1.0
          self.loadingView.alpha = 0.0
          }, completion: { _ in
            self.loadingView.removeFromSuperview()
        })
      }
    }
  }

  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    selectedBackgroundView = UIView()
    selectedBackgroundView?.backgroundColor = UIColor.clear
    selectionStyle = .none
    [textFieldLabel, textField].forEach { contentView.addSubview($0) }
  }

  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  public func configure(_ item: inout Item) {
    let meta: Meta = item.metaInstance()
    styles = meta.styles
    backgroundColor = UIColor.clear

    textFieldLabel.text = item.title
    textFieldLabel.sizeToFit()

    if meta.alignment == InputFieldAlignment.center.rawValue {
      textFieldLabel.centerInSuperview()
    }
    textFieldLabel.frame.origin.y = meta.insets.top

    textField.sizeToFit()
    textField.frame.size.width = contentView.frame.size.width

    let placeholderText = NSAttributedString(string: item.subtitle.uppercased(),
                                             attributes: [
                                              NSForegroundColorAttributeName : textFieldLabel.textColor.alpha(0.5)
      ])
    textField.attributedPlaceholder = placeholderText

    if meta.alignment == InputFieldAlignment.center.rawValue {
      textFieldLabel.centerInSuperview()
    }

    if !item.image.isEmpty {
      textField.leftView = UIImageView(image: UIImage(named: item.image))
      textField.leftView?.contentMode = .scaleAspectFit
      textField.leftView?.frame.size.width = 48
      textField.leftViewMode = .always
    }

    textField.frame.origin.y = textFieldLabel.frame.maxY
    textField.frame.origin.x = meta.insets.left
    textField.frame.size.width -= meta.insets.left + meta.insets.right
    textField.frame.size.height = (textField.font?.pointSize ?? 18) * 2.5

    switch meta.keyboardType {
    case .Email:
      textField.keyboardType = .emailAddress
    case .PhoneNumber:
      textField.keyboardType = .phonePad
    case .Number:
      textField.keyboardType = .numberPad
    default:
      textField.keyboardType = .default
    }

    item.size.height = textField.frame.maxY + meta.insets.top + meta.insets.bottom
  }

  override open func layoutSubviews() {
    super.layoutSubviews()
    
    textField.layer.cornerRadius = textField.frame.size.height / 2
  }
}

extension UIView {

  func centerInSuperview() {
    guard let superview = superview else { return }

    frame.origin = CGPoint(
      x: superview.frame.width / 2 - frame.width / 2,
      y: superview.frame.height / 2 - frame.height / 2)
  }
}
