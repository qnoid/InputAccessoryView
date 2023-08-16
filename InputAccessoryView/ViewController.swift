//
//  ViewController.swift
//  InputAccessoryView
//
//  Created by Markos Zoulias Charatzas on 16/08/2023.
//

import UIKit

protocol TooltipTouchRecognizer: AnyObject {
    func didTouchUpInside(_ tooltip: Tooltip)
}


class Tooltip: UIView {

    weak var touchRecognizer: TooltipTouchRecognizer?

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        super.hitTest(point, with: event)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.backgroundColor = .white
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.backgroundColor = .green
        
        if let point = touches.first?.location(in: self), self.point(inside: point, with: event) {
            self.touchRecognizer?.didTouchUpInside(self)
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.backgroundColor = .green
    }
}

class InputAccessoryView: UIView {

    lazy var _tooltip: Tooltip = {
        let tooltip = Tooltip(frame: .init(x: 0, y: 0, width: 200, height: 100))
        tooltip.isUserInteractionEnabled = true
        tooltip.backgroundColor = .green
        
        return tooltip
    }()
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let _point = self.convert(point, to: _tooltip)
        
        if self._tooltip.bounds.contains(_point) {
            return true
        }
        
        return super.point(inside: point, with: event)
    }
    

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        
        let _point = self._tooltip.convert(point, from: self)
        
        if self._tooltip.bounds.contains(_point) {
            return self._tooltip.hitTest(_point, with: event)
        }
        
        return super.hitTest(point, with: event)
    }
}

class ViewController: UIViewController, UITextViewDelegate {

    override var canBecomeFirstResponder: Bool {
        true
    }
    
    lazy var _textView: UITextView = {
        let textView = UITextView(frame: .init(x: 0, y: 0, width: 0, height: 50))
        textView.autocorrectionType = .no
        textView.autocapitalizationType = .none
        textView.spellCheckingType = .no
        
        textView.backgroundColor = .blue
        textView.textColor = .white
        textView.delegate = self
        
        return textView
    }()
    
    lazy var _inputAccessoryView: UIView = {
        let inputAccessoryView = InputAccessoryView()
        inputAccessoryView.translatesAutoresizingMaskIntoConstraints = false
        inputAccessoryView.autoresizingMask = [.flexibleWidth, .flexibleLeftMargin, .flexibleRightMargin]
        inputAccessoryView.frame.size.height = 200
        inputAccessoryView.backgroundColor = .red
        //tooltip
        inputAccessoryView.isUserInteractionEnabled = true

        //textview
        _textView.translatesAutoresizingMaskIntoConstraints = false
        inputAccessoryView.addSubview(_textView)
        
        _textView.heightAnchor.constraint(equalToConstant: _textView.frame.height).isActive = true
        _textView.centerXAnchor.constraint(equalTo: inputAccessoryView.centerXAnchor).isActive = true
        _textView.bottomAnchor.constraint(equalTo: inputAccessoryView.bottomAnchor).isActive = true
        _textView.leadingAnchor.constraint(equalTo: inputAccessoryView.leadingAnchor, constant: 10).isActive = true
        //_textView.trailingAnchor.constraint(equalTo: inputAccessoryView.trailingAnchor, constant: -10).isActive = true
        inputAccessoryView.trailingAnchor.constraint(equalTo: _textView.trailingAnchor, constant: 10).isActive = true

        //tooltip
        let _tooltip = inputAccessoryView._tooltip
        _tooltip.touchRecognizer = self
        _tooltip.translatesAutoresizingMaskIntoConstraints = false
        inputAccessoryView.addSubview(_tooltip)
        _tooltip.heightAnchor.constraint(equalToConstant: _tooltip.frame.height).isActive = true
        _tooltip.bottomAnchor.constraint(equalTo: inputAccessoryView.topAnchor).isActive = true
        _tooltip.widthAnchor.constraint(equalToConstant: _tooltip.frame.width).isActive = true
        _tooltip.centerXAnchor.constraint(equalTo: inputAccessoryView.centerXAnchor).isActive = true

        return inputAccessoryView
    }()
    
    override var inputAccessoryView: UIView? {
        self._inputAccessoryView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}

extension ViewController: TooltipTouchRecognizer {
    
    func didTouchUpInside(_ tooltip: Tooltip) {
        debugPrint("Hello!")
    }
}
