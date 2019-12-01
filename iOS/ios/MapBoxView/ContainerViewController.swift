/// Copyright (c) 2019 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit

@available(iOS 13.0, *)
class ContainerViewController: UIViewController {
  enum SlideOutState {
    case bothCollapsed
    case leftPanelExpanded
    case rightPanelExpanded
  }
  
  var mapBoxNavigationController: UINavigationController!
  var mapBoxViewController: MapBoxViewController!
  
  var currentState: SlideOutState = .bothCollapsed {
    didSet {
      let shouldShowShadow = currentState != .bothCollapsed
      showShadowForMapBoxViewController(shouldShowShadow)
    }
  }
  var leftViewController: SidePanelViewController?
  var rightViewController: SidePanelViewController?
  
  let mapBoxPanelExpandedOffset: CGFloat = 60
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    mapBoxViewController = UIStoryboard.mapBoxViewController()
    mapBoxViewController.delegate = self
    
    // wrap the mapBoxViewController in a navigation controller, so we can push views to it
    // and display bar button items in the navigation bar
    mapBoxNavigationController = UINavigationController(rootViewController: mapBoxViewController)
    view.addSubview(mapBoxNavigationController.view)
    addChild(mapBoxNavigationController)
    
    mapBoxNavigationController.didMove(toParent: self)
    
    let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
    mapBoxNavigationController.view.addGestureRecognizer(panGestureRecognizer)
  }
}

private extension UIStoryboard {
    static func mapBoxViewStoryboard() -> UIStoryboard { return UIStoryboard(name: "MapBoxView", bundle: Bundle.main) }
  
  static func leftViewController() -> SidePanelViewController? {
    return mapBoxViewStoryboard().instantiateViewController(withIdentifier: "LeftViewController") as? SidePanelViewController
  }
  
  static func rightViewController() -> SidePanelViewController? {
    return mapBoxViewStoryboard().instantiateViewController(withIdentifier: "RightViewController") as? SidePanelViewController
  }
  
    @available(iOS 13.0, *)
    static func mapBoxViewController() -> MapBoxViewController? {
    return mapBoxViewStoryboard().instantiateViewController(withIdentifier: "MapBoxViewController") as? MapBoxViewController
  }
}

// MARK: MapBoxViewController delegate

@available(iOS 13.0, *)
extension ContainerViewController: MapBoxViewControllerDelegate {
  func toggleLeftPanel() {
    let notAlreadyExpanded = (currentState != .leftPanelExpanded)

    if notAlreadyExpanded {
      addLeftPanelViewController()
    }

    animateLeftPanel(shouldExpand: notAlreadyExpanded)
  }
  
  func addLeftPanelViewController() {
    guard leftViewController == nil else { return }

    if let vc = UIStoryboard.leftViewController() {
      vc.friends = Friend.allCats()
      addChildSidePanelController(vc)
      leftViewController = vc
    }
  }
  
  func animateLeftPanel(shouldExpand: Bool) {
    if shouldExpand {
      currentState = .leftPanelExpanded
      animateMapBoxPanelXPosition(
        targetPosition: mapBoxNavigationController.view.frame.width - mapBoxPanelExpandedOffset)
    } else {
      animateMapBoxPanelXPosition(targetPosition: 0) { _ in
        self.currentState = .bothCollapsed
        self.leftViewController?.view.removeFromSuperview()
        self.leftViewController = nil
      }
    }
    
  }
  
  func toggleRightPanel() {
    let notAlreadyExpanded = (currentState != .rightPanelExpanded)

    if notAlreadyExpanded {
      addRightPanelViewController()
    }

    animateRightPanel(shouldExpand: notAlreadyExpanded)
  }
  
  func addRightPanelViewController() {
    guard rightViewController == nil else { return }
    
    if let vc = UIStoryboard.rightViewController() {
      vc.friends = Friend.allDogs()
      addChildSidePanelController(vc)
      rightViewController = vc
    }
  }

  func animateRightPanel(shouldExpand: Bool) {
    if shouldExpand {
      currentState = .rightPanelExpanded
      animateMapBoxPanelXPosition(
        targetPosition: -mapBoxNavigationController.view.frame.width + mapBoxPanelExpandedOffset)
    } else {
      animateMapBoxPanelXPosition(targetPosition: 0) { _ in
        self.currentState = .bothCollapsed
        
        self.rightViewController?.view.removeFromSuperview()
        self.rightViewController = nil
      }
    }
  }
  
  func collapseSidePanels() {
    switch currentState {
    case .rightPanelExpanded:
      toggleRightPanel()
    case .leftPanelExpanded:
      toggleLeftPanel()
    default:
      break
    }
  }
  
  func animateMapBoxPanelXPosition(targetPosition: CGFloat, completion: ((Bool) -> Void)? = nil) {
    UIView.animate(withDuration: 0.5,
                   delay: 0,
                   usingSpringWithDamping: 0.8,
                   initialSpringVelocity: 0,
                   options: .curveEaseInOut, animations: {
                     self.mapBoxNavigationController.view.frame.origin.x = targetPosition
    }, completion: completion)
  }
  
  func addChildSidePanelController(_ sidePanelController: SidePanelViewController) {
    sidePanelController.delegate = mapBoxViewController
    view.insertSubview(sidePanelController.view, at: 0)
    
    addChild(sidePanelController)
    sidePanelController.didMove(toParent: self)
  }
  
  func showShadowForMapBoxViewController(_ shouldShowShadow: Bool) {
    if shouldShowShadow {
      mapBoxNavigationController.view.layer.shadowOpacity = 0.8
    } else {
      mapBoxNavigationController.view.layer.shadowOpacity = 0.0
    }
  }
    
    
}

// MARK: Gesture recognizer

@available(iOS 13.0, *)
extension ContainerViewController: UIGestureRecognizerDelegate {
  @objc func handlePanGesture(_ recognizer: UIPanGestureRecognizer) {
    let gestureIsDraggingFromLeftToRight = (recognizer.velocity(in: view).x > 0)

    switch recognizer.state {
    case .began:
      if currentState == .bothCollapsed {
        if gestureIsDraggingFromLeftToRight {
          addLeftPanelViewController()
        } else {
          addRightPanelViewController()
        }
        
        showShadowForMapBoxViewController(true)
      }
      
    case .changed:
      if let rview = recognizer.view {
        rview.center.x = rview.center.x + recognizer.translation(in: view).x
        recognizer.setTranslation(CGPoint.zero, in: view)
      }
      
    case .ended:
      if let _ = leftViewController,
        let rview = recognizer.view {
        // animate the side panel open or closed based on whether the view
        // has moved more or less than halfway
        let hasMovedGreaterThanHalfway = rview.center.x > view.bounds.size.width
        animateLeftPanel(shouldExpand: hasMovedGreaterThanHalfway)
      } else if let _ = rightViewController,
        let rview = recognizer.view {
        let hasMovedGreaterThanHalfway = rview.center.x < 0
        animateRightPanel(shouldExpand: hasMovedGreaterThanHalfway)
      }
      
    default:
      break
    }
  }
}
