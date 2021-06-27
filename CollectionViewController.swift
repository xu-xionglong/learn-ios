import Foundation
import UIKit

private class ViewCell: UICollectionViewCell {
    let label = UILabel()
    let button = UIButton()
    override init(frame: CGRect) {
        super.init(frame: frame)
        label.backgroundColor = UIColor.yellow
        label.textColor = UIColor.black
        contentView.addSubview(label)
        
        button.backgroundColor = UIColor.red
        contentView.addSubview(button)
        
        label.snp.makeConstraints { (make) in
            make.left.top.bottom.equalToSuperview()
            make.right.equalToSuperview().inset(10)
        }
        button.snp.makeConstraints { (make) in
            make.left.equalTo(label.snp.right)
            make.top.bottom.right.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class CollectionViewController: UIViewController {
    var collectionView: UICollectionView!
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ViewCell.self, forCellWithReuseIdentifier: "id")
        //weak reference
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.blue
        collectionView.isPagingEnabled = false
        collectionView.showsHorizontalScrollIndicator = false
        view.addSubview(collectionView)
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(onPan(_:)))
        pan.delegate = self
        collectionView.addGestureRecognizer(pan)
        
        collectionView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalTo(150)
        }
    }
}

extension CollectionViewController: UICollectionViewDelegateFlowLayout {
    //UICollectionViewFlowLayout.sectionInset
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    //UICollectionViewFlowLayout.itemSize
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
}

extension CollectionViewController: UICollectionViewDataSource {
    //required
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    //required
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("cellForItemAt \(indexPath.item)")
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "id", for: indexPath) as! ViewCell
        cell.label.text = String(indexPath.item)
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        print("willDisplay \(indexPath.item)")
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("didSelectItemAt \(indexPath.item)")
    }
    
    //reordering
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
    }
    
}

extension CollectionViewController {
    @objc func onPan(_ gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .began:
            //Gets the index path of the item at the specified point in the collection view.
            if let indexPath = collectionView.indexPathForItem(at: gesture.location(in: collectionView)) {
                collectionView.beginInteractiveMovementForItem(at: indexPath)
            }
        case .changed:
            collectionView.updateInteractiveMovementTargetPosition(gesture.location(in: collectionView))
        case .ended:
            collectionView.endInteractiveMovement()
        default:
            collectionView.cancelInteractiveMovement()
        }
    }
}

//gesture conflicting
extension CollectionViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if let indexPath = collectionView.indexPathForItem(at: touch.location(in: collectionView)) {
            let cell = collectionView.cellForItem(at: indexPath) as! ViewCell
            if (cell.button.bounds.contains(touch.location(in: cell.button))) {
                return true
            }
        }
        return false
    }
}
