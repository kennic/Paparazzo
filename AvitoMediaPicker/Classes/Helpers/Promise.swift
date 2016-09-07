/// This implementation of Promise is stupid simple and not thread safe
struct Promise<T> {
    
    typealias Handler = (T) -> ()
    
    private var handlers = [Handler]()
    private var value: T?
    
    mutating func onFulfill(handler: Handler) {
        if let value = value {  // already fulfilled
            handler(value)
        } else {
            handlers.append(handler)
        }
    }
    
    mutating func fulfill(with value: T) {
        self.value = value
        
        if handlers.count > 0 {
            handlers.forEach { $0(value) }
            handlers.removeAll()
        }
    }
}

extension Promise where T: Void {
    mutating func fulfill() {
        fulfill(with: ())
    }
}