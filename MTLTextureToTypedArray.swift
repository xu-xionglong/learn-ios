import Metal
import JavaScriptCore

let device = MTLCreateSystemDefaultDevice()!

let captureManager = MTLCaptureManager.shared()
let captureDescriptor = MTLCaptureDescriptor()
captureDescriptor.captureObject = device
//do {
//    try captureManager.startCapture(with: captureDescriptor)
//}
//catch
//{
//    fatalError("error when trying to capture: \(error)")
//}

let commandQueue = device.makeCommandQueue()!

let texDescriptor = MTLTextureDescriptor.texture2DDescriptor(pixelFormat: .rgba8Unorm, width: 4, height: 2, mipmapped: false)
texDescriptor.usage = [MTLTextureUsage.renderTarget]

let texture = device.makeTexture(descriptor: texDescriptor)!

let renderPassDescriptor = MTLRenderPassDescriptor()
renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColorMake(1.0, 0.0, 0.0, 1.0)
let colorAttachment = (renderPassDescriptor.colorAttachments[0])!
colorAttachment.texture = texture
colorAttachment.loadAction = MTLLoadAction.clear
if let commandBuffer = commandQueue.makeCommandBuffer() {
    if let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor) {
        renderEncoder.endEncoding()
    }
    // for mac os
    if let blitEncoder = commandBuffer.makeBlitCommandEncoder() {
        blitEncoder.synchronize(texture: texture, slice: 0, level: 0)
        blitEncoder.endEncoding()
    }
    commandBuffer.commit()
    commandBuffer.waitUntilCompleted()
}
colorAttachment.loadAction = MTLLoadAction.load

let bytesPerPixel = 4
let bufferSize = bytesPerPixel * texture.width * texture.height
let stride = bytesPerPixel * texture.width

let pointer = UnsafeMutableRawPointer.allocate(byteCount: bufferSize, alignment: stride)
texture.getBytes(pointer, bytesPerRow: stride, from: MTLRegionMake2D(0, 0, texture.width, texture.height), mipmapLevel: 0)

let uint8Ptr: UnsafeMutablePointer<UInt8> = pointer.bindMemory(to: UInt8.self, capacity: bufferSize)
let uint8BufferPtr = UnsafeBufferPointer(start: uint8Ptr, count: bufferSize)
let uint8Array = Array(uint8BufferPtr)

print(uint8Array)


let jsContext = JSContext()!
func deallocator(bytes: UnsafeMutableRawPointer?, deallocatorContext: UnsafeMutableRawPointer?) -> Void {
    print("deallocator")
}
let jsArrayRef = JSObjectMakeTypedArrayWithBytesNoCopy(jsContext.jsGlobalContextRef, kJSTypedArrayTypeUint8Array, pointer, bufferSize, deallocator, pointer, nil)

let jsArray = JSValue(jsValueRef: jsArrayRef, in: jsContext)


let jsSrc = """
function getValueAt(array, index) {
    return array[index]
}
"""
jsContext.evaluateScript(jsSrc)
let getValueAt = jsContext.objectForKeyedSubscript("getValueAt")
let returnValue = getValueAt?.call(withArguments: [jsArray, 0])
let number = returnValue?.toNumber()
print(number!)

pointer.deallocate()
//captureManager.stopCapture()
sleep(100000)
