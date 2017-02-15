import Spots
import Tailor
import UIKit

public enum InputFieldAlignment: String {
  case center, left
}

open class InputFieldListView: View, ItemConfigurable, ViewStateDelegate {

  public enum KeyboardType: String {
    case number
    case phoneNumber = "phone_number"
    case email
    case text

    public static func defaultValue() -> KeyboardType {
      return .text
    }
  }

  class Meta: Mappable {
    var keyboardType: KeyboardType = KeyboardType.defaultValue()
    var insets = UIEdgeInsets.zero
    var styles: String = ""
    var alignment: String = InputFieldAlignment.center.rawValue
    var staticHeight: Bool = false

    required init(_ map: [String : Any]) {
      self.insets.top <- map.property("inset-top")
      self.insets.bottom <- map.property("inset-bottom")
      self.insets.left <- map.property("inset-left")
      self.insets.right <- map.property("inset-right")
      self.styles <- map.property("styles")
      self.alignment <- map.property("alignment")
      self.staticHeight <- map.property("static-height")
      self.keyboardType <- map.enum("keyboard-type")
    }
  }

  public var preferredViewSize = CGSize(width: 0, height: 180)

  open lazy var infoLabel: UILabel = UILabel()
  open lazy var textField: UITextField = UITextField()
  open lazy var loadingView = UIView()

  /// Invoked when ever a view state is changed.
  ///
  /// - parameter viewState: The current view state.
  public func viewStateDidChange(_ viewState: ViewState) {
    if viewState == .selected {
      isUserInteractionEnabled = true
      textField.becomeFirstResponder()
    }
  }

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

  open lazy var animation: CABasicAnimation = { [unowned self] in
    let animation = CABasicAnimation(keyPath: "position")
    animation.duration = 3.0
    animation.isRemovedOnCompletion = false
    animation.repeatCount = 1000
    animation.autoreverses = false

    return animation
    }()

  open var loading: Bool? {
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

        addSubview(loadingView)
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

  override init(frame: CGRect) {
    super.init(frame: frame)
    [infoLabel, textField].forEach { addSubview($0) }
  }

  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  public func configure(_ item: inout Item) {
    let meta: Meta = item.metaInstance()
    styles = meta.styles
    backgroundColor = UIColor.clear

    infoLabel.text = item.title
    infoLabel.sizeToFit()

    if meta.alignment == InputFieldAlignment.center.rawValue {
      infoLabel.centerInSuperview()
    }
    infoLabel.frame.origin.y = meta.insets.top

    textField.sizeToFit()
    textField.frame.size.width = frame.size.width
    textField.text = item.text

    let placeholderText = NSAttributedString(string: item.subtitle,
                                             attributes: [
                                              NSForegroundColorAttributeName : infoLabel.textColor.alpha(0.5)
      ])
    textField.attributedPlaceholder = placeholderText

    if meta.alignment == InputFieldAlignment.center.rawValue {
      infoLabel.centerInSuperview()
      infoLabel.frame.origin.y = infoLabel.frame.origin.y - 7.5
    }

    if !item.image.isEmpty {
      textField.leftView = UIImageView(image: UIImage(named: item.image))
      textField.leftView?.contentMode = .scaleAspectFit
      textField.leftView?.frame.size.width = 48
      textField.leftViewMode = .always
    }

    textField.frame.origin.y = infoLabel.frame.maxY + 7.5
    textField.frame.origin.x = meta.insets.left

    configureType(meta: meta)

    textField.frame.size.width -= meta.insets.left + meta.insets.right

    if meta.staticHeight {
      textField.frame.size.height = (textField.font?.pointSize ?? 18) * 2.75
      textField.centerVertically()
      infoLabel.frame.origin.y = textField.frame.origin.y - infoLabel.frame.size.height - 7.5
    } else {
      textField.frame.size.height = (textField.font?.pointSize ?? 18) * 2.5
      item.size.height = textField.frame.maxY + meta.insets.top + meta.insets.bottom
    }
  }

  func configureType(meta: Meta) {
    switch meta.keyboardType {
    case .email:
      textField.keyboardType = .emailAddress
    case .phoneNumber:
      textField.keyboardType = .phonePad
    case .number:
      textField.keyboardType = .numberPad
    default:
      textField.keyboardType = .default
    }
  }

  override open func layoutSubviews() {
    super.layoutSubviews()

    textField.layer.cornerRadius = textField.frame.size.height / 2
  }

  open override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
    let result = super.point(inside: point, with: event)
    let insidePoint = convert(point, to: textField)
    return result && textField.point(inside: insidePoint, with: event)
  }
}
