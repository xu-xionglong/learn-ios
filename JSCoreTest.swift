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

let texDescriptor = MTLTextureDescriptor.texture2DDescriptor(pixelFormat: .rgba8Unorm, width: 2, height: 2, mipmapped: false)
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

let rawPtr = UnsafeMutableRawPointer.allocate(byteCount: bufferSize, alignment: stride)
texture.getBytes(rawPtr, bytesPerRow: stride, from: MTLRegionMake2D(0, 0, texture.width, texture.height), mipmapLevel: 0)


let jsContext = JSContext()!
func deallocator(bytes: UnsafeMutableRawPointer?, deallocatorContext: UnsafeMutableRawPointer?) -> Void {
    print("deallocator")
}
let jsArrayRef = JSObjectMakeTypedArrayWithBytesNoCopy(jsContext.jsGlobalContextRef, kJSTypedArrayTypeUint8Array, rawPtr, bufferSize, deallocator, nil, nil)
let jsArray = JSValue(jsValueRef: jsArrayRef, in: jsContext)


let jsSrc = """
function getValueAt(array, index) {
    return array[index]
}
function setValueAt(array, index, value) {
    array[index] = value;
}
function createArray(t) {
    if (t == 0) {
        return new Int8Array([1,2,3,4,5,6,7,8])
    }
    else if (t == 1) {
        return [1,2,3,4,5,6,7,8]
    }
    return null
}
"""
jsContext.evaluateScript(jsSrc)
let getValueAt = jsContext.objectForKeyedSubscript("getValueAt")
let setValueAt = jsContext.objectForKeyedSubscript("setValueAt")
let createArray = jsContext.objectForKeyedSubscript("createArray")

//print(getValueAt?.call(withArguments: [jsArray, 0])?.toNumber()!)
//setValueAt?.call(withArguments: [jsArray, 0, 35])


let arr = (createArray?.call(withArguments: [0]))!

let typedArrayType: JSTypedArrayType = JSValueGetTypedArrayType(jsContext.jsGlobalContextRef, arr.jsValueRef, nil)
switch (typedArrayType) {
case kJSTypedArrayTypeInt8Array:
    print("kJSTypedArrayTypeInt8Array")
case kJSTypedArrayTypeInt16Array:
    print("kJSTypedArrayTypeInt16Array")
case kJSTypedArrayTypeInt32Array:
    print("kJSTypedArrayTypeInt32Array")
case kJSTypedArrayTypeUint8Array:
    print("kJSTypedArrayTypeUint8Array")
case kJSTypedArrayTypeUint8ClampedArray:
    print("kJSTypedArrayTypeUint8ClampedArray")
case kJSTypedArrayTypeUint16Array:
    print("kJSTypedArrayTypeUint16Array")
case kJSTypedArrayTypeUint32Array:
    print("kJSTypedArrayTypeUint32Array")
case kJSTypedArrayTypeFloat32Array:
    print("kJSTypedArrayTypeFloat32Array")
case kJSTypedArrayTypeFloat64Array:
    print("kJSTypedArrayTypeFloat64Array")
case kJSTypedArrayTypeArrayBuffer:
    print("kJSTypedArrayTypeArrayBuffer")
case kJSTypedArrayTypeNone:
    print("kJSTypedArrayTypeNone")
default:
    print("default")
}

let jsBufferPtr: UnsafeMutableRawPointer = JSObjectGetTypedArrayBytesPtr(jsContext.jsGlobalContextRef, arr.jsValueRef, nil)
let jsBufferLength = JSObjectGetTypedArrayByteLength(jsContext.jsGlobalContextRef, arr.jsValueRef, nil)



let uint8Ptr: UnsafeMutablePointer<UInt8> = jsBufferPtr.bindMemory(to: UInt8.self, capacity: jsBufferLength)
let uint8BufferPtr = UnsafeBufferPointer(start: uint8Ptr, count: jsBufferLength)
let uint8Array = Array(uint8BufferPtr)
print(uint8Array)


rawPtr.deallocate()
//captureManager.stopCapture()
sleep(100000)
