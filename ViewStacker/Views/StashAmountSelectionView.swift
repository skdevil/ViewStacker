//
//  FirstView.swift
//  ViewStacker
//
//  Created by Next on 31/07/20.
//  Copyright © 2020 Next. All rights reserved.
//

import UIKit
import StacksManager


class StashAmountSelectionView: BaseView{
    
    weak var navigationDelegate: StackNavigationProtocol?
    public var currentState: ViewState!{
        didSet{
            self.headingLabel.alpha = 0
            self.instructionLabel.alpha = 0
            creditAmountLabel.alpha = 0
            creditValueLabel.alpha = 0
            switch currentState {
            case .Dismissed:
                break
            case .Visible:
                self.headingLabel.alpha = 1
                self.instructionLabel.alpha = 1
                break
            case .FullScreen:
                break
            case .Background:
                creditAmountLabel.alpha = 1
                creditValueLabel.alpha = 1
                break
            default:
                break
            }
        }
    }
    
    
    
    
    //App related properties
    var dialContainerView: BaseView!
    var progressDialView: CircularProgressView!
    let progressTrackColor = UIColor(red: 1.00, green: 0.92, blue: 0.88, alpha: 1.00)
    let progressFillColor = UIColor(red: 0.88, green: 0.58, blue: 0.45, alpha: 1.00)
    var panGesture: UIPanGestureRecognizer!
    var panActive = false
    var startingAngle: CGFloat = 0.0
    let headingLabel = UILabel()
    let instructionLabel = UILabel()
    let creditAmountLabel = UILabel()
    let creditValueLabel = UILabel()
    var closeButton: UIButton!
    
    
    
    @objc func panDetected(sender: UIPanGestureRecognizer){
        
        if sender.state == .began{
            if abs(distanceBetweenPoints(from: sender.location(in: self), to: dialContainerView.center) - progressDialView.bounds.width) < 20{
                panActive = true
            }
        }
        
        if panActive{
            let referencePoint = CGPoint.init(x: self.frame.width / 2, y: self.frame.height / 2)
            let angleValue = angle(between: referencePoint, ending: sender.location(in: self))
            startingAngle = angleValue
            
            if angleValue > 350.0{
                sender.state = .ended
            }
            progressDialView.progressValue = Float((angleValue / 350.0))
        }
        if sender.state == .ended{
            panActive = false
        }
    }
    /* Target for dismissing the all stacks at a time.  Commented because I didn't find it to be a good UX.
     
    @objc func closeViewStack(sender: UIButton){
        self.navigationDelegate?.dismissStackManager()
    }
    */
    
    func angle(between starting: CGPoint, ending: CGPoint) -> CGFloat {
        let center = CGPoint(x: ending.x - starting.x, y: ending.y - starting.y)
        let radians = atan2(center.y, center.x)
        let degrees = radians * 180 / .pi
        let adjustedDegrees = degrees + 90
        return adjustedDegrees > 0 ? adjustedDegrees : 360 + degrees + 90
    }
    
   
    
    
    func distanceSquared(from: CGPoint, to: CGPoint) -> CGFloat {
        return (from.x - to.x) * (from.x - to.x) + (from.y - to.y) * (from.y - to.y)
    }

    func distanceBetweenPoints(from: CGPoint, to: CGPoint) -> CGFloat {
        return sqrt(distanceSquared(from: from, to: to))
    }
    
    private func degreesToRadians(_ deg: CGFloat) -> CGFloat {
        return deg * CGFloat.pi / 180
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
    }
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if self.subviews.contains(headingLabel) { return }
        initViews()
    }
}

extension StashAmountSelectionView: StackViewDataSource{
    func recieveIncomingData(value: Any?) {
        
    }
    
    func sendDataToNextView() -> Any? {
        
        return [EMIModel.init(amountToBePaid: 8000, duration: 14, selected: true),EMIModel.init(amountToBePaid: 7000, duration: 18, selected: false),EMIModel.init(amountToBePaid: 5000, duration: 28, selected: false)]
    }
    
    
    var state: ViewState {
        get {
            return currentState
        }
        set {
            self.currentState = newValue
        }
    }
    
    
    
    func heightOfHeaderView() -> CGFloat {
        return 100
    }
}



extension StashAmountSelectionView{
    
    
    func initViews(){
        /* You may add buttons to dismiss the entire stacks.
         
         
        closeButton = UIButton.init()
        self.addSubview(closeButton)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        [closeButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20),
         closeButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
         closeButton.widthAnchor.constraint(equalToConstant: 20),
         closeButton.heightAnchor.constraint(equalToConstant: 20)].forEach({$0.isActive = true})
        closeButton.setImage(UIImage.init(named: "closeButtonImage"), for: .normal)
        closeButton.addTarget(self, action: #selector(closeViewStack(sender:)), for: .touchUpInside)
        
         
         */
        
        self.addSubview(creditAmountLabel)
        creditAmountLabel.translatesAutoresizingMaskIntoConstraints = false
        [creditAmountLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20),
         creditAmountLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 30)].forEach({$0.isActive = true})
        creditAmountLabel.text = "credit amount"
        creditAmountLabel.textColor = AppTheme.cardsControllertextColor
        creditAmountLabel.alpha = 0
        
        self.addSubview(creditValueLabel)
        creditValueLabel.translatesAutoresizingMaskIntoConstraints = false
        [creditValueLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20),
         creditValueLabel.topAnchor.constraint(equalTo: creditAmountLabel.bottomAnchor, constant: 16)].forEach({$0.isActive = true})
        creditValueLabel.textColor = AppTheme.cardsControllertextColor
        creditValueLabel.alpha = 0
        creditValueLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        
        self.addSubview(headingLabel)
        headingLabel.text = "Hello SWAT, how much do you need?"
        headingLabel.textColor = AppTheme.cardsControllertextColor
        headingLabel.numberOfLines = 0
        headingLabel.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        headingLabel.translatesAutoresizingMaskIntoConstraints = false
        [headingLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20),
         headingLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 30),
         headingLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20)].forEach({$0.isActive = true})
        
        
        self.addSubview(instructionLabel)
        instructionLabel.text = "move the dial and set the amount to any amount you need upto ₹7,00,000.00"
        instructionLabel.textColor = AppTheme.textColor
        instructionLabel.font = UIFont.systemFont(ofSize: 13, weight: .light)
        instructionLabel.numberOfLines = 0
        instructionLabel.translatesAutoresizingMaskIntoConstraints = false
        [instructionLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20),
         instructionLabel.topAnchor.constraint(equalTo: headingLabel.bottomAnchor, constant: 8),
         instructionLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20)].forEach({$0.isActive = true})
        
        dialContainerView = BaseView.init(with: .white, circular: false, shadow: false, borderColor: nil, borderThickness: nil)
        self.addSubview(dialContainerView)
        dialContainerView.translatesAutoresizingMaskIntoConstraints = false
        [dialContainerView.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0),
         dialContainerView.topAnchor.constraint(equalTo: instructionLabel.bottomAnchor, constant: 60),
         dialContainerView.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -60),
         dialContainerView.heightAnchor.constraint(equalTo: dialContainerView.widthAnchor, constant: 0)].forEach({$0.isActive = true})
        
        progressDialView = CircularProgressView.init(progress: 0.2, trackColor: progressTrackColor, progressColor: progressFillColor)
        dialContainerView.addSubview(progressDialView)
        progressDialView.translatesAutoresizingMaskIntoConstraints = false
        [progressDialView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.25),
         progressDialView.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.25),
         progressDialView.centerYAnchor.constraint(equalTo: dialContainerView.centerYAnchor, constant: 0),
         progressDialView.centerXAnchor.constraint(equalTo: dialContainerView.centerXAnchor, constant: 0)].forEach({$0.isActive = true})
        progressDialView.delegate = self
        
        panGesture = UIPanGestureRecognizer.init(target: self, action: #selector(panDetected(sender:)))
        dialContainerView.addGestureRecognizer(panGesture)
        
        let bottomDescriptionLabel = UILabel()
        dialContainerView.addSubview(bottomDescriptionLabel)
        bottomDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        [bottomDescriptionLabel.leftAnchor.constraint(equalTo: dialContainerView.leftAnchor, constant: 20),
         bottomDescriptionLabel.rightAnchor.constraint(equalTo: dialContainerView.rightAnchor, constant: -20),
         bottomDescriptionLabel.bottomAnchor.constraint(equalTo: dialContainerView.bottomAnchor, constant: -20)].forEach({$0.isActive = true})
        bottomDescriptionLabel.numberOfLines = 3
        bottomDescriptionLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        bottomDescriptionLabel.textColor = AppTheme.cardsControllertextColor
        bottomDescriptionLabel.textAlignment = .center
        bottomDescriptionLabel.text = "stash is instant. money will be credited within seconds"
    }
}



extension StashAmountSelectionView: CircularProgressValueProtocol{
    func currentValueOfCircularProgressView(value: String) {
        creditValueLabel.text = value
    }
    
    
}
