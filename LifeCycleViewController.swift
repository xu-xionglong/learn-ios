import Foundation

import UIKit

class LifeCycleViewController: UIViewController {
    enum PresentMode {
        case presentFromNav //not add to navigation stack
        case presentFromSelf //not add to navigation stack
        case showFromNav //add to navigation stack
        case showFromSelf //add to navigation stack
        case pushFromNav //add to navigation stack
    }
    
    let mode: PresentMode
    let tag: Int
    init(tag: Int, mode: PresentMode) {
        self.tag = tag
        self.mode = mode
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.red
        print("LifeCycleViewController \(tag) viewDidLoad")
        
        if let nav = navigationController {
            print("LifeCycleViewController \(tag) 's navigationController now has " + String(nav.viewControllers.count) + " sub controllers")
        }
        else {
            print("LifeCycleViewController \(tag) is not hold by navigationController")
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(onTap))
        view.addGestureRecognizer(tap)
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(onSwipe))
        view.addGestureRecognizer(swipe)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("LifeCycleViewController \(tag) viewWillAppear")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("LifeCycleViewController \(tag) viewDidAppear")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("LifeCycleViewController \(tag) viewWillDisappear")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("LifeCycleViewController \(tag) viewDidDisappear")
    }
    
    deinit {
        print("LifeCycleViewController \(tag) deinit");
    }
    
    @objc func onTap() {
        let nextViewController = LifeCycleViewController(tag: tag + 1, mode: mode)
        nextViewController.modalPresentationStyle = .fullScreen
        
        if (mode == .presentFromSelf) {
            print("present from self")
            present(nextViewController, animated: false, completion: nil)
        }
        else if (mode == .showFromSelf) {
            print("show from self")
            show(nextViewController, sender: nil)
        }
        else if let nav = navigationController {
            if (mode == .presentFromNav) {
                print("present from nav")
                nav.present(nextViewController, animated: false, completion: nil)
            }
            else if (mode == .showFromNav) {
                print("show from nav")
                nav.show(nextViewController, sender: nil)
            }
            else if (mode == .pushFromNav) {
                print("push from nav")
                nav.pushViewController(nextViewController, animated: false)
            }
        }
        
    }
    @objc func onSwipe() {
        if let nav = self.navigationController {
            print("pop by nav")
            nav.popViewController(animated: false)
        }
        else {
            print("dismiss by self")
            dismiss(animated: false)
        }
        
    }
}
