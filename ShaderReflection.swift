import Foundation
import Metal

let line = "------------------------"

extension MTLArgumentType: CustomStringConvertible {
    public var description: String {
        var str: String
        switch self {
        case .buffer:
            str = "buffer"
        case .sampler:
            str = "sampler"
        case .texture:
            str = "texture"
        case .threadgroupMemory:
            str = "threadgroupMemory"
        default:
            str = "unknow"
        }
        return str
    }
}

extension MTLArgumentAccess: CustomStringConvertible {
    public var description: String {
        var str: String
        switch self {
        case .readOnly:
            str = "readOnly"
        case .writeOnly:
            str = "writeOnly"
        case .readWrite:
            str = "readWrite"
        default:
            str = "unknow"
        }
        return str
    }
}

extension MTLDataType: CustomStringConvertible {
    public var description: String {
        var str: String
        switch self {
        case .array:
            str = "array"
        case .pointer:
            str = "pointer"
        case .texture:
            str = "texture"
        case .struct:
            str = "struct"
        case .indirectCommandBuffer:
            str = "indirectCommandBuffer"
        case .sampler:
            str = "sampler"
        case .renderPipeline:
            str = "renderPipeline"
        case .none:
            str = "none"
        default:
            str = "other"
        }
        return str
    }
}

extension MTLTextureType: CustomStringConvertible {
    public var description: String {
        var str: String
        switch self {
        case .type2D:
            str = "type2D"
        case .type1D:
            str = "type1D"
        case .type3D:
            str = "type3D"
        case .typeCube:
            str = "typeCube"
        case .typeTextureBuffer:
            str = "typeTextureBuffer"
        default:
            str = "other"
        }
        return str
    }
}

func printStruct(bufferStructType: MTLStructType, indent: String) {
    for member in bufferStructType.members {
        print("\(indent)name:\(member.name)")
    }
}

func printArgument(arg: MTLArgument) {
    print("name:\(arg.name)")
    print("index:\(arg.index)")
    print("type:\(arg.type)")
    print("access:\(arg.access)")
    print("arrayLength:\(arg.arrayLength)")
    if arg.type == .buffer {
        print("bufferAlignment:\(arg.bufferAlignment)")
        print("bufferDataSize:\(arg.bufferDataSize)")
        print("bufferDataType:\(arg.bufferDataType)")
        if let bufferStructType = arg.bufferStructType {
            printStruct(bufferStructType: bufferStructType, indent: "\t")
        }
    }
    else if arg.type == .texture {
        print("textureDataType:\(arg.textureDataType)")
        print("textureType:\(arg.textureType)")
        print("isDepthTexture:\(arg.isDepthTexture)")
    }
    else if arg.type == .sampler {
    }
    else if arg.type == .threadgroupMemory {
    }
}

func reflect() {
    let source = """
    using namespace metal;

    struct QuadVertexIn {
        float2 position;
        float2 texCoords;
    };

    struct QuadVertexOut {
        float4 position [[position]];
        float2 texCoords;
    };

    vertex QuadVertexOut vertex_post(uint vid [[vertex_id]],
                                     device const QuadVertexIn* vertices [[buffer(0)]]) {
        return QuadVertexOut {
            .position = float4(vertices[vid].position, 0, 1),
            .texCoords = vertices[vid].texCoords
        };
    }
    fragment half4 fragment_post(QuadVertexOut in [[stage_in]],
                                 texture2d<float, access::sample> texture [[texture(0)]],
                                 const device float *inFloat [[buffer(0)]],
                                 const array<texture2d<float>, 10> src [[texture(1)]]) {
        constexpr sampler sampler2d(coord::normalized, filter::linear);
        float4 const color = texture.sample(sampler2d, in.texCoords);
        return half4(half3(color.rgb), 1);
    }

    """
    
    let device = MTLCreateSystemDefaultDevice()!
    let library = try! device.makeLibrary(source: source, options: nil)
    let descriptor = MTLRenderPipelineDescriptor()
    descriptor.vertexFunction = library.makeFunction(name: "vertex_post")
    descriptor.fragmentFunction = library.makeFunction(name: "fragment_post")
    let option = MTLPipelineOption(rawValue: MTLPipelineOption.argumentInfo.rawValue | MTLPipelineOption.bufferTypeInfo.rawValue)
    var reflection: MTLRenderPipelineReflection?
    try! device.makeRenderPipelineState(descriptor: descriptor, options: option, reflection: &reflection)
    
    if let vertexArguments = reflection?.vertexArguments {
        for arg in vertexArguments {
            print(line)
            printArgument(arg: arg)
        }
    }
    if let fragmentArguments = reflection?.fragmentArguments {
        for arg in fragmentArguments {
            print(line)
            printArgument(arg: arg)
        }
    }
    
}

reflect()
