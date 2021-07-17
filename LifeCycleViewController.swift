import Foundation

import UIKit

//Show - Pushes the destination view controller onto the navigation stack, sliding overtop from right to left, providing a back button to return to the source - or if not embedded in a navigation controller it will be presented modally
//Example: Navigating inboxes/folders in Mail

//Show Detail - For use in a split view controller, replaces the detail/secondary view controller when in an expanded 2 column interface, otherwise if collapsed to 1 column it will push in a navigation controller
//Example: In Messages, tapping a conversation will show the conversation details - replacing the view controller on the right when in a two column layout, or push the conversation when in a single column layou


//Present Modally - Presents a view controller in various animated fashions as defined by the Presentation option, covering the previous view controller - most commonly used to present a view controller that animates up from the bottom and covers the entire screen on iPhone, or on iPad it's common to present it as a centered box that darkens the presenting view controller
//Example: Selecting Touch ID & Passcode in Settings


//Popover Presentation - When run on iPad, the destination appears in a popover, and tapping anywhere outside of this popover will dismiss it, or on iPhone popovers are supported as well but by default it will present the destination modally over the full screen
//Example: Tapping the + button in Calendar


//advantages of using navigation controller
//1. Keeps your app looking how users expect an iOS app to look
//2. Takes care of navigation titles and links for you so you can focus on the rest of your app
//3. Gives users gesture controls for back, forward
//4. Manages the navigation stack, allowing you to easily jump between view controllers that might be further down in the stack (skip back to the homepage from a few view controllers in)
//5. Has a delegate property so that you can have an object that understands where the user is in the app at all times

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
