import Foundation

import UIKit
import SnapKit

//1. updateConstraints from subview to superview
//2. layoutSubviews from superview to subview

class RootView: UIView {
    override func layoutSubviews() {
        //override this when
        //1. Constraints are not enough to express view’s layout.
        //2. Frames are calculated programmatically.
        super.layoutSubviews()
        print("RootView layoutSubviews")
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        print("RootView updateConstraints")
    }
}

class FirstView: UIView {
    override func layoutSubviews() {
        super.layoutSubviews()
        print("FirstView layoutSubviews")
    }
    override func updateConstraints() {
        super.updateConstraints()
        print("FirstView updateConstraints")
    }
}

class SecondView: UIView {
    override func layoutSubviews() {
        super.layoutSubviews()
        print("SecondView layoutSubviews")
    }
    override func updateConstraints() {
        super.updateConstraints()
        print("SecondView updateConstraints")
    }
}


class AutoLayoutViewController: UIViewController {
    override func loadView() {
        view = RootView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("AutoLayoutViewController viewDidLoad")
        
        let firstView = FirstView()
        firstView.backgroundColor = UIColor.red
        view.addSubview(firstView)
        
        let secondView = SecondView()
        view.addSubview(secondView)
        secondView.backgroundColor = UIColor.green
        
        firstView.snp.makeConstraints { (make) in
            make.height.equalTo(self.view).dividedBy(3)
            make.top.equalTo(self.view)
            make.width.equalTo(self.view)
            make.left.equalTo(self.view)
        }
        
        
        secondView.snp.makeConstraints { (make) in
            make.top.equalTo(firstView.snp.bottom)
            make.bottom.equalToSuperview()
            make.left.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("AutoLayoutViewController viewWillAppear")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("AutoLayoutViewController viewDidAppear")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("AutoLayoutViewController viewWillDisappear")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("AutoLayoutViewController viewDidDisappear")
    }
    
    
    override func viewWillLayoutSubviews() {
        print("AutoLayoutViewController viewWillLayoutSubviews")
    }
    
    override func viewDidLayoutSubviews() {
        print("AutoLayoutViewController viewDidLayoutSubviews")
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        print("AutoLayoutViewController updateViewConstraints")
    }
    deinit {
        print("AutoLayoutViewController deinit")
    }
}