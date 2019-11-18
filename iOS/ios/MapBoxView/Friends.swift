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

struct Friend {
  let title: String
  let creator: String
  let image: UIImage?
  
  init(title: String, creator: String, image: UIImage?) {
    self.title = title
    self.creator = creator
    self.image = image
  }
  
  static func allCats() -> [Friend] {
    return [
      Friend(title: "Sleeping Cat", creator: "papaija2008", image: UIImage(named: "ID-100113060.jpg")),
      Friend(title: "Pussy Cat", creator: "Carlos Porto", image: UIImage(named: "ID-10022760.jpg")),
      Friend(title: "Korat Domestic Cat", creator: "sippakorn", image: UIImage(named: "ID-10091065.jpg")),
      Friend(title: "Tabby Cat", creator: "dan", image: UIImage(named: "ID-10047796.jpg")),
      Friend(title: "Yawning Cat", creator: "dan", image: UIImage(named: "ID-10092572.jpg")),
      Friend(title: "Tabby Cat", creator: "dan", image: UIImage(named: "ID-10041194.jpg")),
      Friend(title: "Cat On The Rocks", creator: "Willem Siers", image: UIImage(named: "ID-10017782.jpg")),
      Friend(title: "Brown Cat Standing", creator: "aopsan", image: UIImage(named: "ID-10091745.jpg")),
      Friend(title: "Burmese Cat", creator: "Rosemary Ratcliff", image: UIImage(named: "ID-10056941.jpg")),
      Friend(title: "Cat", creator: "dan", image: UIImage(named: "ID-10019208.jpg")),
      Friend(title: "Cat", creator: "graur codrin", image: UIImage(named: "ID-10011404.jpg"))
    ]
  }
  
  static func allDogs() -> [Friend] {
    return [
      Friend(title: "White Dog Portrait", creator: "photostock", image: UIImage(named: "ID-10034505.jpg")),
      Friend(title: "Black Labrador Retriever", creator: "Michal Marcol", image: UIImage(named: "ID-1009881.jpg")),
      Friend(title: "Anxious Dog", creator: "James Barker", image: UIImage(named: "ID-100120.jpg")),
      Friend(title: "Husky Dog", creator: "James Barker", image: UIImage(named: "ID-100136.jpg")),
      Friend(title: "Puppy", creator: "James Barker", image: UIImage(named: "ID-100140.jpg")),
      Friend(title: "Black Labrador Puppy", creator: "James Barker", image: UIImage(named: "ID-10018395.jpg")),
      Friend(title: "Yellow Labrador", creator: "m_bartosch", image: UIImage(named: "ID-10016005.jpg")),
      Friend(title: "Black Labrador", creator: "Felixco, Inc.", image: UIImage(named: "ID-10012923.jpg")),
      Friend(title: "Sleepy Dog", creator: "Maggie Smith", image: UIImage(named: "ID-10021769.jpg")),
      Friend(title: "English Springer Spaniel Puppy", creator: "Tina Phillips", image: UIImage(named: "ID-10056667.jpg")),
      Friend(title: "Intelligent Dog", creator: "James Barker", image: UIImage(named: "ID-100137.jpg"))
    ]
  }
}
