/*:
# How to Use FileManager in SwiftUI?
 To store and edit datas in FileManager, we need to use decoders and encoders. (Obviously, all file managers basically use decoders and encoders.)
 
 Usually, we store the values in FileManager directly from the Data type. Data type can be considered to be the most basic data type, because when you store data with Data type, you are directly storing the 0 and 1 equivalent of that data. You know that all the data in your computer basically consists of 0s and 1s.
 
 There are basically two things we can do with FileManager: Decode and encode the data. For example, we can decode a custom object array using `PropertyListDecoder` as below.
*/
let decoder = PropertyListDecoder()
let data = try Data(contentsOf: dataSourceURL)
let decodedNotes = try! decoder.decode([Note].self, from: data)
/*:
 Similarly, we can add a custom object to the custom object array using the `PropertyListEncoder` object as follows.
*/
let encoder = PropertyListEncoder()
let data = try encoder.encode(allNotes)
try data.write(to: dataSourceURL)
/*:
 In SwiftUI, unlike UIKit, we have to do these operations separately, because Swift doesn't allow us to use the property wrapper in a computed property. We will see this while developing the sample project.
*/
//: Page 3 / 4  |  [Next: Use FileManager on a Simple SwiftUI Project](@next)
