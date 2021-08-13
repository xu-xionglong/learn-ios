import Foundation

import UIKit
import SnapKit

//1. updateConstraints from subview to superview
//2. layoutSubviews from superview to subview

private class RootView: UIView {
//    1.初始化不会触发layoutSubviews，但是如果设置了不为CGRectZero的frame的时候就会触发。
//    2.addSubview会触发layoutSubviews
//    3.设置view的Frame会触发layoutSubviews，当然前提是frame的值设置前后发生了变化
//    4.滚动一个UIScrollView会触发layoutSubviews
//    5.旋转Screen会触发父UIView上的layoutSubviews事件
//    6.改变一个UIView大小的时候也会触发父UIView上的layoutSubviews事件
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

private class FirstView: UIView {
    override func layoutSubviews() {
        super.layoutSubviews()
        print("FirstView layoutSubviews")
    }
    override func updateConstraints() {
        super.updateConstraints()
        print("FirstView updateConstraints")
    }
}

private class SecondView: UIView {
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
        //没有重写loadView方法时，无法自定义root view，无法重写view的layoutSubviews方法，此时需要controller的回调
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

//AutoLayoutViewController viewDidLoad
//AutoLayoutViewController viewWillAppear
//FirstView updateConstraints
//SecondView updateConstraints
//RootView updateConstraints
//AutoLayoutViewController updateViewConstraints

//AutoLayoutViewController viewWillLayoutSubviews
//RootView layoutSubviews
//AutoLayoutViewController viewDidLayoutSubviews
//SecondView layoutSubviews
//FirstView layoutSubviews

//AutoLayoutViewController viewDidAppear
