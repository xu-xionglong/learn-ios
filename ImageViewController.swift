import UIKit
import MetalKit

class ImageViewController: UIViewController {
    let imageButton = UIButton()
    var device: MTLDevice!
    var textureLoader: MTKTextureLoader!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        device = MTLCreateSystemDefaultDevice()
        textureLoader = MTKTextureLoader(device: device)
        
        
        view.addSubview(imageButton)
        view.backgroundColor = UIColor.gray
//        imageButton.snp.makeConstraints { (make) in
//            make.center.equalToSuperview()
//        }
        imageButton.frame.size = view.bounds.size
        imageButton.addTarget(self, action: #selector(selectImage), for: .touchUpInside)
    }
    
    @objc func selectImage(_ sender: UIButton) {
        let controller = UIImagePickerController()
        controller.sourceType = .photoLibrary
        controller.delegate = self
        present(controller, animated: false, completion: nil)
    }
}

extension ImageViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: false, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        for kv in info {
            if (kv.key == .originalImage) {
                let viewSize = imageButton.frame.size
                //On an iPhone Plus, scale is 3, but nativeScale is 2.6. This is because content is rendered at 3x (1 point = 3 pixels) but then the resulting bitmap is scaled down, resulting in 1 point = 2.6 pixels.
                //So scale deals with the intermediate bitmap, and nativeScale deals with the final bitmap.
                //let naturalSize = CGSize(width: viewSize.width * UIScreen.main.scale, height: viewSize.height * UIScreen.main.scale)
                
                
                let uiimage = kv.value as! UIImage
                
                
                var cgimage: CGImage!
 
                let reformat = false
                
                if (reformat) {
                    let width = uiimage.cgImage!.width
                    let height = uiimage.cgImage!.height
                    
//Valid parameters for RGB color space model are:
//    16  bits per pixel,         5  bits per component,         kCGImageAlphaNoneSkipFirst
//    32  bits per pixel,         8  bits per component,         kCGImageAlphaNoneSkipFirst
//    32  bits per pixel,         8  bits per component,         kCGImageAlphaNoneSkipLast
//    32  bits per pixel,         8  bits per component,         kCGImageAlphaPremultipliedFirst
//    32  bits per pixel,         8  bits per component,         kCGImageAlphaPremultipliedLast
//    32  bits per pixel,         10 bits per component,         kCGImageAlphaNone|kCGImagePixelFormatRGBCIF10
//    64  bits per pixel,         16 bits per component,         kCGImageAlphaPremultipliedLast
//    64  bits per pixel,         16 bits per component,         kCGImageAlphaNoneSkipLast
//    64  bits per pixel,         16 bits per component,         kCGImageAlphaPremultipliedLast|kCGBitmapFloatComponents|kCGImageByteOrder16Little
//    64  bits per pixel,         16 bits per component,         kCGImageAlphaNoneSkipLast|kCGBitmapFloatComponents|kCGImageByteOrder16Little
//    128 bits per pixel,         32 bits per component,         kCGImageAlphaPremultipliedLast|kCGBitmapFloatComponents
//    128 bits per pixel,         32 bits per component,         kCGImageAlphaNoneSkipLast|kCGBitmapFloatComponents
                    
//                    let bitsPerComponent = 8
//                    let bytesPerRow = 4 * width
//                    let colorSpace = CGColorSpaceCreateDeviceRGB()
//                    let bitmapInfo = CGImageAlphaInfo.noneSkipLast.rawValue
                    
                    let bitsPerComponent = 16
                    let bytesPerRow = 8 * width
                    let colorSpace = CGColorSpaceCreateDeviceRGB()
                    let bitmapInfo = CGBitmapInfo.floatComponents.rawValue | CGImageAlphaInfo.noneSkipLast.rawValue | CGBitmapInfo.byteOrder16Little.rawValue
                    
                    
                    let cgcontext = CGContext(data: nil,
                                              width: width, height: height,
                                              bitsPerComponent: bitsPerComponent,
                                              bytesPerRow: bytesPerRow,
                                              space: colorSpace,
                                              bitmapInfo: bitmapInfo,
                                              releaseCallback: nil,
                                              releaseInfo: nil)
                    cgcontext?.draw(uiimage.cgImage!, in: CGRect(x: 0, y: 0, width: width, height: height))
                    cgimage = cgcontext?.makeImage()
                }
                else {
                    cgimage = uiimage.cgImage!
                    
                    let bitmapInfo = cgimage.bitmapInfo
                    let alphaInfo = cgimage.alphaInfo
                    let colorSpace = cgimage.colorSpace
                    
                    switch colorSpace?.model {
                    case .unknown:
                        print("unknow")
                    case .monochrome:
                        print("monochrome")
                    case .rgb:
                        print("rgb")
                    case .cmyk:
                        print("cmyk")
                    case .lab:
                        print("lab")
                    case .deviceN:
                        print("deviceN")
                    case .indexed:
                        print("indexed")
                    case .pattern:
                        print("pattern")
                    case .XYZ:
                        print("XYZ")
                    default:
                        print("default")
                    }
                    
                    print(CGBitmapInfo.alphaInfoMask.rawValue) //31，所有alphaInfo（1～7）的位集合
                    print(CGBitmapInfo.floatInfoMask.rawValue) //3840 -> 111100000000 -> 256, 512, 1024, 2056
                    print(CGBitmapInfo.floatComponents.rawValue) //256
                    
                    if ((bitmapInfo.rawValue & CGBitmapInfo.alphaInfoMask.rawValue) != 0) {
                        print("alphaInfoMask")
                    }
                    if ((bitmapInfo.rawValue & CGBitmapInfo.floatComponents.rawValue) != 0) {
                        print("floatComponents")
                    }
                    if ((bitmapInfo.rawValue & CGBitmapInfo.byteOrderMask.rawValue) != 0) {
                        print("byteOrderMask")
                    }
                    if ((bitmapInfo.rawValue & CGBitmapInfo.byteOrder16Little.rawValue) != 0) {
                        print("byteOrder16Little")
                    }
                    if ((bitmapInfo.rawValue & CGBitmapInfo.byteOrder32Little.rawValue) != 0) {
                        print("byteOrder32Little")
                    }
                    if ((bitmapInfo.rawValue & CGBitmapInfo.byteOrder16Big.rawValue) != 0) {
                        print("byteOrder16Big")
                    }
                    if ((bitmapInfo.rawValue & CGBitmapInfo.byteOrder32Big.rawValue) != 0) {
                        print("byteOrder32Big")
                    }
                    if ((bitmapInfo.rawValue & CGBitmapInfo.floatInfoMask.rawValue) != 0) {
                        print("floatInfoMask")
                    }
                    
                    switch alphaInfo {
                    case .first:
                        print("first")
                    case .last:
                        print("last")
                    case .none:
                        print("none")
                    case .noneSkipFirst:
                        print("noneSkipFirst")
                    case .alphaOnly:
                        print("alphaOnly")
                    case .noneSkipLast:
                        print("noneSkipLast")
                    case .premultipliedFirst:
                        print("premultipliedFirst")
                    case .premultipliedLast:
                        print("premultipliedLast")
                    }
                    print("bitsPerPixel:\(cgimage.bitsPerPixel)")
                    print("bytesPerRow:\(cgimage.bytesPerRow)")
                    print("bitsPerComponent:\(cgimage.bitsPerComponent)")
                }

                
                do {
                    let texture = try textureLoader.newTexture(cgImage: cgimage, options: nil)
                    print("pixelFormat:\(texture.pixelFormat.rawValue)")
                } catch (let error) {
                    print(error.localizedDescription)
                }
                
                
                
//                switch texture.pixelFormat {
//                case .a8Unorm:
//                    print("a8Unorm")
//                case .r16Float:
//                    print("r16Float")
//                case .r16Uint:
//                    print("r16Uint")
//                case .r16Sint:
//                    print("r16Sint")
//                case .r16Snorm:
//                    print("r16Snorm")
//                case .rgba8Uint:
//                    print("rgba8Uint")
//                case .rgba8Sint:
//                    print("rgba8Sint")
//                case .rgba8Unorm:
//                    print("rgba8Unorm")
//                case .rgba8Snorm
//                    print("rgba8Snorm")
//                case .rgba1
//                default:
//                    print("default")
//                }
                
                imageButton.setImage(uiimage, for: .normal)
                imageButton.sizeToFit()
            }
        }
        picker.dismiss(animated: false, completion: nil)
    }
}
