import UIKit
import Tempo
import PlaygroundSupport

/*:
## Tempo

Tempo is an application architecture for Harmony that implements unidirectional data flow, inspired by [Flux](https://facebook.github.io/flux/).  Tempo's goal is to simplify the updating of complex views.

### Data Flow

As in Flux, data in a Tempo application flows in a single direction.

![Flow](flow.png)

This flow is the most important concept to understand when programming in Tempo. Each time a view needs to be updated, a presenter receives a brand new immutable view state it can use to update a particular view.

When the user (or other external stimuli) interacts with application instead of mutating state directly, events are triggered via the dispatcher.  In response to those events, a new view state is calculated and propogated to the presenter which updates the view.

![Events](events.png)

*/

/*:
### View State

At the heart of Tempo is the view state.  A view state is an immutable representation of information that is to be displayed on a view.  It serves a similar purpose to the ViewModel in MVVM, except that it is an inert value.  **A presenter/view never directly modifies the view state.**
*/

struct NameViewState: TempoViewState {
    var currentName = "Bullseye"
}

/*:
### Presenter

A presenter's job is to render a view state by making modifications to a particular view or collection of views.  Presenters get notified whenever the view state changes and update their views accordingly.  A presenter should generally not maintain any state or perform any side effects when presenting (with the exception of historical view state for efficient updates.)
*/

class NamePresenter: TempoPresenter {
    let label: UILabel

    init(label: UILabel) {
        self.label = label
    }

    func present(_ viewState: NameViewState) {
        label.text = "Name: \(viewState.currentName)"
    }
}

let label = UILabel()
let presenter = NamePresenter(label: label)
presenter.present(NameViewState())

// Now the label should be up to date
label.text

/*:
### Section Presenter

You can make presenters for any kind of view, but where Tempo shines is when it comes to collection views. Tempo ships with a `SectionPresenter` that handles the logic of dynamically updating collection views.  It also helps to cleanly separate the functionality of collection views with lots of different items.

A `TempoSectionedViewState` represents a collection of sections each represented by a `TempoViewStateSection`. Each `TempoViewStateSection` should contain one or more items each represented by a `TempoViewStateItem`. By accessing an array of sections on your view state, the `SectionPresenter` can handle inserting, removing, and updating the corresponding sections and items in a collection view for you.

Note that `sections` in this example is a computed property.  This isn't strictly necessary, but it can be helpful to follow this pattern so that you don't need to try and be clever about which sections need updating.  Tempo will calculate the changes across view states for you, so it's okay if sections are recreated every time.
*/

struct CounterItem: Equatable, TempoViewStateItem {
    let count: Int
}

struct CounterSection: TempoViewStateSection {
    let items: [TempoViewStateItem]
    
    init(count: Int) {
        self.items = [CounterItem(count: count)]
    }
}

struct CounterViewState: TempoViewState, TempoSectionedViewState {
    var currentCount = 5

    var sections: [TempoViewStateSection] {
        var sections = [TempoViewStateSection]()
        sections.append(CounterSection(count: currentCount))
        return sections
    }
}


/*:
### Components
Easy enough, but the `SectionPresenter` still needs to know how to configure the cells in a given section based on the view state.

That's where components come in. A section presenter uses its registered components to update individual cells within a given section.  Simply subclass `Component` and implement `configureView(_ view:item:)` with the corresponding generic parameter types and most of the boilerplate is handled for you.
*/
final class MyView: UIView, ReusableView {
    static let reuseID = "MyView"
    lazy var myLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        self.addAndPinSubview(label)
        return label
    }()
}

class CounterComponent: Component {
    var dispatcher: Dispatcher?

    func configureView(_ view: MyView, item: CounterItem) {
        view.myLabel.text = "Count: \(item.count)"
    }
}

/*:
 ### Multiple items
 
 If you need to configure multiple items in a given section, return multiple elements in the `items` array of `TempoViewStateSection` that represent the individual items in that section.  Then create components for each item type.
*/


struct MultipleCounterSection: TempoViewStateSection {
    let items: [TempoViewStateItem]

    init(counters: [CounterItem]) {
        self.items = counters
    }
}

struct MultipleCounterViewState: TempoViewState, TempoSectionedViewState {
    let counts = [Int]()

    var sections: [TempoViewStateSection] {
        var sections = [TempoViewStateSection]()

        let counters = counts.map { CounterItem(count: $0) }
        sections.append(MultipleCounterSection(counters: counters))
        return sections
    }
}

/*:
### Connecting it up

The first thing we need is a view controller that has a collection view. In this example we're using a plain-jane collection view controller, but any collection view will do.
Next, we just need a place to hold onto the dispatcher, your presenters, and the current view state.  A coordinator can be helpful here.
*/

class Coordinator {
    // Whenever the view state changes, tell the presenter.
    var viewState = CounterViewState() {
        didSet {
            for presenter in presenters {
                presenter.present(viewState)
            }
        }
    }

    var presenters: [TempoPresenterType] = [] {
        didSet {
            for presenter in presenters {
                presenter.present(viewState)
            }
        }
    }

    let dispatcher = Dispatcher()
}

let viewController = UICollectionViewController(collectionViewLayout: HarmonyLayout())
viewController.collectionView?.backgroundColor = UIColor.targetFadeAwayGrayColor

let coordinator = Coordinator()
let componentProvider = ComponentProvider(components: [CounterComponent()], dispatcher: coordinator.dispatcher)
let adapter = CollectionViewAdapter(collectionView: viewController.collectionView!, componentProvider: componentProvider)
let sectionPresenter = SectionPresenter(adapter: adapter)
coordinator.presenters = [sectionPresenter]

PlaygroundPage.current.liveView = viewController


/*:
### Data Flow

Data in a Tempo application flows in a single direction. In order for view state to change, create an event and send it to the dispatcher.

Define an `EventType` that describes what happened and then add an observer to the dispatcher for that type to perform the appropriate view state change.
*/
struct IncreaseButtonTapped: EventType {}

extension Coordinator {
    func addObservers() {
        dispatcher.addObserver(IncreaseButtonTapped.self) { [unowned self] _ in
            self.viewState.currentCount += 1
        }
    }
}

coordinator.addObservers()

/*:
To test it out, try uncommenting the following line to trigger an event that will update the view.
*/
//coordinator.dispatcher.triggerEvent(IncreaseButtonTapped())
/*:
### Equality

Now that we're on our way, there's one final thing to note about items and sections.  Items for the most part should always implement `Equatable`.

Your implementation of `Equatable` helps the section presenter determine whether or not a section has changed from one view state to the next.  In order to determine what to compare in your `==` function, try to think of the minimal representation of the UI state.  Other properties that are computed from the minimal state shouldn't need to be compared.
*/

func == (lhs: CounterItem, rhs: CounterItem) -> Bool {
    return lhs.count == rhs.count
}

