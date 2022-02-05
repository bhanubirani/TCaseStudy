//
//  Copyright © 2015 Target. All rights reserved.
//

public class ComponentProvider {
    let components: [ComponentType]
    let supplementaryComponents: [SupplementaryComponent]
    let dispatcher: Dispatcher
    
    convenience public init(components: [ComponentType], dispatcher: Dispatcher) {
        self.init(components: components, supplementaryComponents: [], dispatcher: dispatcher)
    }
    
    public init(components: [ComponentType], supplementaryComponents: [SupplementaryComponent], dispatcher: Dispatcher) {
        self.components = components
        self.supplementaryComponents = supplementaryComponents
        self.dispatcher = dispatcher
    }
    
    public func registerComponents(_ container: ReusableViewContainer) {
        for component in components {
            component.registerWrapper(container)
        }
        
        for supplementaryComponent in supplementaryComponents {
            let component = supplementaryComponent.component
            let kind = supplementaryComponent.kind
            
            component.registerWrapper(container, forSupplementaryViewOfKind: kind)
        }
    }
    
    public func componentFor(_ item: TempoViewStateItem) -> ComponentType {
        for var component in components {
            if component.canDisplayItem(item) {
                component.dispatcher = dispatcher
                return component
            }
        }
        
        fatalError("Missing component for \(item)")
    }
    
    public func supplementaryComponentFor(_ item: TempoViewStateItem) -> SupplementaryComponent {
        for var supplementaryComponent in supplementaryComponents {
            if supplementaryComponent.component.canDisplayItem(item) {
                supplementaryComponent.component.dispatcher = dispatcher
                
                return supplementaryComponent
            }
        }
        
        fatalError("Missing supplementary component for \(item)")
    }
}
