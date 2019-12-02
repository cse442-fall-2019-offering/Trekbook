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

class LeftPanelViewController: SidePanelViewController {
    @IBOutlet weak var ProfileImage: UIView!
    @IBOutlet weak var ProfileName: UILabel!
    @IBOutlet weak var ProfileUsername: UILabel!
    
    func updateProfile(){

        ProfileName.text = User?.data.fullname
        ProfileUsername.text = User?.data.username
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // tableView.reloadData()
        updateProfile()
      }
}

class RightPanelViewController: SidePanelViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var FriendTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        FriendTableView.delegate = self
        FriendTableView.dataSource = self
        FriendTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath) as! FriendCell
        cell.configureForFriend((UserList?.data.users[indexPath.row])!)
        cell.friendImage.image = UIImage(named: "hiclipart.com")
        
//        cell.friendNameLabel.text = "testing testing"
//        cell.friendUsernameLabel.text = "ttttesting"
        return cell
      }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (UserList?.data.users.count)!
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 135
    }
}



class SidePanelViewController: UIViewController {
    
    var delegate: SidePanelViewControllerDelegate?
  
  var friends: [Friend]!
  
  enum CellIdentifiers {
    static let FriendCell = "FriendCell"
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // tableView.reloadData()
//    updateProfile()
  }
    

    

}

// MARK: Table View Data Source
//extension SidePanelViewController: UITableViewDataSource {
//  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//    return friends.count
//  }
//
//  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//    let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.FriendCell, for: indexPath) as! FriendCell
//    cell.configureForFriend(friends[indexPath.row])
//    return cell
//  }
//    // Create a standard header that includes the returned text.
//    func tableView(_ tableView: UITableView, titleForHeaderInSection
//                                section: Int) -> String? {
//        return "                    Friends List"
//    }
//
//}
//
//// Mark: Table View Delegate
//
//extension SidePanelViewController: UITableViewDelegate {
//  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//    let friend = friends[indexPath.row]
//    delegate?.didSelectFriend(friend)
//  }
//}

protocol SidePanelViewControllerDelegate {
  func didSelectFriend(_ friend: Friend)
}
