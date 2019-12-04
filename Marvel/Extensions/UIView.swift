//
//  UIView.swift
//  Marvel
//
//  Created by prog_zidane on 12/1/19.
//  Copyright © 2019 prog_zidane. All rights reserved.
//

import Foundation

import UIKit

extension UIView{
    func showLoader(withBackColor : UIColor){
        let loaderView = UIView()
        loaderView.frame = self.frame
        loaderView.backgroundColor = withBackColor
        let activityIndicator = UIActivityIndicatorView(style: .gray)
        activityIndicator.transform = CGAffineTransform(scaleX: 2, y: 2)
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        activityIndicator.startAnimating()
        loaderView.addSubview(activityIndicator)
        activityIndicator.center = loaderView.center
        loaderView.accessibilityIdentifier = "loader"
        self.addSubview(loaderView)
        self.bringSubviewToFront(loaderView)
    }
    func removeLoader(){
        self.subviews.compactMap{
            $0}.forEach{
                if $0.accessibilityIdentifier == "loader"{
                    $0.removeFromSuperview()
                }
        }
    }
    /** Loads instance from nib with the same name. */
    func loadNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nibName = type(of: self).description().components(separatedBy: ".").last!
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as! UIView
    }
    
    @IBInspectable
    /// Should the corner be as circle
    public var circleCorner: Bool {
        get {
            return min(bounds.size.height, bounds.size.width) / 2 == cornerRadius
        }
        set {
            cornerRadius = newValue ? min(bounds.size.height, bounds.size.width) / 2 : cornerRadius
        }
    }
    @IBInspectable var borderWidth: CGFloat {
        set {
            self.layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
    
    
    @IBInspectable var borderColor: UIColor {
        get {
            return self.borderColor
        }
        set {
            self.addBorderColor(color: newValue)
        }
        
    }
    func addBorderColor(color: UIColor )
    {
        // self.layer.masksToBounds = true
        self.layer.borderColor = color.cgColor
        
    }
    
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    //Allow to add shadow of any View from story board attributes
    @IBInspectable var shadow: Bool {
        get {
            return layer.shadowOpacity > 0.0
        }
        set {
            if newValue == true {
                self.addShadow()
            }
        }
    }
    
    /// Quick configuration to give the view shadows.
    public func addShadow(offset: CGSize = .zero, opacity: Float = 0.3, radius: CGFloat = 10, color: UIColor = .black) {
        layer.shadowOffset = offset
        layer.shadowOpacity = opacity
        layer.shadowRadius = radius
        layer.shadowColor = color.cgColor
        layer.masksToBounds = false
    }
    //Allow to change the corner radius of any View from story board attributes
    @IBInspectable var cornerRadius: CGFloat {
        set {
            self.layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }
    @IBInspectable var cornerRadiusByPercentage: CGFloat {
        set {
            
            let radius = (newValue * (UIScreen.main.bounds.height - self.frame.height)) / 2
            
            self.layer.cornerRadius = radius
        }
        get {
            return layer.cornerRadius
        }
    }
//
//    func addShadow(shadowColor: CGColor = UIColor.black.cgColor,
//                   shadowOffset: CGSize = CGSize(width: 1.0, height: 2.0),
//                   shadowOpacity: Float = 0.4,
//                   shadowRadius: CGFloat = 3.0) {
//        layer.masksToBounds = false
//        layer.shadowColor = shadowColor
//        layer.shadowOffset = shadowOffset
//        layer.shadowOpacity = shadowOpacity
//        layer.shadowRadius = shadowRadius
//    }
    
    
    override open func prepareForInterfaceBuilder() {
        
        super.prepareForInterfaceBuilder()
    }
    
}


//new extentions


extension UIView {
    
    func dismissKeyboardOnTouch(){
        isUserInteractionEnabled = true
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(endEditing(_:))))
    }
    
    func addBorder(color:UIColor,borderWidth:CGFloat)
    {
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = borderWidth
    }
    func addCorner(cornerRadius:CGFloat)
    {
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = true
        
    }
    
    func circleView()
    {
        self.layer.cornerRadius = self.frame.size.width / 2
        self.clipsToBounds = true
        
    }
    func circleView(width:CGFloat)
    {
        self.layer.cornerRadius = width / 2
        self.clipsToBounds = true
        
    }
//    func addShadow(shadowRadius:CGFloat)
//    {
//        self.layer.shadowColor = UIColor.black.cgColor
//        self.layer.shadowOpacity = 0.2
//        self.layer.shadowOffset = CGSize.zero
//        self.layer.shadowRadius = shadowRadius
//    }
//    
    @IBInspectable var cornerRadiusV: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    enum LINE_POSITION {
        case LINE_POSITION_TOP
        case LINE_POSITION_BOTTOM
    }
    
    func takeScreenshot() -> UIImage {
        
        // Begin context
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)
        
        // Draw view in that context
        drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        
        // And finally, get image
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        if (image != nil)
        {
            return image!
        }
        return UIImage()
    }
    
    func addLineToView( position : LINE_POSITION, color: UIColor, width: Double) {
        let lineView = UIView()
        lineView.backgroundColor = color
        lineView.translatesAutoresizingMaskIntoConstraints = false // This is important!
        addSubview(lineView)
        
        let metrics = ["width" : NSNumber(value: width)]
        let views = ["lineView" : lineView]
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[lineView]|", options:NSLayoutConstraint.FormatOptions(rawValue: 0), metrics:metrics, views:views))
        
        switch position {
        case .LINE_POSITION_TOP:
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[lineView(width)]", options:NSLayoutConstraint.FormatOptions(rawValue: 0), metrics:metrics, views:views))
            break
        case .LINE_POSITION_BOTTOM:
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[lineView(width)]|", options:NSLayoutConstraint.FormatOptions(rawValue: 0), metrics:metrics, views:views))
            break
        }
    }
    
    func ccFullBoundsConstraints(View : UIView){
        addConstraintWithFormat(format: "H:|[v0]|", Views: View)
        addConstraintWithFormat(format: "V:|[v0]|", Views: View)
    }
    
    func ccFullBoundsConstraints(View : UIView,withWidth : Int){
        addConstraintWithFormat(format: "H:|[v0(\(withWidth))]|", Views: View)
        addConstraintWithFormat(format: "V:|[v0]|", Views: View)
    }
    
    
    func ccFullBoundsConstraints(View : UIView,withHeight : Int){
        addConstraintWithFormat(format: "H:|[v0]|", Views: View)
        addConstraintWithFormat(format: "V:|[v0(\(withHeight))]|", Views: View)
    }
    
    func ccFullBoundsConstraints(View : UIView , withWidth : Int , withHeight : Int){
        addConstraintWithFormat(format: "H:|[v0(\(withWidth))]|", Views: View)
        addConstraintWithFormat(format: "V:|[v0(\(withHeight))]|", Views: View)
    }
    
    func findLabel(withText text: String) -> UILabel? {
        if let label = self as? UILabel, label.text == text {
            return label
        }
        
        for subview in self.subviews {
            if let found = subview.findLabel(withText: text) {
                return found
            }
        }
        
        return nil
    }
    
//    func disableAutoTrans(){
//        disableForSubs(view: self)
//    }
    
//    func disableForSubs(view : UIView){
//        for (_ , view) in view.subviews.enumerated() {
//            if !(view is GMSMapView) && !(view is UISearchBar) {
//                view.translatesAutoresizingMaskIntoConstraints = false
//                self.disableForSubs(view: view)
//            }
//        }
//    }
//
//
//    func disabelCliping(view : UIView){
//        for (_ , view) in view.subviews.enumerated() {
//            if !(view is GMSMapView) && !(view is UISearchBar) {
//                view.clipsToBounds = false
//                self.disableForSubs(view: view)
//            }
//        }
//    }
    
//    func addShadow(cornerRadius: CGFloat = 15,
//                   shadowRadius: CGFloat = 1,
//                   shadowColor: UIColor = UIColor.black,
//                   opacity: Float = 0.4,
//                   offset: CGSize = CGSize(width: 0.0, height: 0.5))
//    {
//        layer.cornerRadius = cornerRadius
//        layer.shadowRadius = shadowRadius
//        layer.shadowColor = shadowColor.cgColor
//        layer.shadowOpacity = opacity
//        layer.shadowOffset = offset
//    }
    
    func addConstraintWithFormat(format :String ,Views :UIView...) {
        var viewsDictionary = [String : UIView]()
        for (index, view) in Views.enumerated() {
            let key  = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDictionary[key] = view
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: viewsDictionary))
    }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    //////COSNTRAINTS
    
    @discardableResult
    func widthEqualTo(constant : CGFloat) ->NSLayoutConstraint{
        let generated = widthAnchor.constraint(equalToConstant: constant)
        generated.isActive = true
        translatesAutoresizingMaskIntoConstraints = false
        return generated
    }
    
    @discardableResult
    func widthEqualTo(view : UIView,percent : CGFloat) ->NSLayoutConstraint{
        let generated = widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: percent)
        generated.isActive = true
        translatesAutoresizingMaskIntoConstraints = false
        return generated
    }
    
    
    @discardableResult
    func widthEqualTo(view : UIView,constant : CGFloat = 0) ->NSLayoutConstraint{
        let generated = widthAnchor.constraint(equalTo: view.widthAnchor,constant: constant)
        generated.isActive = true
        translatesAutoresizingMaskIntoConstraints = false
        return generated
    }
    
    
    @discardableResult
    func widthEqualOrGreaterThan(constant : CGFloat) ->NSLayoutConstraint{
        let generated = widthAnchor.constraint(greaterThanOrEqualToConstant: constant)
        generated.isActive = true
        translatesAutoresizingMaskIntoConstraints = false
        return generated
    }
    
    @discardableResult
    func widthEqualOrLesshan(constant : CGFloat) ->NSLayoutConstraint{
        let generated = widthAnchor.constraint(lessThanOrEqualToConstant: constant)
        generated.isActive = true
        translatesAutoresizingMaskIntoConstraints = false
        return generated
    }
    
    @discardableResult
    func heightEqualTo(constant : CGFloat) ->NSLayoutConstraint{
        let generated = heightAnchor.constraint(equalToConstant: constant)
        generated.isActive = true
        translatesAutoresizingMaskIntoConstraints = false
        return generated
    }
    
    
    @discardableResult
    func heightEqualTo(view : UIView) ->NSLayoutConstraint{
        let generated = heightAnchor.constraint(equalTo: view.widthAnchor,constant : 0)
        generated.isActive = true
        translatesAutoresizingMaskIntoConstraints = false
        return generated
    }
    
    @discardableResult
    func heightEqualOrGreaterThan(constant : CGFloat) ->NSLayoutConstraint{
        let generated = heightAnchor.constraint(greaterThanOrEqualToConstant: constant)
        generated.isActive = true
        translatesAutoresizingMaskIntoConstraints = false
        return generated
    }
    
    
    @discardableResult
    func sizeEqualTo(size : CGSize) -> [NSLayoutConstraint] {
        var array = [NSLayoutConstraint]()
        let widthConstraint = widthAnchor.constraint(equalToConstant: size.width)
        widthConstraint.isActive = true
        let heightConstraint = heightAnchor.constraint(equalToConstant: size.height)
        heightConstraint.isActive = true
        array.append(widthConstraint)
        array.append(heightConstraint)
        translatesAutoresizingMaskIntoConstraints = false
        return array
    }
    
    @discardableResult
    func topEqualTo(constraint : NSLayoutAnchor<NSLayoutYAxisAnchor>,constant : CGFloat = 0) -> NSLayoutConstraint {
        let generated = topAnchor.constraint(equalTo: constraint,constant : constant)
        generated.isActive = true
        translatesAutoresizingMaskIntoConstraints = false
        return generated
    }
    
    
    @discardableResult
    func bottomEqualTo(constraint : NSLayoutAnchor<NSLayoutYAxisAnchor>,constant : CGFloat = 0) -> NSLayoutConstraint {
        let generated = bottomAnchor.constraint(equalTo: constraint,constant : constant)
        generated.isActive = true
        translatesAutoresizingMaskIntoConstraints = false
        return generated
    }
    
    @discardableResult
    func leadingEqualTo(constraint : NSLayoutAnchor<NSLayoutXAxisAnchor>,constant : CGFloat = 0) -> NSLayoutConstraint {
        let generated = leadingAnchor.constraint(equalTo: constraint,constant : constant)
        generated.isActive = true
        translatesAutoresizingMaskIntoConstraints = false
        return generated
    }
    
    
    
    @discardableResult
    func trailingEqualTo(constraint : NSLayoutAnchor<NSLayoutXAxisAnchor>,constant : CGFloat = 0) -> NSLayoutConstraint {
        let generated = trailingAnchor.constraint(equalTo: constraint,constant : constant)
        generated.isActive = true
        translatesAutoresizingMaskIntoConstraints = false
        return generated
    }
    
    @discardableResult
    func centerXequalTo(constraint : NSLayoutAnchor<NSLayoutXAxisAnchor>) -> NSLayoutConstraint {
        let generated = centerXAnchor.constraint(equalTo: constraint)
        generated.isActive = true
        translatesAutoresizingMaskIntoConstraints = false
        return generated
    }
    
    @discardableResult
    func centerYequalTo(constraint : NSLayoutAnchor<NSLayoutYAxisAnchor>) -> NSLayoutConstraint {
        let generated = centerYAnchor.constraint(equalTo: constraint)
        generated.isActive = true
        translatesAutoresizingMaskIntoConstraints = false
        return generated
    }
    
    func centerEqualTo(view : UIView)  {
        centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    
    func fullSizeEqualTo(view : UIView){
        trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    
    func fullSizeEqualTo(view : UIView,constant : CGFloat){
        trailingAnchor.constraint(equalTo: view.trailingAnchor,constant : -constant).isActive = true
        leadingAnchor.constraint(equalTo: view.leadingAnchor,constant : constant).isActive = true
        topAnchor.constraint(equalTo: view.topAnchor,constant : constant).isActive = true
        bottomAnchor.constraint(equalTo: view.bottomAnchor,constant : -constant).isActive = true
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    
    func fullSizeEqualTo(view : UIView,horizontalMa : CGFloat,verticalMa: CGFloat){
        trailingAnchor.constraint(equalTo: view.trailingAnchor,constant : -horizontalMa).isActive = true
        leadingAnchor.constraint(equalTo: view.leadingAnchor,constant : horizontalMa).isActive = true
        topAnchor.constraint(equalTo: view.topAnchor,constant : verticalMa).isActive = true
        bottomAnchor.constraint(equalTo: view.bottomAnchor,constant : -verticalMa).isActive = true
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    @discardableResult
    func horizontalEqualTo(view : UIView,constant : CGFloat = 0)  -> (NSLayoutConstraint , NSLayoutConstraint){
        let trail = trailingAnchor.constraint(equalTo: view.trailingAnchor,constant : -constant)
        let lead = leadingAnchor.constraint(equalTo: view.leadingAnchor,constant : constant)
        trail.isActive = true
        lead.isActive = true
        translatesAutoresizingMaskIntoConstraints = false
        return (lead , trail)
    }
    
    func verticalEqualTo(view : UIView,constant : CGFloat = 0){
        topAnchor.constraint(equalTo: view.topAnchor,constant : constant).isActive = true
        bottomAnchor.constraint(equalTo: view.bottomAnchor,constant : -constant).isActive = true
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    
    public func fillSuperview(constant : CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        if let superview = superview {
            leftAnchor.constraint(equalTo: superview.leftAnchor,constant : constant).isActive = true
            rightAnchor.constraint(equalTo: superview.rightAnchor,constant : -constant).isActive = true
            topAnchor.constraint(equalTo: superview.topAnchor,constant : constant).isActive = true
            bottomAnchor.constraint(equalTo: superview.bottomAnchor,constant : -constant).isActive = true
        }
    }
    
    public func anchorCenterXToSuperview(constant: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        if let anchor = superview?.centerXAnchor {
            centerXAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
        }
    }
    
    public func anchorCenterYToSuperview(constant: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        if let anchor = superview?.centerYAnchor {
            centerYAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
        }
    }
    
    public func anchorCenterSuperview() {
        anchorCenterXToSuperview()
        anchorCenterYToSuperview()
    }
    
    @discardableResult
    func heightEqualToPercentTo(view : UIView,percent : CGFloat) ->NSLayoutConstraint{
        let generated = heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: percent)
        generated.isActive = true
        translatesAutoresizingMaskIntoConstraints = false
        return generated
    }
    
    @discardableResult
    func widthEqualToPercentTo(view : UIView,percent : CGFloat) ->NSLayoutConstraint{
        let generated = widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: percent)
        generated.isActive = true
        translatesAutoresizingMaskIntoConstraints = false
        return generated
    }
    
    func setCornerToHalf(){
        layer.cornerRadius = frame.height / 2
        clipsToBounds = true
    }
    
    func setGradeint(gradientColors :[CGColor] ,angle : Float,corner : CGFloat){
        
        let  gradient = CAGradientLayer()
        
        
        let alpha: Float = angle / 360
        let startPointX = powf(
            sinf(2 * Float.pi * ((alpha + 0.75) / 2)),
            2
        )
        
        let startPointY = powf(
            sinf(2 * Float.pi * ((alpha + 0) / 2)),
            2
        )
        let endPointX = powf(
            sinf(2 * Float.pi * ((alpha + 0.25) / 2)),
            2
        )
        let endPointY = powf(
            sinf(2 * Float.pi * ((alpha + 0.5) / 2)),
            2
        )
        
        gradient.endPoint = CGPoint(x: CGFloat(endPointX),y: CGFloat(endPointY))
        gradient.startPoint = CGPoint(x: CGFloat(startPointX), y: CGFloat(startPointY))
        
        
        gradient.colors = gradientColors
        gradient.cornerRadius = corner
        gradient.frame = bounds
        layer.addSublayer(gradient)
        
        
        
    }
    
    func enableMovment(){
        let pan = UIPanGestureRecognizer(target: self, action: #selector(self.pan(sender:)))
        addGestureRecognizer(pan)
    }
    
    
    @objc func pan(sender: UIPanGestureRecognizer) {
        if sender.state == .changed {
            
            
            let translation = sender.translation(in: self)
            
            center = CGPoint(x:  center.x + (translation.x),
                             y:  center.y + (translation.y ) )
            
            
            
            sender.setTranslation(CGPoint.zero, in:  superview)
        }else if sender.state == .ended {
            
            
            
            
            UIView.animate(withDuration: 0.30) {
                
                var xPoint : CGFloat = 0
                
                if self.center.x < UIScreen.main.bounds.width / 2{
                    xPoint = ((sender.view?.frame.width)! / 2)
                }else {
                    xPoint =   UIScreen.main.bounds.size.width - ((sender.view?.frame.width)! / 2)
                }
                
                self.center = CGPoint(x: xPoint,
                                      y:  self.center.y )
                self.superview?.layoutIfNeeded()
            }
        }
        
    }
    
    
}


extension UIView {
  
    func findConstraint(layoutAttribute: NSLayoutConstraint.Attribute) -> NSLayoutConstraint? {
        if let constraints = superview?.constraints {
            for constraint in constraints where itemMatch(constraint: constraint, layoutAttribute: layoutAttribute) {
                return constraint
            }
        }
        return nil
    }
    
    func itemMatch(constraint: NSLayoutConstraint, layoutAttribute: NSLayoutConstraint.Attribute) -> Bool {
        if let firstItem = constraint.firstItem as? UIView, let secondItem = constraint.secondItem as? UIView {
            let firstItemMatch = firstItem == self && constraint.firstAttribute == layoutAttribute
            let secondItemMatch = secondItem == self && constraint.secondAttribute == layoutAttribute
            return firstItemMatch || secondItemMatch
        }
        return false
    }
}


extension UIView {
    
    // In order to create computed properties for extensions, we need a key to
    // store and access the stored property
    fileprivate struct AssociatedObjectKeys {
        static var gestureRecognizer = "MediaViewerAssociatedObjectKey_mediaViewer"
    }
    fileprivate typealias Action = (() -> Void)?
    // Set our computed property type to a closure
    fileprivate var gestureRecognizerAction: Action? {
        set{
             if let newValue = newValue {
                // Computed properties get stored as associated objects
                objc_setAssociatedObject(self, &AssociatedObjectKeys.gestureRecognizer, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
             }
        }
        get {
            let gestureRecognizerActionInstance = objc_getAssociatedObject(self, &AssociatedObjectKeys.gestureRecognizer) as? Action
            return gestureRecognizerActionInstance
        }
    }
    
    // This is the meat of the sauce, here we create the tap gesture recognizer and
    // store the closure the user passed to us in the associated object we declared above
    public func addTapGestureRecognizer(action: (() -> Void)?) {
        self.isUserInteractionEnabled = true
        self.gestureRecognizerAction = action
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        self.addGestureRecognizer(tapGestureRecognizer)
    }
    // Every time the user taps on the UIImageView, this function gets called,
    // which triggers the closure we stored
    @objc fileprivate func handleTapGesture(sender: UITapGestureRecognizer) {
        if let action = self.gestureRecognizerAction {
            action?()
        } else {
            print("no action")
        }
    }
    
    public func addSwipGestureRecognizer(direction:UISwipeGestureRecognizer.Direction,action: (() -> Void)?) {
        self.isUserInteractionEnabled = true
        self.gestureRecognizerAction = action
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleTapGesture))
        swipeGesture.direction = direction
        self.addGestureRecognizer(swipeGesture)
    }
}


protocol Blurable {
    func addBlur(_ alpha: CGFloat)
}

extension Blurable where Self: UIView {
    func addBlur(_ alpha: CGFloat = 0.5) {
        // create effect
        let effect = UIBlurEffect(style: .dark)
        let effectView = UIVisualEffectView(effect: effect)
        
        // set boundry and alpha
        effectView.frame = self.bounds
        effectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        effectView.alpha = alpha
        
        self.addSubview(effectView)
    }
}

// Conformance
extension UIView: Blurable {}
