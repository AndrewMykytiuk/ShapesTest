//
//  ViewController.swift
//  ShapeCreatorTest
//
//  Created by user on 25.05.2023.
//

import UIKit

final class MainViewController: UIViewController {
    
    @IBOutlet weak private var shapesView: UIView!
    @IBOutlet weak private var tableView: UITableView! {
        didSet {
            tableView.register(ShapeTableViewCell.self, forCellReuseIdentifier: String(describing: ShapeTableViewCell.self))
        }
    }
    
    static let identifier = "MainViewController"
    private let navigationTitle = "Add Shape"
    
    private var activeView: UIView?
    private var panGestureRecognizer: UIPanGestureRecognizer?
    private var tapGestureRecognizer: UITapGestureRecognizer?
    private var initialCenter = CGPoint()
    
    private var state: UIGestureRecognizer.State = .possible
    
    private var shapes: [ShapeModel] = []
    private var shapeViews: [UIView] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: navigationTitle, style: .plain, target: self, action: #selector(self.addShape(sender:)))
    }
    
    private func addRandomShape() {
        let randomInt = Int.random(in: 1..<4)
        guard let shapeType = ShapeType(rawValue: randomInt) else { return }
        let shapeModel = ShapeModel(shape: shapeType, isAlreadyDrew: false)
        if shapes.count >= 3 {
            createAlertView()
        } else {
            shapes.append(shapeModel)
        }
    }
    
    private func setupViews() {
        guard shapes.count > 0 else { return }
        var shapeView = UIView()
        for index in 0..<shapes.count {
            if shapes[index].isAlreadyDrew {
                continue
            }
            let shapeFrame = CGRect(x: (self.view.frame.width / 3.0) * CGFloat(index), y: shapesView.frame.midX / 2, width: shapesView.frame.width / 3, height: shapesView.frame.width / 2)
            
            switch shapes[index].shape {
            case .circle:
                shapeView = CircleView(frame: shapeFrame)
            case .square:
                shapeView = SquareView(frame: shapeFrame)
            case .star:
                shapeView = StarView(frame: shapeFrame)
            }
            shapeView.tag = index
            shapes[index].isAlreadyDrew = true
        }

        activeView = shapeView
        shapesView.addSubview(shapeView)
        shapeViews.append(shapeView)
        let pinchGesture = UIPinchGestureRecognizer(target: self, action:#selector(scalePiece(_:)))
        self.activeView?.addGestureRecognizer(pinchGesture)
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(dragTheView))
        guard let panGestureRecognizer = panGestureRecognizer else { return }
        activeView?.addGestureRecognizer(panGestureRecognizer)
        let rotationGesture = UIRotationGestureRecognizer(target: self, action: #selector(rotatePiece(_:)))
        activeView?.addGestureRecognizer(rotationGesture)
    }
    
    private func removeShape(at index: Int) {
        shapes.remove(at: index)
        
        let views = shapesView.subviews.filter( { $0.isKind(of: StarView.self) || $0.isKind(of: CircleView.self) || $0.isKind(of: SquareView.self)})
        
        for subview in views {
            if (subview.tag == index) {
                subview.removeFromSuperview()
                break
            }
            
            if views.count != shapes.count {
                if (subview.tag == index + 1) {
                    subview.removeFromSuperview()
                    break
                } else if (subview.tag == index + 2) {
                    subview.removeFromSuperview()
                }
                
            }
        }
        setupViews()
    }

    private func createAlertView() {
        let alert = UIAlertController(title: "Temporary maximum reached", message: "No more shapes for now", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
        }))
        self.present(alert, animated: true, completion: nil)
    }

}

extension MainViewController {

    @objc private func addShape(sender: UIBarButtonItem) {
        addRandomShape()
        setupViews()
        tableView.reloadData()
    }
    
    @objc private func dragTheView(recognizer: UIPanGestureRecognizer) {
        
        guard let panGestureRecognizer = panGestureRecognizer, let piece = panGestureRecognizer.view else {return}
        // Get the changes in the X and Y directions relative to
        // the superview's coordinate space.
        var translation = panGestureRecognizer.translation(in: piece.superview)
        
        
        //*Commented code for part of fix - dragging not only last added view, need more time for deep research*
        // Few troubles with sizes of created views
        
//        let views = shapesView.subviews.filter( { $0.isKind(of: StarView.self) || $0.isKind(of: CircleView.self) || $0.isKind(of: SquareView.self)})
//
//        var uiv = UIView()
//        var float: CGFloat = 500
//
//        for view in views {
//            var x = distanceToRect(rect: view.frame, fromPoint: translation)
//            if x < float {
//                float = x
//                uiv = view
//            }
//        }
//        if piece != uiv {
//            piece = uiv
//            if state == .possible {
//                state = .began
//            } else if state == .began {
//                state = .changed
//            } else if state == .changed {
//                state = .ended
//            }
//        }
//
//        if state != .possible {
//            panGestureRecognizer.state = state
//            translation = panGestureRecognizer.translation(in: piece.superview)
//        }
        
        
        if panGestureRecognizer.state == .began {
            // Save the view's original position.
            self.initialCenter = piece.center
        }
        
        if panGestureRecognizer.state == .changed {
            let newCenter = CGPoint(x: initialCenter.x + translation.x, y: initialCenter.y + translation.y)
            piece.center = newCenter
        } else if panGestureRecognizer.state == .ended {
            let newCenter = CGPoint(x: initialCenter.x + translation.x, y: initialCenter.y + translation.y)
            if !shapesView.bounds.contains(newCenter) {
                // In case of move out from ShapeView, return the piece to its original location.
                piece.center = initialCenter
            }
        } else if panGestureRecognizer.state == .possible {
            return
        }
        else {
            // On cancellation, return the piece to its original location.
            piece.center = initialCenter
        }
    }
    
    @objc private func scalePiece(_ gestureRecognizer : UIPinchGestureRecognizer) {
        guard gestureRecognizer.view != nil else { return }

       if gestureRecognizer.state == .began || gestureRecognizer.state == .changed {
           gestureRecognizer.view?.transform = (gestureRecognizer.view?.transform.scaledBy(x: gestureRecognizer.scale, y: gestureRecognizer.scale))!
          gestureRecognizer.scale = 1.0
       }}
    
    @objc private func rotatePiece(_ gestureRecognizer : UIRotationGestureRecognizer) {
       guard gestureRecognizer.view != nil else { return }
            
       if gestureRecognizer.state == .began || gestureRecognizer.state == .changed {
          gestureRecognizer.view?.transform = gestureRecognizer.view!.transform.rotated(by: gestureRecognizer.rotation)
          gestureRecognizer.rotation = 0
       }}
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        shapes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ShapeTableViewCell.self), for: indexPath) as? ShapeTableViewCell else {
            return UITableViewCell()
        }
        cell.setUp(with: shapes[indexPath.row])
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            tableView.beginUpdates()
            removeShape(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .left)
            tableView.endUpdates()
        }
    }
    
}
