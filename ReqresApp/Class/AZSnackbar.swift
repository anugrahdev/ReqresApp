//
//  AZSnackbar.swift
//  ReqresApp
//
//  Created by AnangNugraha on 07/11/23.
//

import UIKit
import Darwin

// MARK: - Duration

public
enum AZSnackbarDuration: Int {
  case short = 1
  case middle = 3
  case long = 5
  case forever = 2147483647
}

// MARK: - Animation

public
enum AZSnackbarPosition: Int {
  case bottom
  case top
}

// MARK: - Typealias

public
typealias AZSnackbarActionCompletion = (_ snackbar: AZSnackbar) -> Void

public
typealias AZSnackbarDismissCompletion = (_ snackbar: AZSnackbar) -> Void

public
typealias AZSnackbarSwipeCompletion = (_ snackbar: AZSnackbar, _ direction: UISwipeGestureRecognizer.Direction) -> Void

// MARK: - AZSnackbar

open class AZSnackbar: UIView {
  // MARK: - Class property.

  public
  static var snackbarDefaultFrame: CGRect = CGRect(x: 0, y: 0, width: 320, height: 44)

  public
  static var snackbarMinHeight: CGFloat = 44

  // MARK: - Public property.

  open
  dynamic var onTapCompletion: AZSnackbarActionCompletion?

  open
  dynamic var onSwipeCompletion: AZSnackbarSwipeCompletion?

  open
  dynamic var shouldDismissOnSwipe: Bool = false

  open
  dynamic var shouldHonorSafeAreaLayoutGuides: Bool = true

  open
  dynamic var actionCompletion: AZSnackbarActionCompletion? = nil

  open
  dynamic var dismissCompletion: AZSnackbarDismissCompletion? = nil

  open
  dynamic var duration: AZSnackbarDuration = AZSnackbarDuration.short

  open
  dynamic var position: AZSnackbarPosition = AZSnackbarPosition.bottom

  open
  dynamic var animationDuration: TimeInterval = 0.3

  open
  dynamic var cornerRadius: CGFloat = 8 {
    didSet {
      cornerRadius = max(cornerRadius, 0)
      layer.cornerRadius = cornerRadius
      layer.masksToBounds = true
    }
  }

  open
  dynamic var snackbarMaxWidth: CGFloat = -1

  open
  dynamic var borderColor: UIColor? = .clear {
    didSet {
      layer.borderColor = borderColor?.cgColor
    }
  }

  open
  dynamic var borderWidth: CGFloat = 1 {
    didSet {
      layer.borderWidth = borderWidth
    }
  }

  open
  dynamic var topMargin: CGFloat = 8 {
    didSet {
      topMarginConstraint?.constant = topMargin
      superview?.layoutIfNeeded()
    }
  }

  open
  dynamic var bottomMargin: CGFloat = 8 {
    didSet {
      bottomMarginConstraint?.constant = -bottomMargin
      superview?.layoutIfNeeded()
    }
  }

  open
  dynamic var leftMargin: CGFloat = 8 {
    didSet {
      leftMarginConstraint?.constant = leftMargin
      superview?.layoutIfNeeded()
    }
  }

  open
  dynamic var rightMargin: CGFloat = 8 {
    didSet {
      rightMarginConstraint?.constant = -rightMargin
      superview?.layoutIfNeeded()
    }
  }

  open
  dynamic var contentInset: UIEdgeInsets = UIEdgeInsets.init(top: 0, left: 8, bottom: 0, right: 8) {
    didSet {
      contentViewTopConstraint?.constant = contentInset.top
      contentViewBottomConstraint?.constant = -contentInset.bottom
      contentViewLeftConstraint?.constant = contentInset.left
      contentViewRightConstraint?.constant = -contentInset.right
      layoutIfNeeded()
      superview?.layoutIfNeeded()
    }
  }

  open
  dynamic var messageContentInset: UIEdgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0) {
    didSet {
      messageLabel.contentInset = messageContentInset
    }
  }

  fileprivate(set) open
  dynamic var messageLabel: AZSnackbarLabel!

  open
  dynamic var message: String = "" {
    didSet {
      messageLabel.text = message
    }
  }

  open
    dynamic var messageTextColor: UIColor = UIColor.black {
    didSet {
      messageLabel.textColor = messageTextColor
    }
  }

  open
  dynamic var messageTextFont: UIFont = UIFont.boldSystemFont(ofSize: 14) {
    didSet {
      messageLabel.font = messageTextFont
    }
  }

  open
  dynamic var messageTextAlign: NSTextAlignment = .left {
    didSet {
      messageLabel.textAlignment = messageTextAlign
    }
  }

  fileprivate(set) open
  dynamic var actionButton: UIButton!

  open
  dynamic var actionText: String = "" {
    didSet {
      actionButton.setTitle(actionText, for: UIControl.State())
    }
  }

  open
  dynamic var actionIcon: UIImage? = nil {
    didSet {
      actionButton.setImage(actionIcon, for: UIControl.State())
    }
  }

  open
  dynamic var actionTextColor: UIColor = UIColor.black {
    didSet {
      actionButton.setTitleColor(actionTextColor, for: UIControl.State())
    }
  }

  open
  dynamic var actionTextFont: UIFont = UIFont.boldSystemFont(ofSize: 14) {
    didSet {
      actionButton.titleLabel?.font = actionTextFont
    }
  }

  open
  dynamic var actionMaxWidth: CGFloat = 64 {
    didSet {
      actionMaxWidth = max(actionMaxWidth, 44)
      actionButtonMaxWidthConstraint?.constant = actionButton.isHidden ? 0 : actionMaxWidth
      layoutIfNeeded()
    }
  }

  open
  dynamic var actionTextNumberOfLines: Int = 1 {
    didSet {
      actionButton.titleLabel?.numberOfLines = actionTextNumberOfLines
      layoutIfNeeded()
    }
  }

  fileprivate(set) open
  dynamic var iconImageView: UIImageView!

  open
  dynamic var icon: UIImage? = nil {
    didSet {
      iconImageView.image = icon
    }
  }

  open
  dynamic var iconContentMode: UIView.ContentMode = .center {
    didSet {
      iconImageView.contentMode = iconContentMode
    }
  }

  open
  dynamic var iconBackgroundColor: UIColor? = .clear {
    didSet {
      iconImageView.backgroundColor = iconBackgroundColor
    }
  }

  open
  dynamic var iconTintColor: UIColor! = .clear {
    didSet {
      iconImageView.tintColor = iconTintColor
    }
  }

  open
  dynamic var iconImageViewWidth: CGFloat = 32 {
    didSet {
      iconImageViewWidth = max(iconImageViewWidth, 32)
      iconImageViewWidthConstraint?.constant = iconImageView.isHidden ? 0 : iconImageViewWidth
      layoutIfNeeded()
    }
  }

  open
  dynamic var containerView: UIView?

  open
  dynamic var separateViewBackgroundColor: UIColor = UIColor.systemGray {
    didSet {
      separateView.backgroundColor = separateViewBackgroundColor
    }
  }

  open
  dynamic var animationSpringWithDamping: CGFloat = 0.7

  open
  dynamic var animationInitialSpringVelocity: CGFloat = 5

  // MARK: - Private property.

  fileprivate
  var contentView: UIView!

  fileprivate
  var separateView: UIView!

  fileprivate
  var dismissTimer: Timer? = nil

  fileprivate
  var keyboardIsShown: Bool = false

  fileprivate
  var keyboardHeight: CGFloat = 0

  // Constraints

  fileprivate
  var leftMarginConstraint: NSLayoutConstraint? = nil

  fileprivate
  var rightMarginConstraint: NSLayoutConstraint? = nil

  fileprivate
  var bottomMarginConstraint: NSLayoutConstraint? = nil

  fileprivate
  var topMarginConstraint: NSLayoutConstraint? = nil

  fileprivate
  var centerXConstraint: NSLayoutConstraint? = nil

  // Content constraints

  fileprivate
  var iconImageViewWidthConstraint: NSLayoutConstraint? = nil

  fileprivate
  var actionButtonMaxWidthConstraint: NSLayoutConstraint? = nil

  fileprivate
  var contentViewLeftConstraint: NSLayoutConstraint? = nil

  fileprivate
  var contentViewRightConstraint: NSLayoutConstraint? = nil

  fileprivate
  var contentViewTopConstraint: NSLayoutConstraint? = nil

  fileprivate
  var contentViewBottomConstraint: NSLayoutConstraint? = nil

  // MARK: - Deinit

  deinit {
    NotificationCenter.default.removeObserver(self)
  }

  // MARK: - Default init

  public
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  public
  override init(frame: CGRect) {

    super.init(frame: AZSnackbar.snackbarDefaultFrame)

    configure()
  }

  public init() {

    super.init(frame: AZSnackbar.snackbarDefaultFrame)

    configure()
  }

  public
  init(message: String,
       duration: AZSnackbarDuration) {

    super.init(frame: AZSnackbar.snackbarDefaultFrame)

    self.duration = duration
    self.message = message
    configure()
  }

  public
  init(message: String,
       duration: AZSnackbarDuration,
       actionText: String,
       actionCompletion: AZSnackbarActionCompletion?) {

    super.init(frame: AZSnackbar.snackbarDefaultFrame)

    self.duration = duration
    self.message = message
    self.actionText = actionText
    self.actionCompletion = actionCompletion
    configure()
  }

  public
  init(message: String,
       duration: AZSnackbarDuration,
       actionText: String,
       messageFont: UIFont,
       actionTextFont: UIFont,
       actionCompletion: AZSnackbarActionCompletion?) {

    super.init(frame: AZSnackbar.snackbarDefaultFrame)

    self.duration = duration
    self.message = message
    self.actionText = actionText
    self.actionCompletion = actionCompletion
    self.messageTextFont = messageFont
    self.actionTextFont = actionTextFont
    configure()
  }

  open
  override func layoutSubviews() {

    super.layoutSubviews()
    if messageLabel.preferredMaxLayoutWidth != messageLabel.frame.size.width {
      messageLabel.preferredMaxLayoutWidth = messageLabel.frame.size.width
      setNeedsLayout()
    }

    super.layoutSubviews()
  }

  private
  func configure() {
    for subView in subviews {
      subView.removeFromSuperview()
    }

    // Notification
    NotificationCenter.default.addObserver(self, selector: #selector(onScreenRotateNotification),
                                           name: UIDevice.orientationDidChangeNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardShow(_:)),
                                           name: UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardHide(_:)),
                                           name: UIResponder.keyboardWillHideNotification, object: nil)

    translatesAutoresizingMaskIntoConstraints = false
    backgroundColor = UIColor.white
    layer.cornerRadius = cornerRadius
    layer.shouldRasterize = true
    layer.rasterizationScale = UIScreen.main.scale

    layer.shadowOpacity = 0.4
    layer.shadowRadius = 2
    layer.shadowColor = UIColor.gray.cgColor
    layer.shadowOffset = CGSize(width: 0, height: 2)

    let contentView = UIView()
    self.contentView = contentView
    contentView.translatesAutoresizingMaskIntoConstraints = false
    contentView.frame = AZSnackbar.snackbarDefaultFrame
    contentView.backgroundColor = UIColor.clear

    let iconImageView = UIImageView()
    self.iconImageView = iconImageView
    iconImageView.translatesAutoresizingMaskIntoConstraints = false
    iconImageView.backgroundColor = UIColor.clear
    iconImageView.contentMode = iconContentMode
    contentView.addSubview(iconImageView)

    let messageLabel = AZSnackbarLabel()
    self.messageLabel = messageLabel
    messageLabel.accessibilityIdentifier = "messageLabel"
    messageLabel.translatesAutoresizingMaskIntoConstraints = false
    messageLabel.textColor = UIColor.black
    messageLabel.font = messageTextFont
    messageLabel.backgroundColor = UIColor.clear
    messageLabel.lineBreakMode = .byTruncatingTail
    messageLabel.numberOfLines = 0;
    messageLabel.textAlignment = .left
    messageLabel.text = message
    contentView.addSubview(messageLabel)

    let actionButton = UIButton()
    self.actionButton = actionButton
    actionButton.accessibilityIdentifier = "actionButton"
    actionButton.translatesAutoresizingMaskIntoConstraints = false
    actionButton.backgroundColor = UIColor.clear
    actionButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 4)
    actionButton.titleLabel?.font = actionTextFont
    actionButton.titleLabel?.adjustsFontSizeToFitWidth = true
    actionButton.titleLabel?.numberOfLines = actionTextNumberOfLines
    actionButton.setTitle(actionText, for: UIControl.State())
    actionButton.setTitleColor(actionTextColor, for: UIControl.State())
    actionButton.addTarget(self, action: #selector(doAction(_:)), for: .touchUpInside)
    contentView.addSubview(actionButton)

    let separateView = UIView()
    self.separateView = separateView
    separateView.translatesAutoresizingMaskIntoConstraints = false
    separateView.backgroundColor = separateViewBackgroundColor
    contentView.addSubview(separateView)

    NSLayoutConstraint.activate([
      iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      iconImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 2),
      iconImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 2),

      messageLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 2),
      messageLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 2),
      messageLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -2),

      separateView.leadingAnchor.constraint(equalTo: messageLabel.trailingAnchor, constant: 4),
      separateView.widthAnchor.constraint(equalToConstant: 0.5),
      separateView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
      separateView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),

      actionButton.leadingAnchor.constraint(equalTo: separateView.trailingAnchor, constant: 4),
      actionButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      actionButton.topAnchor.constraint(equalTo: contentView.topAnchor),
      actionButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
    ])

    iconImageViewWidthConstraint = NSLayoutConstraint.init(
      item: iconImageView, attribute: .width, relatedBy: .equal,
      toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: iconImageViewWidth)

    actionButtonMaxWidthConstraint = NSLayoutConstraint.init(
      item: actionButton, attribute: .width, relatedBy: .lessThanOrEqual,
      toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: actionMaxWidth)

    iconImageView.addConstraint(iconImageViewWidthConstraint!)
    actionButton.addConstraint(actionButtonMaxWidthConstraint!)

    messageLabel.setContentHuggingPriority(.required, for: .vertical)
    messageLabel.setContentCompressionResistancePriority(.required, for: .vertical)

    actionButton.setContentHuggingPriority(UILayoutPriority(998), for: .horizontal)
    actionButton.setContentCompressionResistancePriority(UILayoutPriority(999), for: .horizontal)

    addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.didTapSelf)))
    isUserInteractionEnabled = true

    [UISwipeGestureRecognizer.Direction.up, .down].forEach { (direction) in
      let gesture = UISwipeGestureRecognizer(target: self, action: #selector(self.didSwipeSelf(_:)))
      gesture.direction = direction
      self.addGestureRecognizer(gesture)
    }
  }
}

// MARK: - Show

public
extension AZSnackbar {

  func show() {

    if superview != nil {
      return
    }

    dismissTimer = Timer.init(timeInterval: (TimeInterval)(duration.rawValue),
                              target: self, selector: #selector(dismiss), userInfo: nil, repeats: false)
    RunLoop.main.add(dismissTimer!, forMode: .common)

    iconImageView.isHidden = icon == nil
    actionButton.isHidden = (actionIcon == nil || actionText.isEmpty) == false || actionCompletion == nil
    separateView.isHidden = actionButton.isHidden

    iconImageViewWidthConstraint?.constant = iconImageView.isHidden ? 0 : iconImageViewWidth
    actionButtonMaxWidthConstraint?.constant = actionButton.isHidden ? 0 : actionMaxWidth

    // Content View
    contentView.translatesAutoresizingMaskIntoConstraints = false
    addSubview(contentView)

    contentViewTopConstraint = NSLayoutConstraint.init(
      item: contentView!, attribute: .top, relatedBy: .equal,
      toItem: self, attribute: .top, multiplier: 1, constant: contentInset.top)

    contentViewBottomConstraint = NSLayoutConstraint.init(
      item: contentView!, attribute: .bottom, relatedBy: .equal,
      toItem: self, attribute: .bottom, multiplier: 1, constant: -contentInset.bottom)

    contentViewLeftConstraint = NSLayoutConstraint.init(
      item: contentView!, attribute: .leading, relatedBy: .equal,
      toItem: self, attribute: .leading, multiplier: 1, constant: contentInset.left)

    contentViewRightConstraint = NSLayoutConstraint.init(
      item: contentView!, attribute: .trailing, relatedBy: .equal,
      toItem: self, attribute: .trailing, multiplier: 1, constant: -contentInset.right)

    addConstraints([contentViewTopConstraint!, contentViewBottomConstraint!, contentViewLeftConstraint!, contentViewRightConstraint!])

    var currentWindow: UIWindow? = UIApplication.shared.keyWindow
    currentWindow = currentWindow ?? UIApplication.shared.windows.filter {$0.isKeyWindow}.first
    currentWindow = currentWindow ?? UIApplication.shared.windows.first

    if let superView = containerView ?? currentWindow {
      superView.addSubview(self)

      var relativeToItem:Any = superView as Any;
      if #available(iOS 11.0, *) {
        if shouldHonorSafeAreaLayoutGuides {
          relativeToItem = superView.safeAreaLayoutGuide as Any
        }
      }

      leftMarginConstraint = NSLayoutConstraint.init(
        item: self, attribute: .leading, relatedBy: .equal,
        toItem: relativeToItem, attribute: .leading, multiplier: 1, constant: leftMargin)

      rightMarginConstraint = NSLayoutConstraint.init(
        item: self, attribute: .trailing, relatedBy: .equal,
        toItem: relativeToItem, attribute: .trailing, multiplier: 1, constant: -rightMargin)

      bottomMarginConstraint = NSLayoutConstraint.init(
        item: self, attribute: .bottom, relatedBy: .equal,
        toItem: relativeToItem, attribute: .bottom, multiplier: 1, constant: -bottomMargin)

      topMarginConstraint = NSLayoutConstraint.init(
        item: self, attribute: .top, relatedBy: .equal,
        toItem: relativeToItem, attribute: .top, multiplier: 1, constant: topMargin)

      centerXConstraint = NSLayoutConstraint.init(
        item: self, attribute: .centerX, relatedBy: .equal,
        toItem: superView, attribute: .centerX, multiplier: 1, constant: 0)

      let minHeightConstraint = NSLayoutConstraint.init(
        item: self, attribute: .height, relatedBy: .greaterThanOrEqual,
        toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: AZSnackbar.snackbarMinHeight)

      leftMarginConstraint?.priority = UILayoutPriority(999)
      rightMarginConstraint?.priority = UILayoutPriority(999)
      topMarginConstraint?.priority = UILayoutPriority(999)
      bottomMarginConstraint?.priority = UILayoutPriority(999)
      centerXConstraint?.priority = UILayoutPriority(999)

      centerXConstraint?.isActive = true

      if snackbarMaxWidth > 0 {
        centerXConstraint?.isActive = true

        let maxWidth = (superview?.frame.width ?? 0) - leftMargin - rightMargin
        let snackbarWidth = systemLayoutSizeFitting(.init(width: maxWidth, height: AZSnackbar.snackbarMinHeight)).width
        if snackbarWidth >= maxWidth {
          superView.addConstraint(leftMarginConstraint!)
          superView.addConstraint(rightMarginConstraint!)
        }
      } else {
        superView.addConstraint(leftMarginConstraint!)
        superView.addConstraint(rightMarginConstraint!)
      }

      superView.addConstraint(bottomMarginConstraint!)
      superView.addConstraint(topMarginConstraint!)
      superView.addConstraint(centerXConstraint!)
      superView.addConstraint(minHeightConstraint)

      topMarginConstraint?.isActive = false

      // Show
      showWithAnimation()

      // Accessibility announcement.
      if UIAccessibility.isVoiceOverRunning {
        UIAccessibility.post(notification: .announcement, argument: self.message)
      }
    } else {
      debugPrint("AZSnackbar needs a keyWindows to display.")
    }
  }

  fileprivate
  func showWithAnimation() {

    guard let currentSuperViewWidth = superview?.frame.width else {
      return
    }

    var superViewWidth = snackbarMaxWidth <= 0 ? currentSuperViewWidth : snackbarMaxWidth
    if superViewWidth > currentSuperViewWidth{
      superViewWidth = currentSuperViewWidth
    }

    let snackbarHeight = systemLayoutSizeFitting(.init(width: superViewWidth - leftMargin - rightMargin, height: AZSnackbar.snackbarMinHeight)).height

    switch position {
    case .bottom:
      bottomMarginConstraint?.constant = snackbarHeight
    case .top:
      bottomMarginConstraint?.isActive = false
      topMarginConstraint?.isActive = true
      topMarginConstraint?.constant = -snackbarHeight
    }

    superview?.layoutIfNeeded()

    bottomMarginConstraint?.constant = -bottomMargin
    topMarginConstraint?.constant = topMargin
    leftMarginConstraint?.constant = leftMargin
    rightMarginConstraint?.constant = -rightMargin
    centerXConstraint?.constant = 0

    UIView.animate(withDuration: animationDuration, delay: 0,
                   usingSpringWithDamping: animationSpringWithDamping,
                   initialSpringVelocity: animationInitialSpringVelocity, options: .allowUserInteraction,
                   animations: {
      () -> Void in
      self.superview?.layoutIfNeeded()
    }, completion: nil)
  }
}

// MARK: - Dismiss

public
extension AZSnackbar {

  @objc
  func dismiss() {
    DispatchQueue.main.async { [weak self] in
      self?.dismissAnimated(true)
    }
  }

  fileprivate
  func dismissAnimated(_ animated: Bool) {
    if dismissTimer == nil || superview == nil {
      return
    }

    dismissInvalidatedTimer()

    let snackbarHeight = frame.size.height
    let safeAreaInsets = self.superview?.safeAreaInsets ?? UIEdgeInsets.zero

    if !animated {
      dismissCompletion?(self)
      removeFromSuperview()
      return
    }

    switch position {
    case .bottom:
      bottomMarginConstraint?.constant = snackbarHeight + safeAreaInsets.bottom
    case .top:
      topMarginConstraint?.constant = -snackbarHeight - safeAreaInsets.top
    }

    setNeedsLayout()

    UIView.animate(withDuration: animationDuration, delay: 0,
                   usingSpringWithDamping: animationSpringWithDamping,
                   initialSpringVelocity: animationInitialSpringVelocity, options: .curveEaseIn,
                   animations: { [weak self] in
      self?.superview?.layoutIfNeeded()
    }) { [weak self] (finished) in
      guard let wself = self else { return }
      wself.dismissCompletion?(wself)
      wself.removeFromSuperview()
    }
  }

  fileprivate
  func dismissInvalidatedTimer() {
    dismissTimer?.invalidate()
    dismissTimer = nil
  }
}

// MARK: - Actions

private extension AZSnackbar {

  @objc
  func doAction(_ button: UIButton) {

    actionCompletion?(self)

    if duration == .forever && actionButton.isHidden == false {
      actionButton.isHidden = true
      separateView.isHidden = true
    } else {
      dismissAnimated(true)
    }
  }

  @objc
  func didTapSelf() {
    onTapCompletion?(self)
  }

  @objc
  func didSwipeSelf(_ gesture: UISwipeGestureRecognizer) {
    onSwipeCompletion?(self, gesture.direction)

    if shouldDismissOnSwipe {
      if gesture.direction == .up {
        position = .top
      } else if gesture.direction == .down {
        position = .top
      }
      dismiss()
    }
  }
}

// MARK: - Rotation notification

private
extension AZSnackbar {

  @objc
  func onScreenRotateNotification() {
    messageLabel.preferredMaxLayoutWidth = messageLabel.frame.size.width
    layoutIfNeeded()
  }
}

private extension AZSnackbar {
  @objc
  func onKeyboardShow(_ notification: Notification?) {
    if keyboardIsShown {
      return
    }
    keyboardIsShown = true

    guard let keyboardFrame = notification?.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
      return
    }

    if #available(iOS 11.0, *) {
      keyboardHeight = keyboardFrame.cgRectValue.height - self.safeAreaInsets.bottom
    } else {
      keyboardHeight = keyboardFrame.cgRectValue.height
    }

    keyboardHeight += 8
    bottomMargin += keyboardHeight

    UIView.animate(withDuration: 0.3) {
      self.superview?.layoutIfNeeded()
    }
  }

  @objc
  func onKeyboardHide(_ notification: Notification?) {
    if !keyboardIsShown {
      return
    }
    keyboardIsShown = false

    bottomMargin -= keyboardHeight

    UIView.animate(withDuration: 0.3) {
      self.superview?.layoutIfNeeded()
    }
  }
}

open
class AZSnackbarLabel: UILabel {

  open
  dynamic var contentInset: UIEdgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0) {
    didSet {
      invalidateIntrinsicContentSize()
    }
  }

  open
  override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
    let insetRect = bounds.inset(by: contentInset)
    let textRect = super.textRect(forBounds: insetRect, limitedToNumberOfLines: numberOfLines)
    let invertedInsets = UIEdgeInsets(
      top: -contentInset.top,
      left: -contentInset.left,
      bottom: -contentInset.bottom,
      right: -contentInset.right)
    return textRect.inset(by: invertedInsets)
  }

  override
  open func drawText(in rect: CGRect) {
    super.drawText(in: rect.inset(by: contentInset))
  }

}
