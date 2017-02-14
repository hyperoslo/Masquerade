import Spots
import Imaginary
import UIKit

open class CoreGridView : UICollectionViewCell, ItemConfigurable {

  public var preferredViewSize: CGSize = CGSize(width: 200, height: 285)

  public lazy var imageView: UIImageView = UIImageView()
  public lazy var titleLabel: UILabel = UILabel()
  public lazy var subtitleLabel: UILabel = UILabel()
  public lazy var textLabel: UILabel = UILabel()

  override init(frame: CGRect) {
    super.init(frame: frame)
    [imageView, titleLabel, subtitleLabel, textLabel]
      .forEach { contentView.addSubview($0) }
    configureLabels()
  }

  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func configureLabels() {
    [titleLabel, subtitleLabel, textLabel].forEach {
      $0.numberOfLines = 0
    }
  }

  public func configure(_ item: inout Item) {
    imageView.frame.size.height = 80
    imageView.frame.size.width = contentView.frame.width
    titleLabel.text = item.title
    subtitleLabel.text = item.subtitle
    textLabel.text = item.text

    [titleLabel, subtitleLabel, textLabel]
      .forEach {
        $0.frame.size.width = contentView.frame.width
        $0.sizeToFit()
    }

    if !item.image.isEmpty {
      if let url = URL(string: item.image), item.image.hasPrefix("http") {
        imageView.setImage(url: url) { [weak self] _ in
          self?.layoutSubviews()
        }
      } else {
        imageView.image = UIImage.init(named: item.image)
      }
    }

    item.size.height = textLabel.frame.maxY
  }

  open override func layoutSubviews() {
    super.layoutSubviews()

    imageView.frame.size.height = 80
    imageView.frame.size.width = contentView.frame.width
    titleLabel.frame.origin.y = imageView.frame.origin.y
    subtitleLabel.frame.origin.y = titleLabel.frame.maxY
    textLabel.frame.origin.y = subtitleLabel.frame.maxY
  }
}
