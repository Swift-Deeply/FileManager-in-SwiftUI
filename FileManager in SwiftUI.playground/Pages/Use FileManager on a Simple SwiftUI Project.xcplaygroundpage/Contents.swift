/*:
# Use FileManager on a Simple SwiftUI Project
 To understand how to use FileManager in SwiftUI, we will make a project similar to the one I created in my "[Getting Started With The FileManager in Your iOS App](https://medium.com/better-programming/getting-started-with-the-filemanager-in-your-ios-app-acd81b171f7d)"  article. SwiftUI works a little differently than UIKit, that's why we will need to make some changes in the FileManager class that we will do here.
 
## Creating Xcode Project
 Let's create a new Xcode project. Of course our project's interface must be SwiftUI.
 ![Image 1](Image-1.png)
 Of course, you can give the project any name you want. After that, the only thing left is to start making your project.
 
 My advice to you while developing a project is to divide your files into folders. While doing this project, you can use folders in the same way I use them.
 ![Image 2](Image-2.png)
 
 ## Building the data model
 In this article, we will create a note app. Thus, our data model should represent a single note object. This model has four properties: `id`, `title`, `description`.
*/
struct Note: Codable, Identifiable {
    
    // MARK: - Properties
    var id = UUID()
    let title: String
    let description: String
}
/*:
 In this data model we use Codable and Identifiable protocols:
 
 *Codable:* Codable is a type alias for the Encodable and Decodable protocols. When you use Codable as a type or a generic constraint, it matches any type that conforms to both protocols.
 
 *Identifiable:* Use the Identifiable protocol to provide a stable notion of identity to a class or value type. For example, you could define a User type with an id property that is stable across your app and your app's database storage. You could use the id property to identify a particular user even if other data fields change, such as the user's name.
*/
/*:
## Preparing FileManager Class
 Now our data model is ready, we can start creating our FileManager class. To do that, let's create a new Swift file which calls "DataProvider".
*/
class DataProvider: ObservableObject {

}
/*:
 As you can see, we’re using `ObservableObject` protocol that is for data transferring: By default an `ObservableObject` synthesizes an `objectWillChange` publisher that emits the changed value before any of its `@Published` properties changes. In our class, `@Published` property will be the `Note` object array.
*/
class DataProvider: ObservableObject {

    // MARK: - Properties
    @Published var allNotes = [Note]()
}
/*:
 Define a value named “shared” to call the DataProvider class outside itself.
*/
class DataProvider: ObservableObject {

    // MARK: - Properties
    static let shared = DataProvider()
    @Published var allNotes = [Note]()
}
/*:
 To store data with FileManager, we need a URL object. We define a property for that.
*/
class DataProvider: ObservableObject {

    // MARK: - Properties
    static let shared = DataProvider()
    private let dataSourceURL: URL
    @Published var allNotes = [Note]()
}
/*:
 As I said before, a value we are using `@Published` property wrapper cannot be a computed property. That’s why, we have to use two extra method for get and set data operations.

 First, write a method called "getAllNotes" to bring back the `Note` array we saved earlier, but if we haven’t saved any `Note` object, the method has to return empty array. This is very important, otherwise our app will crush.
*/
// MARK: - Methods
private func getAllNotes() -> [Note] {
    do {
        let decoder = PropertyListDecoder()
        let data = try Data(contentsOf: dataSourceURL)
        let decodedNotes = try! decoder.decode([Note].self, from: data)
            
        return decodedNotes
    } catch {
        return []
    }
}
/*:
 We will use the "getAllNotes" method inside the `init` method, otherwise the `allNotes` element will be empty and our app will crush. Therefore, after defining the "dataSourceURL" element in the `init` method, we equalize the "allNotes" element with "getAllNotes".
*/
// MARK: - Life Cycle
init() {
    let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    let notesPath = documentsPath.appendingPathComponent("notes").appendingPathExtension("json")
    dataSourceURL = notesPath
       
    _allNotes = Published(wrappedValue: getAllNotes())
}
/*:
 You may be asking why it equates the two values in this way, because "allNotes" has a "_" at the beginning and “getAllNotes” method is converting to `@Published` property.

 Now we can define the method that allows us to save the data. This method should be private, because we won’t this method outside the “DataProvider” class.
*/
private func saveNotes() {
    do {
        let encoder = PropertyListEncoder()
        let data = try encoder.encode(allNotes)
        try data.write(to: dataSourceURL)
    } catch {

    }
}
/*:
 To create a new `Note` object, write the method below. As you can see, after insert a new `Note` object to `allNotes`, we call `saveNotes` method for just saving the changes.
*/
func create(note: Note) {
    allNotes.insert(note, at: 0)
    saveNotes()
}
/*:
 Write a method to replace a previously defined `Note` object. Similarly, after making changes, we call the `saveNotes` method.
*/
func changeNote(note: Note, index: Int) {
    allNotes[index] = note
    saveNotes()
}
/*:
 Write a new method to delete a `Note` object. To delete the element in a `List` object in SwiftUI, we need the `offsets` information of that element. That’s why, this method has a `offsets` parameter.
*/
func delete(_ offsets: IndexSet) {
    allNotes.remove(atOffsets: offsets)
    saveNotes()
}
/*:
 Finally, write a method called `move` to move a `List` cell. The information source of the cells in the `List` object -we will create- will be `allNotes` array. Therefore, when we change the position of a cell, we need to change the offsets of the `Note` object of that cell.
*/
/*: With this method, we finish “DataProvider” class! */
/*:
 ## Preparing UI
 To access the properties and methods in “DataProvider” class, let's define an element using the `@ObservedObject` property wrapper below in main `View` object.
 */
struct MainView: View {

    // MARK: - Properties
    @ObservedObject var dataProvider = DataProvider.shared

    // MARK: - UI Elements
    var body: some View {
        Text("Hello, World!")
    }
}
/*: In this way, we can basically build our main UI. */
struct MainView: View {

    // MARK: - Properties
    @ObservedObject var dataProvider: DataProvider

    // MARK: - UI Elements
    var body: some View {
        NavigationView {
            List {
                ForEach(dataProvider.allNotes) { note in
                    VStack(alignment: .leading) {
                        Text("\(note.title)")
                            .font(.headline)
                        
                        Text("\(note.description)")
                            .font(.footnote)
                    }
                }
            }
            .navigationTitle(Text("Notes"))
            .listStyle(InsetListStyle())
        }
    }
}
/*: In order to make the code more solid, create a custom object with the objects we write in the `ForEach` object. */
struct NoteListCell: View {
    
    // MARK: - Properties
    let note: Note
    
    // MARK: - UI Elements
    var body: some View {
        VStack(alignment: .leading) {
            Text("\(note.title)")
                .font(.headline)
            
            Text("\(note.description)")
                .font(.footnote)
        }
    }
}
/*: As you can see, our main `View` object is much more readable. */
struct MainView: View {

    // MARK: - Properties
    @ObservedObject var dataProvider: DataProvider

    // MARK: - UI Elements
    var body: some View {
        NavigationView {
            List {
                ForEach(dataProvider.allNotes) { note in
                    NoteListCell(note: note)
                }
            }
            .navigationTitle(Text("Notes"))
            .listStyle(InsetListStyle())
        }
    }
}
/*:
 Currently we cannot add, edit or delete a new `Note` object in our application. Therefore, when you run the project right now, there is no functionality in the app. First, let's start creating the UI elements to interact with.

 To create UI elements, we need to create two variables: `alertShowing` and `editMode`. `alertShowing` is a `Bool` type value and if it will be true, the `Alert` object can appear. `editMode` is a `EditMode` type value and if it will `.active`, the `List` object’s cells will be editable and deletable.
 */
// MARK: - Properties
@ObservedObject var dataProvider: DataProvider
@State private var alertShowing = false
@State private var editMode: EditMode = .inactive
/*:
 Our new object adding and editing buttons will be in the `NavigationView` object. We use the `navigationBarItems` modifier to place buttons inside `NavigationView`.
 */
.navigationTitle(Text("Notes"))
.navigationBarItems(
    leading: EditButton(),
    trailing: Button(action: {
        withAnimation {
            if alertShowing {
                alertShowing = false
            } else {
                alertShowing = true
            }
        }
    }) {
        Image(systemName: "plus.circle.fill")
    }
)
/*:
 It is not right to have the add button active while editing the List object. That’s why, let's convert the add button to a custom object named "AddButton" and when the `editMode` element equal to “.active", it turn into an `EmptyView` object.
 */
struct AddButton: View {

    // MARK: - Properties
    @Binding var editMode: EditMode
    @Binding var alertShowing: Bool

    // MARK: - UI Elements
    var body: some View {
        if editMode == .inactive {
            return AnyView(Button(action: {
                    withAnimation {
                        if alertShowing {
                            alertShowing = false
                        } else {
                            alertShowing = true
                        }
                    }
                }) {
                    Image(systemName: "plus.circle.fill")
                })
        } else {
            return AnyView(EmptyView())
        }
    }
}
/*: In this way, the `navigationBarItems` modifier has also become quite small. */
.navigationBarItems(
    leading: EditButton(),
    trailing: AddButton(editMode: $editMode, alertShowing: $alertShowing)
)
/*: By writing the `environment` modifier at the end of the `List` object, we can make the `List` object editable when the `EditButton` is clicked. */
.listStyle(InsetListStyle())
.environment(\.editMode, $editMode)
/*: Finally, we need to use the `onDelete` and `onMove` modifiers so that the cells in the list object can be deletable and editable. Here, we use `move` and `delete` methods we wrote earlier in the `perform` parameters. */
ForEach(dataProvider.allNotes) { note in
    NoteListCell(note: note)
}
.onDelete(perform: dataProvider.delete)
.onMove(perform: dataProvider.move)
/*:
 Currently we can edit and delete the `List` object cells, but we cannot add a new `Note` object. That’s why, our app does not make any sense right now, as there is no `Note` object attached. If we create UI elements to add new `Note` objects, our app will become what we want.

 We will use an `Alert` object to add a new `Note` object. This may seem easy to you, but SwiftUI still doesn't have an `Alert` object with `TextField` object(s) in it. Therefore, we need to create custom `Alert` object with `UIViewControllerRepresentable`.

 The first thing we will do is create a new `UIViewController`, just like defining a custom `UIAlertViewController` in UIKit. To do this, you can create a Swift file named "TextFieldAlertViewController" and import “SwiftUI” and “Combine” frameworks.
 */
import SwiftUI
import Combine
/*:
 After that we can create the `TextFieldAlertViewController` class. The codes we write in the codes below will help us create the `UIAlertController` object.
 */
class TextFieldAlertViewController: UIViewController {

    // MARK: - Properties
    private let alertTitle: String
    private let message: String?
    private var isPresented: Binding<Bool>?

    private var subscription: AnyCancellable?
    
    // MARK: - Life Cycle
    init(title: String, message: String?, isPresented: Binding<Bool>?) {
        self.alertTitle = title
        self.message = message
        self.isPresented = isPresented
        
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
/*:
 Create a method called `presentAlertController` and write this method in `viewDidAppear`.
 */
class TextFieldAlertViewController: UIViewController {

    // ...

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        presentAlertController()
    }

    // MARK: - Methods
    private func presentAlertController() {
        guard subscription == nil else { return }
        let ac = UIAlertController(title: alertTitle, message: message, preferredStyle: .alert)
        
        ac.view.tintColor = .red
        
        ac.addTextField()
        ac.addTextField()
        ac.textFields![0].placeholder = "Title"
        ac.textFields![1].placeholder = "Description"

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { [weak self] _ in
            self?.isPresented?.wrappedValue = false
        }
        let createAction = UIAlertAction(title: "Create", style: .default) { [unowned ac] _ in
            let title = ac.textFields![0].text!
            let description = ac.textFields![1].text!
            let note = Note(title: title, description: description)
            
            DataProvider.shared.create(note: note)
        }
        
        ac.addAction(cancelAction)
        ac.addAction(createAction)
        present(ac, animated: true, completion: nil)
    }
}
/*: As our custom `Alert` object that we will use in our main `View` object, we create a custom UI object named “TextFieldAlert”. */
struct TextFieldAlert {

    // MARK: Properties
    let title: String
    let message: String?
    var isPresented: Binding<Bool>? = nil

    // MARK: - Methods
    func dismissable(_ isPresented: Binding<Bool>) -> TextFieldAlert {
        TextFieldAlert(title: title, message: message, isPresented: isPresented)
    }
}
/*: We use the `UIViewControllerRepresentable` protocol to use a custom UIKit elements in SwiftUI. Likewise, we will use it with `TextAlert` object. */
struct TextFieldAlert {

    // ...
}

extension TextFieldAlert: UIViewControllerRepresentable {

    typealias UIViewControllerType = TextFieldAlertViewController

    func makeUIViewController(context: UIViewControllerRepresentableContext<TextFieldAlert>) -> UIViewControllerType {
        TextFieldAlertViewController(title: title, message: message, isPresented: isPresented)
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: UIViewControllerRepresentableContext<TextFieldAlert>) {}
}
/*: Then, create a `View` element named “TextFieldWrapper” to define what needs to be done when `TextAlert` object will not and will be displayed in our main `View` object. */
struct TextFieldWrapper<PresentingView: View>: View {

    // MARK: - Properties
    @Binding var isPresented: Bool
    let presentingView: PresentingView
    let content: () -> TextFieldAlert

    // MARK: - UI Elements
    var body: some View {
        ZStack {
            if (isPresented) { content().dismissable($isPresented) }
            presentingView
        }
    }
}
/*: Just like `alert` modifier, we create a modifier named `textAlert` in order to use the `TextAlert` object as an `Alert` object in our app. */
extension View {
    
    // MARK: - Methods
    func textFieldAlert(isPresented: Binding<Bool>, content: @escaping () -> TextFieldAlert) -> some View {
        TextFieldWrapper(isPresented: isPresented, presentingView: self, content: content)
    }
}
/*: Now we can use our `TextAlert` object in our app using `textFieldAlert` modifier. */
.navigationBarItems(
    // ...
)
.textFieldAlert(isPresented: $alertShowing) {
    TextFieldAlert(title: "Write a note!", message: nil)
}
/*:
 ## See The Result!
 Our app is ready. Now we can test it! As you can see, SwiftUI allows us to do many actions automatically.
 ![GIF 1](GIF-1.gif)
 */
//: Page 4 / 4  |  [Previous: How to Use FileManager in SwiftUI?](@previous)
