//
//  PickerField.swift
//  mtpPickerField
//
//  Created by Mostafa Taghipour on 12/12/17.
//  Copyright © 2017 RainyDay. All rights reserved.
//

import UIKit


public protocol PickerFieldDelegate:class{
    func pickerField(didOKClick pickerField:PickerField)
    func pickerField(didCancelClick pickerField:PickerField)
    func pickerField(didShowPicker pickerField:PickerField)
    func pickerField(didHidePicker pickerField:PickerField)
    func pickerField(didTap pickerField:PickerField)
}

public extension PickerFieldDelegate{
    func pickerField(didOKClick pickerField:PickerField){}
    func pickerField(didCancelClick pickerField:PickerField){}
    func pickerField(didShowPicker pickerField:PickerField){}
    func pickerField(didHidePicker pickerField:PickerField){}
    func pickerField(didTap pickerField:PickerField){}
}

public enum PickerFieldType {
    case none
    case pickerView
    case datePicker
    case tableView
    case collectionView
}
public class PickerField: UITextField ,UITextFieldDelegate{
    
    
    private(set) public var pickerView:UIPickerView?
    private(set) public var datePicker:UIDatePicker?
    private(set) public var tableView:UITableView?
    private(set) public var collectionView:UICollectionView?
    private(set) public var containerView:UIView?
    private(set) public var contentView:UIView?
    private(set) public var okButton:UIButton?
    private(set)  public var cancelButton:UIButton?
    private(set)  public var isShown=false
    private(set)  public var titleLabel:UILabel?{
        didSet{
            guard let label = titleLabel else{
                return
            }
            
            label.addObserver(self, forKeyPath: "text", options: [.new], context: nil)
        }
    }
    public lazy var rightImageView : UIImageView = { [unowned self]  in
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 35, height: 30))
        
        let imageView = UIImageView(frame: CGRect(x: 5, y: 2.5, width: 25, height: 25))
        view.addSubview(imageView)
        self.rightView=view
        
        imageView.addObserver(self, forKeyPath: "image", options: [.new], context: nil)
        return imageView
        
        }()
    
    
    public  weak var pickerFieldDelegate:PickerFieldDelegate?
    public var type:PickerFieldType = .none{
        didSet{
            
            if alreadySet {
                return
            }
            if type != .none{
                alreadySet=true
            }
            
            switch type {
            case .pickerView:
                setupPickerView()
                break
            case .datePicker:
                setupDatePicker()
                break
            case .tableView:
                setupTableView()
                break
            case .collectionView:
                setupCollectionView()
                break
            default:
                break
            }
        }
    }
    public var height:CGFloat=250{
        didSet{
            heightConstraint?.constant=height
        }
    }
    public var hideButtons:Bool=false{
        didSet{
            bottomSectionHeightConstraint?.constant = hideButtons ? 0 : DEFAULT_BOTTOM_SECTION_HEIGHT
            seperatorHeightConstraint?.constant = hideButtons ? 0 : 1
        }
    }
    public var cancelWhenTouchUpOutside:Bool=false{
        didSet{
            
        }
    }
    
    private let DEFAULT_BOTTOM_SECTION_HEIGHT:CGFloat=50
    private let DEFAULT_TITLE_LABLE_HEIGHT:CGFloat=20
    private var alreadySet=false
    private var alert:UIAlertController?
    private weak var viewController:UIViewController?
    private var heightConstraint:NSLayoutConstraint?
    private var titleHeightConstraint:NSLayoutConstraint?
    private var titleTopConstraint:NSLayoutConstraint?
    private var bottomSectionHeightConstraint:NSLayoutConstraint?
    private var seperatorHeightConstraint:NSLayoutConstraint?
    
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit(){
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTap)))
        self.delegate=self
        setupView()
    }
    
    
    private func setupView(){
        
        //alertview
        guard alert == nil else{
            return
        }
        
        
        alert = UIAlertController(title: nil, message: "", preferredStyle: UIAlertControllerStyle.actionSheet)
        alert?.isModalInPopover = true
        
        
        heightConstraint = NSLayoutConstraint(item: alert!.view, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: self.height)
        
        alert?.view.addConstraint(heightConstraint!)
        
        
        
        //containerView
        containerView=UIView()
        alert?.view.addSubview(containerView!)
        addConstraint(containerView!, toView: alert!.view, top: 0, leading: 0, bottom: 0, trailing: 0)
        guard let containerView = containerView else{
            return
        }
        
        
        //titleLabel
        titleLabel = UILabel()
        containerView.addSubview(titleLabel!)
        addConstraint(titleLabel!, toView: containerView, top: nil, leading: nil, bottom: nil, trailing: nil)
        titleLabel?.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive=true
        titleTopConstraint = titleLabel?.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 0)
        titleTopConstraint?.isActive=true
        titleHeightConstraint = titleLabel?.heightAnchor.constraint(equalToConstant: 0)
        titleHeightConstraint?.isActive=true
        titleLabel?.font=UIFont.systemFont(ofSize: 13)
        titleLabel?.textColor = .lightGray
        
        
        //buttons
        let bottomView=UIView()
        containerView.addSubview(bottomView)
        bottomView.clipsToBounds=true
        addConstraint(bottomView, toView: containerView, top: nil, leading: 0, bottom: 0, trailing: 0)
        bottomSectionHeightConstraint = bottomView.heightAnchor.constraint(equalToConstant: DEFAULT_BOTTOM_SECTION_HEIGHT)
        bottomSectionHeightConstraint?.isActive=true
        okButton=UIButton(type: .system)
        bottomView.addSubview(okButton!)
        okButton?.addTarget(self, action: #selector(didOKTap), for: .touchUpInside)
        okButton?.setTitle("OK", for: .normal)
        addConstraint(okButton!, toView: bottomView, top: 0, leading: 0, bottom: 0, trailing: nil)
        okButton?.widthAnchor.constraint(equalTo: bottomView.widthAnchor, multiplier: 0.5).isActive=true
        cancelButton=UIButton(type: .system)
        bottomView.addSubview(cancelButton!)
        cancelButton?.addTarget(self, action: #selector(didCancelTap), for: .touchUpInside)
        cancelButton?.setTitle("Cancel", for: .normal)
        addConstraint(cancelButton!, toView: bottomView, top: 0, leading: nil, bottom: 0, trailing: 0)
        cancelButton?.widthAnchor.constraint(equalTo: bottomView.widthAnchor, multiplier: 0.5).isActive=true
        
        
        //seperator
        let seperater=UIView()
        containerView.addSubview(seperater)
        addConstraint(seperater, toView: containerView, top: nil, leading: 0, bottom: nil, trailing: 0)
        seperater.bottomAnchor.constraint(equalTo: bottomView.topAnchor).isActive=true
        seperatorHeightConstraint = seperater.heightAnchor.constraint(equalToConstant: 1)
        seperatorHeightConstraint?.isActive=true
        seperater.backgroundColor = UIColor.groupTableViewBackground
        
        
        //contentView
        contentView=UIView()
        containerView.addSubview(contentView!)
        addConstraint(contentView!, toView: containerView, top: nil, leading: 8, bottom: nil, trailing: -8)
        contentView?.bottomAnchor.constraint(equalTo: seperater.topAnchor,constant: -8).isActive=true
        contentView?.topAnchor.constraint(equalTo: titleLabel!.bottomAnchor,constant: 8).isActive=true
        
        
        
    }
    
    
    private func setupPickerView(){
        guard pickerView==nil else{
            return
        }
        
        pickerView=UIPickerView()
        contentView?.addSubview(pickerView!)
        addConstraint(pickerView!, toView: contentView!, top: 0, leading: 0, bottom: 0, trailing: 0)
    }
    
    private func setupDatePicker(){
        guard datePicker==nil else{
            return
        }
        
        datePicker=UIDatePicker()
        contentView?.addSubview(datePicker!)
        addConstraint(datePicker!, toView: contentView!, top: 0, leading: 0, bottom: 0, trailing: 0)
    }
    
    private func setupTableView(){
        guard tableView==nil else{
            return
        }
        
        tableView=UITableView()
        tableView?.backgroundColor = .clear
        contentView?.addSubview(tableView!)
        addConstraint(tableView!, toView: contentView!, top: 0, leading: 0, bottom: 0, trailing: 0)
    }
    
    private func setupCollectionView(){
        guard collectionView==nil else{
            return
        }
        
        collectionView=UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        collectionView?.backgroundColor = .clear
        contentView?.addSubview(collectionView!)
        addConstraint(collectionView!, toView: contentView!, top: 0, leading: 0, bottom: 0, trailing: 0)
    }
    
    @objc fileprivate func didTap(){
        self.pickerFieldDelegate?.pickerField(didTap: self)
        
        if type != .none{
            show()
        }
    }
    
    @objc fileprivate func didOKTap(){
        dismiss()
        self.pickerFieldDelegate?.pickerField(didOKClick: self)
    }
    @objc fileprivate func didCancelTap(){
        dismiss()
        self.pickerFieldDelegate?.pickerField(didCancelClick: self)
    }
    
    private func getViewController() -> UIViewController? {
        
        if let vc = self.viewController {
            return vc
        }
        
        var responder: UIResponder? = self
        while !(responder is UIViewController) {
            responder = responder?.next
            if nil == responder {
                break
            }
        }
        
        self.viewController=(responder as? UIViewController)
        return self.viewController
    }
    
    private func addConstraint(_ view:UIView,toView:UIView,top:CGFloat?,leading:CGFloat?,bottom:CGFloat?,trailing:CGFloat?){
        view.translatesAutoresizingMaskIntoConstraints=false
        if let top=top{
            view.topAnchor.constraint(equalTo: toView.topAnchor, constant: top).isActive=true
        }
        if let leading=leading{
            view.leadingAnchor.constraint(equalTo: toView.leadingAnchor, constant: leading).isActive=true
        }
        if let trailing=trailing{
            view.trailingAnchor.constraint(equalTo: toView.trailingAnchor, constant: trailing).isActive=true
        }
        if let bottom=bottom{
            view.bottomAnchor.constraint(equalTo: toView.bottomAnchor, constant: bottom).isActive=true
        }
    }
    
    
    
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        didTap()
        return false
    }
    
    override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "text" {
            
            if let newVal=change?[.newKey] as? String,!newVal.isEmpty{
                self.titleHeightConstraint?.constant=DEFAULT_TITLE_LABLE_HEIGHT
                self.titleTopConstraint?.constant=8
            }
            else{
                self.titleHeightConstraint?.constant=0
                self.titleTopConstraint?.constant=0
            }
        }
        else if keyPath == "image" {
            
            if let _=change?[.newKey] as? UIImage{
                rightViewMode = .always
            }
            else{
                rightViewMode = .never
            }
        }
    }
    
    deinit {
        titleLabel?.removeObserver(self, forKeyPath: "text")
        rightImageView.removeObserver(self, forKeyPath: "image")
    }
    
    //MARK:- public methods
    public func show(){
        guard let alert=self.alert, !isShown else{
            return
        }
        
        isShown=true
        
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = self
            popoverController.sourceRect = self.bounds
        }
        
        getViewController()?.present(alert, animated: true, completion: { [weak self] in
            
            guard let unSelf = self  , unSelf.cancelWhenTouchUpOutside else {
                return
            }
            
            unSelf.pickerFieldDelegate?.pickerField(didShowPicker: unSelf)
            
            if let ousideView=unSelf.alert!.view.superview?.subviews.first {
                ousideView.isUserInteractionEnabled = true
                ousideView.addGestureRecognizer( UITapGestureRecognizer(target: unSelf, action: #selector(unSelf.dismiss)))
            }
            
        })
    }
    
    @objc public func dismiss(){
        guard let alert=self.alert, isShown else{
            return
        }
        
        isShown=false
        
        alert.dismiss(animated: true) { [weak self] in
            guard let unSelf = self  else{
                return
            }
            unSelf.pickerFieldDelegate?.pickerField(didHidePicker: unSelf)
        }
    }
}
