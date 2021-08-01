import Foundation

class RunLoopThread {
    var runLoop: CFRunLoop! = nil
    let conditionLock = NSConditionLock(condition: 0)
    
    var thread: Thread! = nil
    let source: CFRunLoopSource
    init() {
        var sourceContext = CFRunLoopSourceContext()
        source = CFRunLoopSourceCreate(nil, 0, &sourceContext)
    }
    
    deinit {
        stop()
    }
    
    func start() {
        thread = Thread() {
            self.runLoop = CFRunLoopGetCurrent()
            self.conditionLock.lock()
            self.conditionLock.unlock(withCondition: 1)
            
            CFRunLoopAddSource(self.runLoop, self.source, CFRunLoopMode.defaultMode)
            CFRunLoopRun()
            CFRunLoopRemoveSource(self.runLoop, self.source, CFRunLoopMode.defaultMode)
        }
        
        thread.start()
        conditionLock.lock(whenCondition: 1)
        conditionLock.unlock()
    }
    
    func stop() {
        if thread != nil {
            sync {
                CFRunLoopStop(self.runLoop)
            }
        }
    }
    
    func awake() {
        if CFRunLoopIsWaiting(runLoop) {
            CFRunLoopSourceSignal(source)
            CFRunLoopWakeUp(runLoop)
        }
    }
    
    func async(block: @escaping () -> Void) {
        CFRunLoopPerformBlock(runLoop, CFRunLoopMode.defaultMode.rawValue, block)
        awake()
    }
    
    func sync(block: @escaping () -> Void) {
        if (CFEqual(CFRunLoopGetCurrent(), runLoop)) {
            block()
            return
        }
        let lock = NSConditionLock(condition: 0)
        CFRunLoopPerformBlock(runLoop, CFRunLoopMode.defaultMode.rawValue) {
            lock.lock()
            block()
            lock.unlock(withCondition: 1)
        }
        awake()
        lock.lock(whenCondition: 1)
        lock.unlock()
    }
    
    func addObserver(activities: CFOptionFlags, repeats: Bool, order: CFIndex, block: ((CFRunLoopObserver?, CFRunLoopActivity) -> Void)!) {
        
        let observer = CFRunLoopObserverCreateWithHandler(nil, activities, repeats, order, block)
        CFRunLoopAddObserver(runLoop, observer, CFRunLoopMode.defaultMode)
    }
}
