
const std = @import("std");


pub const Vector2 = extern struct {
  x: f32 = 0,
  y: f32 = 0,
};

pub const Vector3 = extern struct {
  x: f32, y: f32, z: f32
};

pub const Vector4 = extern struct {
  x: f32, y: f32, z: f32, w: f32
};

pub const Quaternion = Vector4;

pub const Matrix = extern struct {
  m0: f32, m4: f32, m8: f32, m12: f32,
  m1: f32, m5: f32, m9: f32, m13: f32,
  m2: f32, m6: f32, m10: f32, m14: f32,
  m3: f32, m7: f32, m11: f32, m15: f32,
};

pub const Color = extern struct {
  pub const lightgray = init(200, 200, 200, 255);
  pub const gray = init(130, 103, 130, 255);
  pub const darkgray = init(80, 80, 80, 255);
  pub const yellow = init(256, 249, 0, 255);
  pub const gold = init(255, 203, 0, 255);
  pub const orange = init(255, 161, 0, 255);
  pub const pink = init(255, 109, 194, 255);
  pub const red = init(230, 41, 55, 255);
  pub const maroon = init(190, 33, 55, 255);
  pub const green = init(0, 228, 48, 255);
  pub const lime = init(0, 158, 47, 255);
  pub const darkgreen = init(0, 117, 44, 255);
  pub const skyblue = init(102, 191, 255, 255);
  pub const blue = init(0, 121, 241, 255);
  pub const darkblue = init(0, 82, 172, 255);
  pub const purple = init(200, 122, 255, 255);
  pub const violet = init(135, 60, 190, 255);
  pub const darkpurple = init(112, 31, 126, 255);
  pub const beige = init(211, 176, 131, 255);
  pub const brown = init(127, 106, 79, 255);
  pub const darkbrown = init(76, 63, 47, 255);
  pub const white = init(255, 255, 255, 255);
  pub const black = init(0, 0, 0, 255);
  pub const blank = init(0, 0, 0, 0);
  pub const magenta = init(255, 0, 255, 255);
  pub const raywhite = init(245, 245, 245, 255);


  r: u8, g: u8, b: u8, a: u8,

  pub fn init(r: u8, g: u8, b: u8, a: u8) Color {
    return .{ .r = r, .g = g, .b = b, .a = a };
  }

  pub const fade = Fade;
  pub const toInt = ColorToInt;
  pub const normalize = ColorNormalize;
  pub const fromNormalized = ColorFromNormalized;
  pub const toHSV = ColorToHSV;
  pub const fromHSV = ColorFromHSV;
  pub const alpha = ColorAlpha;
  pub const alphaBlend = ColorAlphaBlend;
  pub const fromInt = GetColor;

  extern fn Fade(color: Color, alpha: f32) Color;
  extern fn ColorToInt(color: Color) i32;
  extern fn ColorNormalize(color: Color) Vector4;
  extern fn ColorFromNormalized(normalized: Vector4) Color;
  extern fn ColorToHSV(color: Color) Vector3;
  extern fn ColorFromHSV(hue: f32, saturation: f32, value: f32) Color;
  extern fn ColorAlpha(color: Color, alpha: f32) Color;
  extern fn ColorAlphaBlend(dst: Color, src: Color, tint: Color) Color;
  extern fn GetColor(hexValue: u32) Color;
};

pub const Rectangle = extern struct {
  x: f32, y: f32,
  width: f32, height: f32,
};

pub const Image = extern struct {
  data: ?*anyopaque,
  width: i32, height: i32,
  mipmaps: i32, format: i32,



  pub fn zigLoad(
    alloc: std.mem.Allocator,
    path: []const u8
  ) !Image {
    var file = try std.fs.cwd().openFile(path, .{});
    defer file.close();

    var size = @intCast(usize, (try file.stat()).size);
    var buf = try alloc.alloc(u8, size);
    defer alloc.free(buf);

    _ = try file.readAll(buf);

    var filetype = try alloc.dupeZ(u8, std.fs.path.extension(path));
    defer alloc.free(filetype);

    return loadFromMemory(filetype, buf.ptr, @intCast(i32, size));
  }

  pub const load = LoadImage;
  pub const loadRaw = LoadImageRaw;
  pub const loadAnim = LoadImageAnim;
  pub const loadFromMemory = LoadImageFromMemory;
  pub const loadFromTexture = LoadImageFromTexture;
  pub const loadFromScreen = LoadImageFromScreen;
  pub const unload = UnloadImage;
  pub const exportImage = ExportImage;
  pub const exportAsCode = ExportImageAsCode;
  pub const genColor = GenImageColor;
  pub const genGradientV = GenImageGradientV;
  pub const getGradientH = GenImageGradientH;
  pub const genGradientRadial = GenImageGradientRadial;
  pub const genChecked = GenImageChecked;
  pub const genWhiteNoise = GenImageWhiteNoise;
  pub const genCellular = GenImageCellular;
  pub const copy = ImageCopy;
  pub const fromImage = ImageFromImage;
  pub const text = ImageText;
  pub const textEx = ImageTextEx;
  pub const format = ImageFormat;
  pub const toPOT = ImageToPOT;
  pub const crop = ImageCrop;
  pub const alphaCrop = ImageAlphaCrop;
  pub const alphaClear = ImageAlphaClear;
  pub const alphaMask = ImageAlphaMask;
  pub const alphaPremultipy = ImageAlphaPremultiply;
  pub const resize = ImageResize;
  pub const resizeNN = ImageResizeNN;
  pub const resizeCanvas = ImageResizeCanvas;
  pub const mipmaps = ImageMipmaps;
  pub const dither = ImageDither;
  pub const flipVertical = ImageFlipVertical;
  pub const flipHorizontal = ImageFlipHorizontal;
  pub const rotateCW = ImageRotateCW;
  pub const rotateCCW = ImageRotateCCW;
  pub const colorTint = ImageColorTint;
  pub const colorInvert = ImageColorInvert;
  pub const colorGrayscale = ImageColorGrayscale;
  pub const colorContrast = ImageColorContrast;
  pub const colorBrightness = ImageColorBrightness;
  pub const colorReplace = ImageColorReplace;
  pub const loadColors = LoadImageColors;
  pub const loadPalette = LoadImagePalette;
  pub const unloadColors = UnloadImageColors;
  pub const unloadPalette = UnloadImagePalette;
  pub const getAlphaBorder = GetImageAlphaBorder;
  pub const getColor = GetImageColor;
  pub const clearBackground = ImageClearBackground;
  pub const drawPixel = ImageDrawPixel;
  pub const drawPixelV = ImageDrawPixelV;
  pub const drawLine = ImageDrawLine;
  pub const drawLineV = ImageDrawLineV;
  pub const drawCircle = ImageDrawCircle;
  pub const drawCircleV = ImageDrawCircleV;
  pub const drawRectangle = ImageDrawRectangle;
  pub const drawRectangleV = ImageDrawRectangleV;
  pub const drawRectangleRec = ImageDrawRectangleRec;
  pub const drawRectangleLines = ImageDrawRectangleLines;
  pub const draw = ImageDraw;
  pub const drawText = ImageDrawText;
  pub const drawTextEx = ImageDrawTextEx;


  extern fn LoadImage(fileName: [*:0]const u8) Image;
  extern fn LoadImageRaw(fileName: [*:0]const u8, width: i32, height: i32, format: i32, headerSize: i32) Image;
  extern fn LoadImageAnim(fileName: [*:0]const u8, frames: [*]i32) Image;
  extern fn LoadImageFromMemory(fileType: [*:0]const u8, fileData: [*]const u8, dataSize: i32) Image;
  extern fn LoadImageFromTexture(texture: Texture2D) Image;
  extern fn LoadImageFromScreen() Image;
  extern fn UnloadImage(image: Image) void;
  extern fn ExportImage(image: Image, fileName: [*:0]const u8) bool;
  extern fn ExportImageAsCode(image: Image, fileName: [*:0]const u8) bool;
  extern fn GenImageColor(width: i32, height: i32, color: Color) Image;
  extern fn GenImageGradientV(width: i32, height: i32, top: Color, bottom: Color) Image;
  extern fn GenImageGradientH(width: i32, height: i32, left: Color, right: Color) Image;
  extern fn GenImageGradientRadial(width: i32, height: i32, density: f32, inner: Color, outer: Color) Image;
  extern fn GenImageChecked(width: i32, height: i32, checksX: i32, checksY: i32, col1: Color, col2: Color) Image;
  extern fn GenImageWhiteNoise(width: i32, height: i32, factor: f32) Image;
  extern fn GenImageCellular(width: i32, height: i32, tileSize: i32) Image;
  extern fn ImageCopy(image: Image) Image;
  extern fn ImageFromImage(image: Image, rec: Rectangle) Image;
  extern fn ImageText(text: [*:0]const u8, fontSize: i32, color: Color) Image;
  extern fn ImageTextEx(font: Font, text: [*:0]const u8, fontSize: f32, spacing: f32, tint: Color) Image;
  extern fn ImageFormat(image: *Image, newFormat: i32) void;
  extern fn ImageToPOT(image: *Image, fill: Color) void;
  extern fn ImageCrop(image: *Image, crop: Rectangle) void;
  extern fn ImageAlphaCrop(image: *Image, threshold: f32) void;
  extern fn ImageAlphaClear(image: *Image, color: Color, threshold: f32) void;
  extern fn ImageAlphaMask(image: *Image, alphaMask: Image) void;
  extern fn ImageAlphaPremultiply(image: *Image) void;
  extern fn ImageResize(image: *Image, newWidth: i32, newHeight: i32) void;
  extern fn ImageResizeNN(image: *Image, newWidth: i32, newHeight: i32) void;
  extern fn ImageResizeCanvas(image: *Image, newWidth: i32, newHeight: i32, offsetX: i32, offsetY: i32, fill: Color) void;
  extern fn ImageMipmaps(image: *Image) void;
  extern fn ImageDither(image: *Image, rBpp: i32, gBpp: i32, bBpp: i32, aBpp: i32) void;
  extern fn ImageFlipVertical(image: *Image) void;
  extern fn ImageFlipHorizontal(image: *Image) void;
  extern fn ImageRotateCW(image: *Image) void;
  extern fn ImageRotateCCW(image: *Image) void;
  extern fn ImageColorTint(image: *Image, color: Color) void;
  extern fn ImageColorInvert(image: *Image) void;
  extern fn ImageColorGrayscale(image: *Image) void;
  extern fn ImageColorContrast(image: *Image, contrast: f32) void;
  extern fn ImageColorBrightness(image: *Image, brightness: i32) void;
  extern fn ImageColorReplace(image: *Image, color: Color, replace: Color) void;
  extern fn LoadImageColors(image: Image) [*]Color;
  extern fn LoadImagePalette(image: Image, maxPaletteSize: i32, colorCount: [*]i32) [*]Color;
  extern fn UnloadImageColors(colors: [*]Color) void;
  extern fn UnloadImagePalette(colors: [*]Color) void;
  extern fn GetImageAlphaBorder(image: Image, threshold: f32) Rectangle;
  extern fn GetImageColor(image: Image, x: i32, y: i32) Color;
  extern fn ImageClearBackground(dst: *Image, color: Color) void;
  extern fn ImageDrawPixel(dst: *Image, posX: i32, posY: i32, color: Color) void;
  extern fn ImageDrawPixelV(dst: *Image, position: Vector2, color: Color) void;
  extern fn ImageDrawLine(dst: *Image, startPosX: i32, startPosY: i32, endPosX: i32, endPosY: i32, color: Color) void;
  extern fn ImageDrawLineV(dst: *Image, start: Vector2, end: Vector2, color: Color) void;
  extern fn ImageDrawCircle(dst: *Image, centerX: i32, centerY: i32, radius: i32, color: Color) void;
  extern fn ImageDrawCircleV(dst: *Image, center: Vector2, radius: i32, color: Color) void;
  extern fn ImageDrawRectangle(dst: *Image, posX: i32, posY: i32, width: i32, height: i32, color: Color) void;
  extern fn ImageDrawRectangleV(dst: *Image, position: Vector2, size: Vector2, color: Color) void;
  extern fn ImageDrawRectangleRec(dst: *Image, rec: Rectangle, color: Color) void;
  extern fn ImageDrawRectangleLines(dst: *Image, rec: Rectangle, thick: i32, color: Color) void;
  extern fn ImageDraw(dst: *Image, src: Image, srcRec: Rectangle, dstRec: Rectangle, tint: Color) void;
  extern fn ImageDrawText(dst: *Image, text: [*:0]const u8, posX: i32, posY: i32, fontSize: i32, color: Color) void;
  extern fn ImageDrawTextEx(dst: *Image, font: Font, text: [*:0]const u8, position: Vector2, fontSize: f32, spacing: f32, tint: Color) void;
};

pub const Texture = extern struct {
  id: u32,
  width: i32, height: i32,
  mipmaps: i32, format: i32,

  pub fn zigLoad(
    alloc: std.mem.Allocator,
    path: []const u8
  ) !Texture {
    var img = try Image.zigLoad(alloc, path);
    defer img.unload();

    return loadFromImage(img);
  }

  pub const setShapesTexture = SetShapesTexture;
  pub const load = LoadTexture;
  pub const loadFromImage = LoadTextureFromImage;
  pub const loadCubemap = LoadTextureCubemap;
  pub const unload = UnloadTexture;
  pub const update = UpdateTexture;
  pub const updateRec = UpdateTextureRec;
  pub const genMipmaps = GenTextureMipmaps;
  pub const setFilter = SetTextureFilter;
  pub const setWrap = SetTextureWrap;

  extern fn SetShapesTexture(Texture, Rectangle) void;
  extern fn LoadTexture(fileName: [*:0]const u8) Texture2D;
  extern fn LoadTextureFromImage(image: Image) Texture2D;
  extern fn LoadTextureCubemap(image: Image, layout: i32) TextureCubemap;
  extern fn UnloadTexture(texture: Texture2D) void;
  extern fn UpdateTexture(texture: Texture2D, pixels: ?*const anyopaque) void;
  extern fn UpdateTextureRec(texture: Texture2D, rec: Rectangle, pixels: ?*const anyopaque) void;
  extern fn GenTextureMipmaps(texture: *Texture2D) void;
  extern fn SetTextureFilter(texture: Texture2D, filter: TextureFilter) void;
  extern fn SetTextureWrap(texture: Texture2D, wrap: TextureWrap) void;
};

pub const Texture2D = Texture;
pub const TextureCubemap = Texture;

pub const RenderTexture = extern struct {
  id: u32,
  texture: Texture,
  depth: Texture,

  pub const load = LoadRenderTexture;
  pub const unload = UnloadRenderTexture;

  extern fn LoadRenderTexture(width: i32, height: i32) RenderTexture;
  extern fn UnloadRenderTexture(target: RenderTexture) void;
};

pub const RenderTexture2D = RenderTexture;

pub const NPatchInfo = extern struct {
  source: Rectangle,
  left: i32, top: i32,
  right: i32, bottom: i32,
  layout: i32
};

pub const GlyphInfo = extern struct {
  value: i32,
  offset_x: i32,
  offset_y: i32,
  advance_x: i32,
  image: Image
};

pub const Font = extern struct {
  base_size: i32,
  glyph_count: i32,
  glyph_padding: i32,
  texture: Texture2D,
  recs: [*]Rectangle,
  glyphs: [*]GlyphInfo,

  pub const getDefault = GetFontDefault;
  pub const load = LoadFont;
  pub const loadEx = LoadFontEx;
  pub const loadFromImage = LoadFontFromImage;
  pub const loadFromMemory = LoadFontFromMemory;
  pub const loadData = LoadFontData;
  pub const genImageAtlas = GenImageFontAtlas;
  pub const unloadData = UnloadFontData;
  pub const unload = UnloadFont;
  pub const exportAsCode = ExportFontAsCode;
  pub const measure = MeasureText;
  pub const measureEx = MeasureTextEx;
  pub const getGlyphIndex = GetGlyphIndex;
  pub const getGlyphInfo = GetGlyphInfo;
  pub const getGlyphAtlasRec = GetGlyphAtlasRec;

  extern fn GetFontDefault() Font;
  extern fn LoadFont(fileName: [*:0]const u8) Font;
  extern fn LoadFontEx(fileName: [*:0]const u8, fontSize: i32, fontChars: [*]i32, glyphCount: i32) Font;
  extern fn LoadFontFromImage(image: Image, key: Color, firstChar: i32) Font;
  extern fn LoadFontFromMemory(fileType: [*:0]const u8, fileData: [*]const u8, dataSize: i32, fontSize: i32, fontChars: [*]i32, glyphCount: i32) Font;
  extern fn LoadFontData(fileData: [*]const u8, dataSize: i32, fontSize: i32, fontChars: [*]i32, glyphCount: i32, @"type": i32) [*]GlyphInfo;
  extern fn GenImageFontAtlas(chars: [*]const GlyphInfo, recs: [*]*Rectangle, glyphCount: i32, fontSize: i32, padding: i32, packMethod: i32) Image;
  extern fn UnloadFontData(chars: [*]GlyphInfo, glyphCount: i32) void;
  extern fn UnloadFont(font: Font) void;
  extern fn ExportFontAsCode(font: Font, fileName: [*:0]const u8) bool;
  extern fn MeasureText(text: [*:0]const u8, fontSize: i32) i32;
  extern fn MeasureTextEx(font: Font, text: [*:0]const u8, fontSize: f32, spacing: f32) Vector2;
  extern fn GetGlyphIndex(font: Font, codepoint: i32) i32;
  extern fn GetGlyphInfo(font: Font, codepoint: i32) GlyphInfo;
  extern fn GetGlyphAtlasRec(font: Font, codepoint: i32) Rectangle;
};

pub const Camera3D = extern struct {
  position: Vector3,
  target: Vector3,
  up: Vector3,
  fovy: f32,
  projection: CameraProjection,


  pub fn getMouseRay(
    self: Camera3D,
    mouse: Vector2
  ) callconv(.Inline) Ray {
    return GetMouseRay(mouse, self);
  }

  pub fn worldToScreen(
    self: Camera3D,
    pos: Vector3
  ) callconv(.Inline) Vector2 {
    return GetWorldToScreen(pos, self);
  }

  pub fn worldToScreenExe(
    self: Camera3D,
    pos: Vector3,
    w: i32, h: i32
  ) callconv(.Inline) Vector2 {
    return GetWorldToScreenEx(pos, self, w, h);
  }

  pub const getMatrix = GetCameraMatrix;
  pub const setMode = SetCameraMode;
  pub const update = UpdateCamera;
  pub const setPanControl = SetCameraPanControl;
  pub const setAltControl = SetCameraAltControl;
  pub const setSmoothZoomControl = SetCameraSmoothZoomControl;
  pub const setMoveControls = SetCameraMoveControls;

  extern fn GetMouseRay(Vector2, Camera) Ray;
  extern fn GetCameraMatrix(Camera) Matrix;
  extern fn GetWorldToScreen(position: Vector3, camera: Camera) Vector2;
  extern fn GetWorldToScreenEx(position: Vector3, camera: Camera, width: i32, height: i32) Vector2;
  extern fn SetCameraMode(camera: Camera, mode: CameraMode) void;
  extern fn UpdateCamera(camera: *Camera) void;
  extern fn SetCameraPanControl(keyPan: Key) void;
  extern fn SetCameraAltControl(keyAlt: Key) void;
  extern fn SetCameraSmoothZoomControl(keySmoothZoom: Key) void;
  extern fn SetCameraMoveControls(keyFront: Key, keyBack: Key, keyRight: Key, keyLeft: Key, keyUp: Key, keyDown: Key) void;
};

pub const Camera = Camera3D;

pub const Camera2D = extern struct {
  offset: Vector2,
  target: Vector2,
  rotation: f32,
  zoom: f32,


  pub fn screenToWorld(
    self: Camera2D,
    pos: Vector2
  ) callconv(.Inline) Vector2 {
    return GetScreenToWorld2D(pos, self);
  }

  pub fn worldToScreen(
    self: Camera2D,
    pos: Vector2
  ) callconv(.Inline) Vector2 {
    return GetWorldToScreen2D(pos, self);
  }

  pub const getMatrix = GetCameraMatrix2D;

  extern fn GetCameraMatrix2D(Camera2D) Matrix;
  extern fn GetScreenToWorld2D(position: Vector2, camera: Camera2D) Vector2;
  extern fn GetWorldToScreen2D(position: Vector2, camera: Camera2D) Vector2;
};

pub const Mesh = extern struct {
  vertex_count: i32,
  triangle_count: i32,
  vertices: [*]f32,
  texcooords: [*]f32,
  texcoords2: [*]f32,
  normals: [*]f32,
  tangents: [*]f32,
  colors: [*]f32,
  indices: [*]u16,
  anim_vertices: [*]f32,
  anim_normals: [*]f32,
  bone_ids: [*]u8,
  bone_weights: [*]f32,
  vao_id: u32,
  vbo_id: [*]u32,

  pub const upload = UploadMesh;
  pub const updateBuffer = UpdateMeshBuffer;
  pub const unload = UnloadMesh;
  pub const exportMesh = ExportMesh;
  pub const getBoundingBox = GetMeshBoundingBox;
  pub const genTangents = GenMeshTangents;
  pub const genBinormals = GenMeshBinormals;
  pub const genPoly = GenMeshPoly;
  pub const genPlane = GenMeshPlane;
  pub const genCube = GenMeshCube;
  pub const genSphere = GenMeshSphere;
  pub const genHemiSphere = GenMeshHemiSphere;
  pub const genCylinder = GenMeshCylinder;
  pub const genCone = GenMeshCone;
  pub const genTorus = GenMeshTorus;
  pub const genKnot = GenMeshKnot;
  pub const genHeightmap = GenMeshHeightmap;
  pub const genCubicmap = GenMeshCubicmap;

  extern fn UploadMesh(mesh: *Mesh, dynamic: bool) void;
  extern fn UpdateMeshBuffer(mesh: Mesh, index: i32, data: ?*const anyopaque, dataSize: i32, offset: i32) void;
  extern fn UnloadMesh(mesh: Mesh) void;
  extern fn ExportMesh(mesh: Mesh, fileName: [*:0]const u8) bool;
  extern fn GetMeshBoundingBox(mesh: Mesh) BoundingBox;
  extern fn GenMeshTangents(mesh: *Mesh) void;
  extern fn GenMeshBinormals(mesh: *Mesh) void;
  extern fn GenMeshPoly(sides: i32, radius: f32) Mesh;
  extern fn GenMeshPlane(width: f32, length: f32, resX: i32, resZ: i32) Mesh;
  extern fn GenMeshCube(width: f32, height: f32, length: f32) Mesh;
  extern fn GenMeshSphere(radius: f32, rings: i32, slices: i32) Mesh;
  extern fn GenMeshHemiSphere(radius: f32, rings: i32, slices: i32) Mesh;
  extern fn GenMeshCylinder(radius: f32, height: f32, slices: i32) Mesh;
  extern fn GenMeshCone(radius: f32, height: f32, slices: i32) Mesh;
  extern fn GenMeshTorus(radius: f32, size: f32, radSeg: i32, sides: i32) Mesh;
  extern fn GenMeshKnot(radius: f32, size: f32, radSeg: i32, sides: i32) Mesh;
  extern fn GenMeshHeightmap(heightmap: Image, size: Vector3) Mesh;
  extern fn GenMeshCubicmap(cubicmap: Image, cubeSize: Vector3) Mesh;
};

pub const Shader = extern struct {
  id: u32,
  locs: [*]i32,

  pub const load = LoadShader;
  pub const loadMemory = LoadShaderFromMemory;
  pub const getLocation = GetShaderLocation;
  pub const getLocationAttrib = GetShaderLocationAttrib;
  pub const setValue = SetShaderValue;
  pub const setValueV = SetShaderValueV;
  pub const setMatrix = SetShaderValueMatrix;
  pub const setTexture = SetShaderValueTexture;
  pub const unload = UnloadShader;

  extern fn LoadShader(vsFileName: [*:0]const u8, fsFileName: [*:0]const u8) Shader;
  extern fn LoadShaderFromMemory(vsCode: [*:0]const u8, fsCode: [*:0]const u8) Shader;
  extern fn GetShaderLocation(shader: Shader, uniformName: [*:0]const u8) i32;
  extern fn GetShaderLocationAttrib(shader: Shader, attribName: [*:0]const u8) i32;
  extern fn SetShaderValue(shader: Shader, locIndex: i32, value: ?*const anyopaque, uniformType: i32) void;
  extern fn SetShaderValueV(shader: Shader, locIndex: i32, value: ?*const anyopaque, uniformType: i32, count: i32) void;
  extern fn SetShaderValueMatrix(shader: Shader, locIndex: i32, mat: Matrix) void;
  extern fn SetShaderValueTexture(shader: Shader, locIndex: i32, texture: Texture2D) void;
  extern fn UnloadShader(shader: Shader) void;
};

pub const MaterialMap = extern struct {
  texture: Texture2D,
  color: Color,
  value: f32
};

pub const Material = extern struct {
  shader: Shader,
  maps: [*]MaterialMap,
  params: [4]f32,

  pub const load = LoadMaterials;
  pub const loadDefault = LoadMaterialDefault;
  pub const unload = UnloadMaterial;
  pub const setTexture = SetMaterialTexture;

  extern fn LoadMaterials(fileName: [*:0]const u8, materialCount: *i32) [*]Material;
  extern fn LoadMaterialDefault() Material;
  extern fn UnloadMaterial(material: Material) void;
  extern fn SetMaterialTexture(material: *Material, mapType: MaterialMap, texture: Texture2D) void;
};

pub const Transform = extern struct {
  translation: Vector3,
  rotation: Quaternion,
  scale: Vector3
};

pub const BoneInfo = extern struct {
  name: [32]u8,
  parent: i32
};

pub const Model = extern struct {
  transform: Matrix,
  mesh_count: i32,
  material_count: i32,
  meshes: [*]Mesh,
  materials: [*]Material,
  mesh_material: [*]i32,
  bone_count: i32,
  bones: [*]BoneInfo,
  bind_pose: [*]Transform,

  pub const load = LoadModel;
  pub const loadFromMesh = LoadModelFromMesh;
  pub const unload = UnloadModel;
  pub const unloadKeepMeshes = UnloadModelKeepMeshes;
  pub const getBoundingBox = GetModelBoundingBox;
  pub const setMeshMaterial = SetModelMeshMaterial;
  pub const updateAnimation = UpdateModelAnimation;
  pub const isAnimationValid = IsModelAnimationValid;

  extern fn LoadModel(fileName: [*c]const u8) Model;
  extern fn LoadModelFromMesh(mesh: Mesh) Model;
  extern fn UnloadModel(model: Model) void;
  extern fn UnloadModelKeepMeshes(model: Model) void;
  extern fn GetModelBoundingBox(model: Model) BoundingBox;
  extern fn SetModelMeshMaterial(model: *Model, meshId: i32, materialId: i32) void;
  extern fn UpdateModelAnimation(model: Model, anim: ModelAnimation, frame: i32) void;
  extern fn IsModelAnimationValid(model: Model, anim: ModelAnimation) bool;
};

pub const ModelAnimation = extern struct {
  bone_count: i32,
  frame_count: i32,
  bones: [*]BoneInfo,
  frame_poses: [*][*]Transform,

  pub const load = LoadModelAnimations;
  pub const unload = UnloadModelAnimation;
  pub const unloadS = UnloadModelAnimations;

  extern fn LoadModelAnimations(fileName: [*:0]const u8, animCount: *u32) [*]ModelAnimation;
  extern fn UnloadModelAnimation(anim: ModelAnimation) void;
  extern fn UnloadModelAnimations(animations: [*]ModelAnimation, count: u32) void;
};

pub const Ray = extern struct {
  position: Vector3,
  direction: Vector3,
};

pub const RayCollision = extern struct {
  hit: bool,
  distance: f32,
  point: Vector3,
  normal: Vector3,

  pub const getSphere = GetRayCollisionSphere;
  pub const getBox = GetRayCollisionBox;
  pub const getMesh = GetRayCollisionMesh;
  pub const getTriangle = GetRayCollisionTriangle;
  pub const getQuand = GetRayCollisionQuad;

  extern fn GetRayCollisionSphere(ray: Ray, center: Vector3, radius: f32) RayCollision;
  extern fn GetRayCollisionBox(ray: Ray, box: BoundingBox) RayCollision;
  extern fn GetRayCollisionMesh(ray: Ray, mesh: Mesh, transform: Matrix) RayCollision;
  extern fn GetRayCollisionTriangle(ray: Ray, p1: Vector3, p2: Vector3, p3: Vector3) RayCollision;
  extern fn GetRayCollisionQuad(ray: Ray, p1: Vector3, p2: Vector3, p3: Vector3, p4: Vector3) RayCollision;
};

pub const BoundingBox = extern struct {
  min: Vector3,
  max: Vector3,
};

pub const Wave = extern struct {
  frame_count: u32,
  sample_rate: u32,
  sample_size: u32,
  channels: u32,
  data: ?*anyopaque,

  pub const load = LoadWave;
  pub const loadFromMemory = LoadWaveFromMemory;
  pub const unload = UnloadWave;
  pub const exportWave = ExportWave;
  pub const exportAsCode = ExportWaveAsCode;
  pub const copy = WaveCopy;
  pub const crop = WaveCrop;
  pub const format = WaveFormat;
  pub const loadSamples = LoadWaveSamples;
  pub const unloadSamples = UnloadWaveSamples;

  extern fn LoadWave(fileName: [*:0]const u8) Wave;
  extern fn LoadWaveFromMemory(fileType: [*:0]const u8, fileData: [*]const u8, dataSize: i32) Wave;
  extern fn UnloadWave(wave: Wave) void;
  extern fn ExportWave(wave: Wave, fileName: [*:0]const u8) bool;
  extern fn ExportWaveAsCode(wave: Wave, fileName: [*:0]const u8) bool;
  extern fn WaveCopy(wave: Wave) Wave;
  extern fn WaveCrop(wave: *Wave, initSample: i32, finalSample: i32) void;
  extern fn WaveFormat(wave: *Wave, sampleRate: i32, sampleSize: i32, channels: i32) void;
  extern fn LoadWaveSamples(wave: Wave) [*]f32;
  extern fn UnloadWaveSamples(samples: [*]f32) void;
};

pub const rAudioBuffer = opaque {};
pub const rAudioProcessor = opaque {};
pub const AudioStream = extern struct {
  buffer: ?*rAudioBuffer,
  processor: ?*rAudioProcessor,
  sample_rate: u32,
  sample_size: u32,
  channels: u32,

  pub const load = LoadAudioStream;
  pub const unload = UnloadAudioStream;
  pub const isProcessed = IsAudioStreamProcessed;
  pub const play = PlayAudioStream;
  pub const pause = PauseAudioStream;
  pub const resumeStream = ResumeAudioStream;
  pub const isPlaying = IsAudioStreamPlaying;
  pub const stop = StopAudioStream;
  pub const setVolume = SetAudioStreamVolume;
  pub const setPitch = SetAudioStreamPitch;
  pub const setPan = SetAudioStreamPan;
  pub const setBufferSizeDefault = SetAudioStreamBufferSizeDefault;
  pub const setCallback = SetAudioStreamCallback;
  pub const attachProcessor = AttachAudioStreamProcessor;
  pub const detachProcessor = DetachAudioStreamProcessor;

  extern fn LoadAudioStream(sampleRate: u32, sampleSize: u32, channels: u32) AudioStream;
  extern fn UnloadAudioStream(stream: AudioStream) void;
  extern fn UpdateAudioStream(stream: AudioStream, data: ?*const anyopaque, frameCount: i32) void;
  extern fn IsAudioStreamProcessed(stream: AudioStream) bool;
  extern fn PlayAudioStream(stream: AudioStream) void;
  extern fn PauseAudioStream(stream: AudioStream) void;
  extern fn ResumeAudioStream(stream: AudioStream) void;
  extern fn IsAudioStreamPlaying(stream: AudioStream) bool;
  extern fn StopAudioStream(stream: AudioStream) void;
  extern fn SetAudioStreamVolume(stream: AudioStream, volume: f32) void;
  extern fn SetAudioStreamPitch(stream: AudioStream, pitch: f32) void;
  extern fn SetAudioStreamPan(stream: AudioStream, pan: f32) void;
  extern fn SetAudioStreamBufferSizeDefault(size: i32) void;
  extern fn SetAudioStreamCallback(stream: AudioStream, callback: AudioCallback) void;
  extern fn AttachAudioStreamProcessor(stream: AudioStream, processor: AudioCallback) void;
  extern fn DetachAudioStreamProcessor(stream: AudioStream, processor: AudioCallback) void;
};

pub const Sound = extern struct {
  stream: AudioStream,
  frame_count: u32,

  pub const load = LoadSound;
  pub const loadFromWave = LoadSoundFromWave;
  pub const update = UpdateSound;
  pub const play = PlaySound;
  pub const stop = StopSound;
  pub const pause = PauseSound;
  pub const resumeSound = ResumeSound;
  pub const playMulti = PlaySoundMulti;
  pub const stopMulti = StopSoundMulti;
  pub const getPlaying = GetSoundsPlaying;
  pub const isPlaying = IsSoundPlaying;
  pub const setVolume = SetSoundVolume;
  pub const setPitch = SetSoundPitch;
  pub const setPan = SetSoundPan;

  extern fn LoadSound(fileName: [*:0]const u8) Sound;
  extern fn LoadSoundFromWave(wave: Wave) Sound;
  extern fn UpdateSound(sound: Sound, data: ?*const anyopaque, sampleCount: i32) void;
  extern fn UnloadSound(sound: Sound) void;
  extern fn PlaySound(sound: Sound) void;
  extern fn StopSound(sound: Sound) void;
  extern fn PauseSound(sound: Sound) void;
  extern fn ResumeSound(sound: Sound) void;
  extern fn PlaySoundMulti(sound: Sound) void;
  extern fn StopSoundMulti() void;
  extern fn GetSoundsPlaying() i32;
  extern fn IsSoundPlaying(sound: Sound) bool;
  extern fn SetSoundVolume(sound: Sound, volume: f32) void;
  extern fn SetSoundPitch(sound: Sound, pitch: f32) void;
  extern fn SetSoundPan(sound: Sound, pan: f32) void;
};

pub const Music = extern struct {
  stream: AudioStream,
  frame_count: u32,
  looping: bool,
  ctx_type: i32,
  ctx_data: ?*anyopaque,

  pub const load = LoadMusicStream;
  pub const loadFromMemory = LoadMusicStreamFromMemory;
  pub const unload = UnloadMusicStream;
  pub const play = PlayMusicStream;
  pub const isPlaying = IsMusicStreamPlaying;
  pub const update = UpdateMusicStream;
  pub const stop = StopMusicStream;
  pub const pause = PauseMusicStream;
  pub const resumeMusic = ResumeMusicStream;
  pub const seek = SeekMusicStream;
  pub const setVolume = SetMusicVolume;
  pub const setPitch = SetMusicPitch;
  pub const setPan = SetMusicPan;
  pub const getTimeLength = GetMusicTimeLength;
  pub const getTimePlayed = GetMusicTimePlayed;

  extern fn LoadMusicStream(fileName: [*c]const u8) Music;
  extern fn LoadMusicStreamFromMemory(fileType: [*c]const u8, data: [*c]const u8, dataSize: i32) Music;
  extern fn UnloadMusicStream(music: Music) void;
  extern fn PlayMusicStream(music: Music) void;
  extern fn IsMusicStreamPlaying(music: Music) bool;
  extern fn UpdateMusicStream(music: Music) void;
  extern fn StopMusicStream(music: Music) void;
  extern fn PauseMusicStream(music: Music) void;
  extern fn ResumeMusicStream(music: Music) void;
  extern fn SeekMusicStream(music: Music, position: f32) void;
  extern fn SetMusicVolume(music: Music, volume: f32) void;
  extern fn SetMusicPitch(music: Music, pitch: f32) void;
  extern fn SetMusicPan(music: Music, pan: f32) void;
  extern fn GetMusicTimeLength(music: Music) f32;
  extern fn GetMusicTimePlayed(music: Music) f32;
};

pub const VrDeviceInfo = extern struct {
  h_resolution: i32,
  v_resolution: i32,
  h_screen_size: f32,
  v_screen_size: f32,
  eye_to_screen_distance: f32,
  lens_separation_distance: f32,
  interpupillary_distance: f32,
  lens_distortion_values: [4]f32,
  chroma_ab_correction: [4]f32,

  pub const loadStereoConfig = LoadVrStereoConfig;

  extern fn LoadVrStereoConfig(VrDeviceInfo) VrStereoConfig;
};

pub const VrStereoConfig = extern struct {
  projection: [2]Matrix,
  view_offset: [2]Matrix,
  left_lens_center: [2]f32,
  right_lens_center: [2]f32,
  left_screen_center: [2]f32,
  right_screen_center: [2]f32,
  scale: [2]f32,
  scale_in: [2]f32,

  pub const unload = UnloadVrStereoConfig;

  extern fn UnloadVrStereoConfig(VrStereoConfig) void;
};

pub const FilePathList = extern struct {
  capacity: u32,
  count: u32,
  paths: [*][*:0]u8
};

pub const AudioCallback = fn(?*anyopaque, u32) callconv(.C) void;



pub const ConfigFlags = struct {
  pub const Type = u32;

  pub const vsync_hint: Type = 64;
  pub const fullscreen_mode: Type = 2;
  pub const window_resizable: Type = 4;
  pub const window_undecorated: Type = 8;
  pub const window_hidden: Type = 128;
  pub const window_minimized: Type = 512;
  pub const window_maximized: Type = 1024;
  pub const window_unfocused: Type = 2048;
  pub const window_topmost: Type = 4096;
  pub const window_always_run: Type = 256;
  pub const window_transparent: Type = 16;
  pub const window_highdpi: Type = 8192;
  pub const window_mouse_passthrough: Type = 16384;
  pub const msaa_4x_hint: Type = 32;
  pub const interlaced_hint: Type = 65536;
};

pub const Key = enum(u32) {
  none = 0,
  apostrophe = 39,
  comma = 44,
  minus = 45,
  period = 46,
  slash = 47,
  zero = 48,
  one = 49,
  two = 50,
  three = 51,
  four = 52,
  five = 53,
  six = 54,
  seven = 55,
  eight = 56,
  nine = 57,
  semicolon = 59,
  equal = 61,
  a = 65,
  b = 66,
  c = 67,
  d = 68,
  e = 69,
  f = 70,
  g = 71,
  h = 72,
  i = 73,
  j = 74,
  k = 75,
  l = 76,
  m = 77,
  n = 78,
  o = 79,
  p = 80,
  q = 81,
  r = 82,
  s = 83,
  t = 84,
  u = 85,
  v = 86,
  w = 87,
  x = 88,
  y = 89,
  z = 90,
  left_bracket = 91,
  backslash = 92,
  right_bracket = 93,
  grave = 96,
  space = 32,
  escape = 256,
  enter = 257,
  tab = 258,
  backspace = 259,
  insert = 260,
  delete = 261,
  right = 262,
  left = 263,
  down = 264,
  up = 265,
  page_up = 266,
  page_down = 267,
  home = 268,
  end = 269,
  caps_lock = 280,
  scroll_lock = 281,
  num_lock = 282,
  print_screen = 283,
  pause = 284,
  f1 = 290,
  f2 = 291,
  f3 = 292,
  f4 = 293,
  f5 = 294,
  f6 = 295,
  f7 = 296,
  f8 = 297,
  f9 = 298,
  f10 = 299,
  f11 = 300,
  f12 = 301,
  left_shift = 340,
  left_control = 341,
  left_alt = 342,
  left_super = 343,
  right_shift = 344,
  right_control = 345,
  right_alt = 346,
  right_super = 347,
  kb_menu = 348,
  kp_0 = 320,
  kp_1 = 321,
  kp_2 = 322,
  kp_3 = 323,
  kp_4 = 324,
  kp_5 = 325,
  kp_6 = 326,
  kp_7 = 327,
  kp_8 = 328,
  kp_9 = 329,
  kp_decimal = 330,
  kp_divide = 331,
  kp_multiply = 332,
  kp_subtract = 333,
  kp_add = 334,
  kp_enter = 335,
  kp_equal = 336,
  //back = 4,
  //menu = 82,
  //volume_up = 24,
  //volume_down = 25,


  pub const isPressed = IsKeyPressed;
  pub const isDown = IsKeyDown;
  pub const isReleased = IsKeyReleased;
  pub const isUp = IsKeyUp;
  pub const setExitKey = SetExitKey;
  pub const getPressed = GetKeyPressed;
  pub const getCharPressed = GetCharPressed;


  extern fn IsKeyPressed(Key) bool;
  extern fn IsKeyDown(Key) bool;
  extern fn IsKeyReleased(Key) bool;
  extern fn IsKeyUp(Key) bool;
  extern fn SetExitKey(Key) void;
  extern fn GetKeyPressed() Key;
  extern fn GetCharPressed() i32;
};

pub const MouseButton = enum(u32) {
  left = 0,
  right = 1,
  middle = 2,
  side = 3,
  extra = 4,
  forward = 5,
  back = 6,
  _,


  pub const isPressed = IsMouseButtonPressed;
  pub const isDown = IsMouseButtonDown;
  pub const isReleased = IsMouseButtonReleased;
  pub const isUp = IsMouseButtonUp;

  extern fn IsMouseButtonPressed(button: MouseButton) bool;
  extern fn IsMouseButtonDown(button: MouseButton) bool;
  extern fn IsMouseButtonReleased(button: MouseButton) bool;
  extern fn IsMouseButtonUp(button: MouseButton) bool;
};

pub const MouseCursor = enum(u32) {
  default = 0,
  arrow = 1,
  ibeam = 2,
  crosshair = 3,
  pointing_hand = 4,
  resize_ew = 5,
  resize_ns = 6,
  resize_nwse = 7,
  resize_nesw = 8,
  resize_all = 9,
  not_allowed = 10,

  pub const set = SetMouseCursor;

  extern fn SetMouseCursor(MouseCursor) void;
};

pub const GamepadButton = enum(u32) {
  unknown = 0,
  left_face_up = 1,
  left_face_right = 2,
  left_face_down = 3,
  left_face_left = 4,
  right_face_up = 5,
  right_face_right = 6,
  right_face_down = 7,
  right_face_left = 8,
  left_trigger_1 = 9,
  left_trigger_2 = 10,
  right_trigger_1 = 11,
  right_trigger_2 = 12,
  middle_left = 13,
  middle = 14,
  middle_right = 15,
  left_thumb = 16,
  right_thumb = 17,
  _
};

pub const GamepadAxis = enum(u32) {
  left_x = 0,
  left_y = 1,
  right_x = 2,
  right_y = 3,
  left_trigger = 4,
  right_trigger = 5,
  _
};

pub const MeterialMapIndex = enum(u32) {
  albedo = 0,
  metalness = 1,
  normal = 2,
  roughness = 3,
  occlusion = 4,
  emission = 5,
  height = 6,
  cubemap = 7,
  irradiance = 8,
  prefilter = 9,
  brdf = 10,
};

pub const ShaderLocationIndex = enum(u32) {
  vertex_position = 0,
  vertex_texcoord01 = 1,
  vertex_texcoord02 = 2,
  vertex_normal = 3,
  vertex_tangent = 4,
  vertex_color = 5,
  matrix_mvp = 6,
  matrix_view = 7,
  matrix_projection = 8,
  matrix_model = 9,
  matrix_normal = 10,
  vector_view = 11,
  color_diffuse = 12,
  color_specular = 13,
  color_ambient = 14,
  map_albedo = 15,
  map_metalness = 16,
  map_normal = 17,
  map_roughness = 18,
  map_occlusion = 19,
  map_emission = 20,
  map_height = 21,
  map_cubemap = 22,
  map_irradiance = 23,
  map_prefilter = 24,
  map_brdf = 25,
};

pub const ShaderUniformDataType = enum(u32) {
  float = 0,
  vec2 = 1,
  vec3 = 2,
  vec4 = 3,
  int = 4,
  ivec2 = 5,
  ivec3 = 6,
  ivec4 = 7,
  sampler2d = 8,
};

pub const ShaderAttributeDataType = enum(u32) {
  float = 0,
  vec2 = 1,
  vec3 = 2,
  vec4 = 3,
};

pub const PixelFormat = enum(u32) {
  uncompressed_grayscale = 1,
  uncompressed_gray_alpha = 2,
  uncompressed_r5g6b5 = 3,
  uncompressed_r8g8b8 = 4,
  uncompressed_r5g5b5a1 = 5,
  uncompressed_r4g4b4a4 = 6,
  uncompressed_r8g8b8a8 = 7,
  uncompressed_r32 = 8,
  uncompressed_r32g32b32 = 9,
  uncompressed_r32g32b32a32 = 10,
  compressed_dxt1_rgb = 11,
  compressed_dxt1_rgba = 12,
  compressed_dxt3_rgba = 13,
  compressed_dxt5_rgba = 14,
  compressed_etc1_rgb = 15,
  compressed_etc2_rgb = 16,
  compressed_etc2_eac_rgba = 17,
  compressed_pvrt_rgb = 18,
  compressed_pvrt_rgba = 19,
  compressed_astc_4x4_rgba = 20,
  compressed_astc_8x8_rgba = 21,
};

pub const TextureFilter = enum(u32) {
  point = 0,
  bilinear = 1,
  trilinear = 2,
  anisotropic_4x = 3,
  anisotropic_8x = 4,
  anisotropic_16x = 5,
};

pub const TextureWrap = enum(u32) {
  repeat = 0,
  clamp = 1,
  mirror_repeat = 2,
  mirror_clamp = 3
};

pub const CubemapLayout = enum(u32) {
  auto_detect = 0,
  line_vertical = 1,
  line_horizontal = 2,
  cross_three_by_four = 3,
  cross_four_by_three = 4,
  panorama = 5,
};

pub const FontType = enum(u32) {
  default = 0,
  bitmap = 1,
  sdf = 2,
};

pub const BlendMode = enum(u32) {
  alpha = 0,
  additive = 1,
  multiplied = 2,
  add_colors = 3,
  substract_colors = 4,
  alpha_premultiply = 5,
  custom = 6,
};

pub const Gesture = enum(u32) {
  none = 0,
  tap = 1,
  doubletap = 2,
  hold = 4,
  drag = 8,
  swipe_right = 16,
  swipe_left = 32,
  swipe_up = 64,
  swipe_down = 128,
  pinch_in = 256,
  pinch_out = 512,

  pub const setEnabled = SetGesturesEnabled;
  pub const isDetected = IsGestureDetected;
  pub const getDetected = GetGestureDetected;
  pub const getHoldDuration = GetGestureHoldDuration;
  pub const getDragVector = GetGestureDragVector;
  pub const getDragAngle = GetGestureDragAngle;
  pub const getPinchVector = GetGesturePinchVector;
  pub const getPinchAngle = GetGesturePinchAngle;

  extern fn SetGesturesEnabled(flags: u32) void;
  extern fn IsGestureDetected(gesture: Gesture) bool;
  extern fn GetGestureDetected() Gesture;
  extern fn GetGestureHoldDuration() f32;
  extern fn GetGestureDragVector() Vector2;
  extern fn GetGestureDragAngle() f32;
  extern fn GetGesturePinchVector() Vector2;
  extern fn GetGesturePinchAngle() f32;
};

pub const CameraMode = enum(u32) {
  custom = 0,
  free = 1,
  first_person = 3,
  thrid_person = 4,
};

pub const CameraProjection = enum(u32) {
  perspective = 0,
  orthographic = 1,
};

pub const NPatchLayout = enum(u32) {
  nine_patch = 0,
  three_patch_vertical = 1,
  three_patch_horizontal = 2,
};



pub const Window = struct {
  pub const init = InitWindow;
  pub const shouldClose = WindowShouldClose;
  pub const close = CloseWindow;
  pub const isReady = IsWindowReady;
  pub const isFullscreen = IsWindowFullscreen;
  pub const isHidden = IsWindowHidden;
  pub const isMinimized = IsWindowMinimized;
  pub const isMaximized = IsWindowMaximized;
  pub const isFocused = IsWindowFocused;
  pub const isResized = IsWindowResized;
  pub const isState = IsWindowState;
  pub const setState = SetWindowState;
  pub const clearState = ClearWindowState;
  pub const toggleFullscreen = ToggleFullscreen;
  pub const maximize = MaximizeWindow;
  pub const minimize = MinimizeWindow;
  pub const restore = RestoreWindow;
  pub const setIcon = SetWindowIcon;
  pub const setTitle = SetWindowTitle;
  pub const setPosition = SetWindowPosition;
  pub const setMonitor = SetWindowMonitor;
  pub const setMinSize = SetWindowMinSize;
  pub const setSize = SetWindowSize;
  pub const setOpacity = SetWindowOpacity;
  pub const getHandle = GetWindowHandle;
  pub const getScreenWidth = GetScreenWidth;
  pub const getScreenHeight = GetScreenHeight;
  pub const getRenderWidth = GetRenderWidth;
  pub const getRenderHeight = GetRenderHeight;
  pub const getPosition = GetWindowPosition;
  pub const getScaleDPI = GetWindowScaleDPI;
  pub const swapBuffer = SwapScreenBuffer;
  pub const setTargetFPS = SetTargetFPS;
  pub const getFPS = GetFPS;
  pub const takeScreenshot = TakeScreenshot;
  pub const setClipboardText = SetClipboardText;
  pub const getClipboardText = GetClipboardText;

  extern fn InitWindow(i32, i32, [*:0]const u8) void;
  extern fn WindowShouldClose() bool;
  extern fn CloseWindow() void;
  extern fn IsWindowReady() bool;
  extern fn IsWindowFullscreen() bool;
  extern fn IsWindowHidden() bool;
  extern fn IsWindowMinimized() bool;
  extern fn IsWindowMaximized() bool;
  extern fn IsWindowFocused() bool;
  extern fn IsWindowResized() bool;
  extern fn IsWindowState(flag: u32) bool;
  extern fn SetWindowState(flags: u32) void;
  extern fn ClearWindowState(flags: u32) void;
  extern fn ToggleFullscreen() void;
  extern fn MaximizeWindow() void;
  extern fn MinimizeWindow() void;
  extern fn RestoreWindow() void;
  extern fn SetWindowIcon(image: Image) void;
  extern fn SetWindowTitle(title: [*:0]const u8) void;
  extern fn SetWindowPosition(x: i32, y: i32) void;
  extern fn SetWindowMonitor(monitor: i32) void;
  extern fn SetWindowMinSize(width: i32, height: i32) void;
  extern fn SetWindowSize(width: i32, height: i32) void;
  extern fn SetWindowOpacity(opacity: f32) void;
  extern fn GetWindowHandle() ?*anyopaque;
  extern fn GetScreenWidth() i32;
  extern fn GetScreenHeight() i32;
  extern fn GetRenderWidth() i32;
  extern fn GetRenderHeight() i32;
  extern fn GetWindowPosition() Vector2;
  extern fn GetWindowScaleDPI() Vector2;
  extern fn SwapScreenBuffer() void;
  extern fn SetTargetFPS(fps: i32) void;
  extern fn GetFPS() i32;
  extern fn TakeScreenshot([*:0]const u8) void;
  extern fn SetClipboardText([*:0]const u8) void;
  extern fn GetClipboardText() [*:0]const u8;
};

pub const Monitor = struct {
  index: i32,

  pub fn init(
    i: i32
  ) callconv(.Inline) Monitor {
    return .{ .index = i };
  }

  pub fn getCurrent() callconv(.Inline) Monitor {
    return init(GetCurrentMonitor());
  }

  pub const getCount = GetMonitorCount;

  pub fn getPosition(self: Monitor) callconv(.Inline) Vector2 {
    return GetMonitorPosition(self.index);
  }

  pub fn getWidth(self: Monitor) callconv(.Inline) i32 {
    return GetMonitorWidth(self.index);
  }

  pub fn getHeight(self: Monitor) callconv(.Inline) i32 {
    return GetMonitorHeight(self.index);
  }

  pub fn getPhysicalWidth(self: Monitor) callconv(.Inline) i32 {
    return GetMonitorPhysicalWidth(self.index);
  }

  pub fn getPhysicalHeight(self: Monitor) callconv(.Inline) i32 {
    return GetMonitorPhysicalHeight(self.index);
  }

  pub fn getRefreshRate(self: Monitor) callconv(.Inline) i32 {
    return GetMonitorRefreshRate(self.index);
  }

  pub fn getName(self: Monitor) callconv(.Inline) [*:0]const u8 {
    return GetMonitorName(self.index);
  }


  extern fn GetMonitorCount() i32;
  extern fn GetCurrentMonitor() i32;
  extern fn GetMonitorPosition(monitor: i32) Vector2;
  extern fn GetMonitorWidth(monitor: i32) i32;
  extern fn GetMonitorHeight(monitor: i32) i32;
  extern fn GetMonitorPhysicalWidth(monitor: i32) i32;
  extern fn GetMonitorPhysicalHeight(monitor: i32) i32;
  extern fn GetMonitorRefreshRate(monitor: i32) i32;
  extern fn GetMonitorName(monitor: i32) [*:0]const u8;
};

pub const Clipboard = struct {
  pub const set = SetClipboardText;
  pub const get = GetClipboardText;

  extern fn SetClipboardText(text: [*:0]const u8) void;
  extern fn GetClipboardText() [*:0]const u8;
};

pub const Event = struct {
  pub const enableWaiting = EnableEventWaiting;
  pub const disableWaiting = DisableEventWaiting;
  pub const poll = PollInputEvents;

  pub fn getDroppedFiles(
    alloc: std.mem.Allocator,
  ) !?[][]u8 {
    if( !IsFileDropped() )
      return null;

    var files = LoadDroppedFiles();
    defer UnloadDroppedFiles(files);

    var res = try alloc.alloc([]u8, files.count);
    errdefer {
      for( res ) |p| alloc.free(p);
      alloc.free(res);
    }

    var i: usize = 0;
    while( i < files.count ) : (i += 1) {
      const path = std.mem.span(files.paths[i]);
      res[i] = try alloc.dupe(path);
    }

    return res;
  }

  extern fn EnableEventWaiting() void;
  extern fn DisableEventWaiting() void;
  extern fn PollInputEvents() void;
  extern fn IsFileDropped() bool;
  extern fn LoadDroppedFiles() FilePathList;
  extern fn UnloadDroppedFiles(files: FilePathList) void;
};

pub const Cursor = struct {
  pub const show = ShowCursor;
  pub const hide = HideCursor;
  pub const isHidden = IsCursorHidden;
  pub const enable = EnableCursor;
  pub const disable = DisableCursor;
  pub const isOnScreen = IsCursorOnScreen;

  extern fn ShowCursor() void;
  extern fn HideCursor() void;
  extern fn IsCursorHidden() bool;
  extern fn EnableCursor() void;
  extern fn DisableCursor() void;
  extern fn IsCursorOnScreen() bool;
};

pub const Graphics = struct {
  pub const clear = ClearBackground;
  pub const begin = BeginDrawing;
  pub const end = EndDrawing;
  pub const begin2D = BeginMode2D;
  pub const end2D = EndMode2D;
  pub const begin3D = BeginMode3D;
  pub const end3D = EndMode3D;
  pub const beginTexture = BeginTextureMode;
  pub const endTexture = EndTextureMode;
  pub const beginShader = BeginShaderMode;
  pub const endShader = EndShaderMode;
  pub const beginBlend = BeginBlendMode;
  pub const endBlend = EndBlendMode;
  pub const beginScissor = BeginScissorMode;
  pub const endScissor = EndScissorMode;
  pub const beginVrStereo = BeginVrStereoMode;
  pub const endVrStereo = EndVrStereoMode;
  pub const pixel = DrawPixel;
  pub const pixelV = DrawPixelV;
  pub const line = DrawLine;
  pub const lineV = DrawLineV;
  pub const lineEx = DrawLineEx;
  pub const lineBezier = DrawLineBezier;
  pub const lineBezierQuad = DrawLineBezierQuad;
  pub const lineBezierCubic = DrawLineBezierCubic;
  pub const lineStrip = DrawLineStrip;
  pub const circle = DrawCircle;
  pub const circleSector = DrawCircleSector;
  pub const circleSectorLines = DrawCircleSectorLines;
  pub const circleGradient = DrawCircleGradient;
  pub const circleV = DrawCircleV;
  pub const circleLines = DrawCircleLines;
  pub const ellipse = DrawEllipse;
  pub const ellipseLines = DrawEllipseLines;
  pub const ring = DrawRing;
  pub const ringLines = DrawRingLines;
  pub const rectangle = DrawRectangle;
  pub const rectangleV = DrawRectangleV;
  pub const rectangleRec = DrawRectangleRec;
  pub const rectanglePro = DrawRectanglePro;
  pub const rectangleGradientV = DrawRectangleGradientV;
  pub const rectangleGradientH = DrawRectangleGradientH;
  pub const rectangleGradientEx = DrawRectangleGradientEx;
  pub const rectangleLines = DrawRectangleLines;
  pub const rectangleLinesEx = DrawRectangleLinesEx;
  pub const rectangleRounded = DrawRectangleRounded;
  pub const rectangleRoundedLines = DrawRectangleRoundedLines;
  pub const triangle = DrawTriangle;
  pub const triangleLines = DrawTriangleLines;
  pub const triangleFan = DrawTriangleFan;
  pub const triangleStrip = DrawTriangleStrip;
  pub const poly = DrawPoly;
  pub const polyLines = DrawPolyLines;
  pub const polyLinesEx = DrawPolyLinesEx;
  pub const fps = DrawFPS;
  pub const text = DrawText;
  pub const textEx = DrawTextEx;
  pub const textPro = DrawTextPro;
  pub const textCodepoint = DrawTextCodepoint;
  pub const textCodepoints = DrawTextCodepoints;
  pub const texture = DrawTexture;
  pub const textureV = DrawTextureV;
  pub const textureEx = DrawTextureEx;
  pub const textureRec = DrawTextureRec;
  pub const textureQuad = DrawTextureQuad;
  pub const textureTiled = DrawTextureTiled;
  pub const texturePro = DrawTexturePro;
  pub const textureNPatch = DrawTextureNPatch;
  pub const texturePoly = DrawTexturePoly;
  pub const line3D = DrawLine3D;
  pub const point3D = DrawPoint3D;
  pub const circle3D = DrawCircle3D;
  pub const triangle3D = DrawTriangle3D;
  pub const triangleStrip3D = DrawTriangleStrip3D;
  pub const cube = DrawCube;
  pub const cuveV = DrawCubeV;
  pub const cubeWires = DrawCubeWires;
  pub const cubeWiresV = DrawCubeWiresV;
  pub const cubeTexture = DrawCubeTexture;
  pub const cubeTextureRec = DrawCubeTextureRec;
  pub const sphere = DrawSphere;
  pub const sphereEx = DrawSphereEx;
  pub const sphereWires = DrawSphereWires;
  pub const cylinder = DrawCylinder;
  pub const cylinderEx = DrawCylinderEx;
  pub const cylinderWires = DrawCylinderWires;
  pub const cylinderWiresEx = DrawCylinderWiresEx;
  pub const plane = DrawPlane;
  pub const ray = DrawRay;
  pub const grid = DrawGrid;
  pub const model = DrawModel;
  pub const modelEx = DrawModelEx;
  pub const modelWires = DrawModelWires;
  pub const modelWiresEx = DrawModelWiresEx;
  pub const boundingBox = DrawBoundingBox;
  pub const billboard = DrawBillboard;
  pub const billboardRec = DrawBillboardRec;
  pub const billboardPro = DrawBillboardPro;
  pub const mesh = DrawMesh;
  pub const meshInstanced = DrawMeshInstanced;

  extern fn ClearBackground(color: Color) void;
  extern fn BeginDrawing() void;
  extern fn EndDrawing() void;
  extern fn BeginMode2D(camera: Camera2D) void;
  extern fn EndMode2D() void;
  extern fn BeginMode3D(camera: Camera3D) void;
  extern fn EndMode3D() void;
  extern fn BeginTextureMode(target: RenderTexture2D) void;
  extern fn EndTextureMode() void;
  extern fn BeginShaderMode(shader: Shader) void;
  extern fn EndShaderMode() void;
  extern fn BeginBlendMode(mode: i32) void;
  extern fn EndBlendMode() void;
  extern fn BeginScissorMode(x: i32, y: i32, width: i32, height: i32) void;
  extern fn EndScissorMode() void;
  extern fn BeginVrStereoMode(config: VrStereoConfig) void;
  extern fn EndVrStereoMode() void;
  extern fn DrawPixel(posX: i32, posY: i32, color: Color) void;
  extern fn DrawPixelV(position: Vector2, color: Color) void;
  extern fn DrawLine(startPosX: i32, startPosY: i32, endPosX: i32, endPosY: i32, color: Color) void;
  extern fn DrawLineV(startPos: Vector2, endPos: Vector2, color: Color) void;
  extern fn DrawLineEx(startPos: Vector2, endPos: Vector2, thick: f32, color: Color) void;
  extern fn DrawLineBezier(startPos: Vector2, endPos: Vector2, thick: f32, color: Color) void;
  extern fn DrawLineBezierQuad(startPos: Vector2, endPos: Vector2, controlPos: Vector2, thick: f32, color: Color) void;
  extern fn DrawLineBezierCubic(startPos: Vector2, endPos: Vector2, startControlPos: Vector2, endControlPos: Vector2, thick: f32, color: Color) void;
  extern fn DrawLineStrip(points: [*c]Vector2, pointCount: i32, color: Color) void;
  extern fn DrawCircle(centerX: i32, centerY: i32, radius: f32, color: Color) void;
  extern fn DrawCircleSector(center: Vector2, radius: f32, startAngle: f32, endAngle: f32, segments: i32, color: Color) void;
  extern fn DrawCircleSectorLines(center: Vector2, radius: f32, startAngle: f32, endAngle: f32, segments: i32, color: Color) void;
  extern fn DrawCircleGradient(centerX: i32, centerY: i32, radius: f32, color1: Color, color2: Color) void;
  extern fn DrawCircleV(center: Vector2, radius: f32, color: Color) void;
  extern fn DrawCircleLines(centerX: i32, centerY: i32, radius: f32, color: Color) void;
  extern fn DrawEllipse(centerX: i32, centerY: i32, radiusH: f32, radiusV: f32, color: Color) void;
  extern fn DrawEllipseLines(centerX: i32, centerY: i32, radiusH: f32, radiusV: f32, color: Color) void;
  extern fn DrawRing(center: Vector2, innerRadius: f32, outerRadius: f32, startAngle: f32, endAngle: f32, segments: i32, color: Color) void;
  extern fn DrawRingLines(center: Vector2, innerRadius: f32, outerRadius: f32, startAngle: f32, endAngle: f32, segments: i32, color: Color) void;
  extern fn DrawRectangle(posX: i32, posY: i32, width: i32, height: i32, color: Color) void;
  extern fn DrawRectangleV(position: Vector2, size: Vector2, color: Color) void;
  extern fn DrawRectangleRec(rec: Rectangle, color: Color) void;
  extern fn DrawRectanglePro(rec: Rectangle, origin: Vector2, rotation: f32, color: Color) void;
  extern fn DrawRectangleGradientV(posX: i32, posY: i32, width: i32, height: i32, color1: Color, color2: Color) void;
  extern fn DrawRectangleGradientH(posX: i32, posY: i32, width: i32, height: i32, color1: Color, color2: Color) void;
  extern fn DrawRectangleGradientEx(rec: Rectangle, col1: Color, col2: Color, col3: Color, col4: Color) void;
  extern fn DrawRectangleLines(posX: i32, posY: i32, width: i32, height: i32, color: Color) void;
  extern fn DrawRectangleLinesEx(rec: Rectangle, lineThick: f32, color: Color) void;
  extern fn DrawRectangleRounded(rec: Rectangle, roundness: f32, segments: i32, color: Color) void;
  extern fn DrawRectangleRoundedLines(rec: Rectangle, roundness: f32, segments: i32, lineThick: f32, color: Color) void;
  extern fn DrawTriangle(v1: Vector2, v2: Vector2, v3: Vector2, color: Color) void;
  extern fn DrawTriangleLines(v1: Vector2, v2: Vector2, v3: Vector2, color: Color) void;
  extern fn DrawTriangleFan(points: [*c]Vector2, pointCount: i32, color: Color) void;
  extern fn DrawTriangleStrip(points: [*c]Vector2, pointCount: i32, color: Color) void;
  extern fn DrawPoly(center: Vector2, sides: i32, radius: f32, rotation: f32, color: Color) void;
  extern fn DrawPolyLines(center: Vector2, sides: i32, radius: f32, rotation: f32, color: Color) void;
  extern fn DrawPolyLinesEx(center: Vector2, sides: i32, radius: f32, rotation: f32, lineThick: f32, color: Color) void;
  extern fn DrawFPS(i32, i32) void;
  extern fn DrawText([:0]const u8, i32, i32, i32, Color) void;
  extern fn DrawTextEx(font: Font, text: [*:0]const u8, position: Vector2, fontSize: f32, spacing: f32, tint: Color) void;
  extern fn DrawTextPro(font: Font, text: [*:0]const u8, position: Vector2, origin: Vector2, rotation: f32, fontSize: f32, spacing: f32, tint: Color) void;
  extern fn DrawTextCodepoint(font: Font, codepoint: i32, position: Vector2, fontSize: f32, tint: Color) void;
  extern fn DrawTextCodepoints(font: Font, codepoints: [*]const i32, count: i32, position: Vector2, fontSize: f32, spacing: f32, tint: Color) void;
  extern fn DrawTexture(texture: Texture2D, posX: i32, posY: i32, tint: Color) void;
  extern fn DrawTextureV(texture: Texture2D, position: Vector2, tint: Color) void;
  extern fn DrawTextureEx(texture: Texture2D, position: Vector2, rotation: f32, scale: f32, tint: Color) void;
  extern fn DrawTextureRec(texture: Texture2D, source: Rectangle, position: Vector2, tint: Color) void;
  extern fn DrawTextureQuad(texture: Texture2D, tiling: Vector2, offset: Vector2, quad: Rectangle, tint: Color) void;
  extern fn DrawTextureTiled(texture: Texture2D, source: Rectangle, dest: Rectangle, origin: Vector2, rotation: f32, scale: f32, tint: Color) void;
  extern fn DrawTexturePro(texture: Texture2D, source: Rectangle, dest: Rectangle, origin: Vector2, rotation: f32, tint: Color) void;
  extern fn DrawTextureNPatch(texture: Texture2D, nPatchInfo: NPatchInfo, dest: Rectangle, origin: Vector2, rotation: f32, tint: Color) void;
  extern fn DrawTexturePoly(texture: Texture2D, center: Vector2, points: [*]Vector2, texcoords: [*]Vector2, pointCount: i32, tint: Color) void;
  extern fn DrawLine3D(startPos: Vector3, endPos: Vector3, color: Color) void;
  extern fn DrawPoint3D(position: Vector3, color: Color) void;
  extern fn DrawCircle3D(center: Vector3, radius: f32, rotationAxis: Vector3, rotationAngle: f32, color: Color) void;
  extern fn DrawTriangle3D(v1: Vector3, v2: Vector3, v3: Vector3, color: Color) void;
  extern fn DrawTriangleStrip3D(points: [*c]Vector3, pointCount: i32, color: Color) void;
  extern fn DrawCube(position: Vector3, width: f32, height: f32, length: f32, color: Color) void;
  extern fn DrawCubeV(position: Vector3, size: Vector3, color: Color) void;
  extern fn DrawCubeWires(position: Vector3, width: f32, height: f32, length: f32, color: Color) void;
  extern fn DrawCubeWiresV(position: Vector3, size: Vector3, color: Color) void;
  extern fn DrawCubeTexture(texture: Texture2D, position: Vector3, width: f32, height: f32, length: f32, color: Color) void;
  extern fn DrawCubeTextureRec(texture: Texture2D, source: Rectangle, position: Vector3, width: f32, height: f32, length: f32, color: Color) void;
  extern fn DrawSphere(centerPos: Vector3, radius: f32, color: Color) void;
  extern fn DrawSphereEx(centerPos: Vector3, radius: f32, rings: i32, slices: i32, color: Color) void;
  extern fn DrawSphereWires(centerPos: Vector3, radius: f32, rings: i32, slices: i32, color: Color) void;
  extern fn DrawCylinder(position: Vector3, radiusTop: f32, radiusBottom: f32, height: f32, slices: i32, color: Color) void;
  extern fn DrawCylinderEx(startPos: Vector3, endPos: Vector3, startRadius: f32, endRadius: f32, sides: i32, color: Color) void;
  extern fn DrawCylinderWires(position: Vector3, radiusTop: f32, radiusBottom: f32, height: f32, slices: i32, color: Color) void;
  extern fn DrawCylinderWiresEx(startPos: Vector3, endPos: Vector3, startRadius: f32, endRadius: f32, sides: i32, color: Color) void;
  extern fn DrawPlane(centerPos: Vector3, size: Vector2, color: Color) void;
  extern fn DrawRay(ray: Ray, color: Color) void;
  extern fn DrawGrid(slices: i32, spacing: f32) void;
  extern fn DrawModel(model: Model, position: Vector3, scale: f32, tint: Color) void;
  extern fn DrawModelEx(model: Model, position: Vector3, rotationAxis: Vector3, rotationAngle: f32, scale: Vector3, tint: Color) void;
  extern fn DrawModelWires(model: Model, position: Vector3, scale: f32, tint: Color) void;
  extern fn DrawModelWiresEx(model: Model, position: Vector3, rotationAxis: Vector3, rotationAngle: f32, scale: Vector3, tint: Color) void;
  extern fn DrawBoundingBox(box: BoundingBox, color: Color) void;
  extern fn DrawBillboard(camera: Camera, texture: Texture2D, position: Vector3, size: f32, tint: Color) void;
  extern fn DrawBillboardRec(camera: Camera, texture: Texture2D, source: Rectangle, position: Vector3, size: Vector2, tint: Color) void;
  extern fn DrawBillboardPro(camera: Camera, texture: Texture2D, source: Rectangle, position: Vector3, up: Vector3, size: Vector2, origin: Vector2, rotation: f32, tint: Color) void;
  extern fn DrawMesh(mesh: Mesh, material: Material, transform: Matrix) void;
  extern fn DrawMeshInstanced(mesh: Mesh, material: Material, transforms: [*]const Matrix, instances: i32) void;
};

pub const Gamepad = struct {
  index: i32,


  pub fn init(idx: i32) callconv(.Inline) Gamepad {
    return .{ .index = idx };
  }

  pub fn isAvailable(self: Gamepad) callconv(.Inline) bool {
    return IsGamepadAvailable(self.index);
  }

  pub fn getName(self: Gamepad) callconv(.Inline) [*:0]const u8 {
    return GetGamepadName(self.index);
  }

  pub fn isButtonPressed(self: Gamepad, b: GamepadButton) callconv(.Inline) bool {
    return IsGamepadButtonPressed(self.index, b);
  }

  pub fn isButtonDown(self: Gamepad, b: GamepadButton) callconv(.Inline) bool {
    return IsGamepadButtonDown(self.index, b);
  }

  pub fn isButtonReleased(self: Gamepad, b: GamepadButton) callconv(.Inline) bool {
    return IsGamepadButtonReleased(self.index, b);
  }

  pub fn isButtonUp(self: Gamepad, b: GamepadButton) callconv(.Inline) bool {
    return IsGamepadButtonUp(self.index, b);
  }

  pub fn getAxisCount(self: Gamepad) callconv(.Inline) i32 {
    return GetGamepadAxisCount(self.index);
  }

  pub fn getAxisMovement(self: Gamepad, a: GamepadAxis) callconv(.Inline) f32 {
    return GetGamepadAxisMovement(self.index, a);
  }

  pub const setMappings = SetGamepadMappings;



  extern fn IsGamepadAvailable(gamepad: i32) bool;
  extern fn GetGamepadName(gamepad: i32) [*c]const u8;
  extern fn IsGamepadButtonPressed(gamepad: i32, button: GamepadButton) bool;
  extern fn IsGamepadButtonDown(gamepad: i32, button: GamepadButton) bool;
  extern fn IsGamepadButtonReleased(gamepad: i32, button: GamepadButton) bool;
  extern fn IsGamepadButtonUp(gamepad: i32, button: GamepadButton) bool;
  extern fn GetGamepadButtonPressed() GamepadButton;
  extern fn GetGamepadAxisCount(gamepad: i32) i32;
  extern fn GetGamepadAxisMovement(gamepad: i32, axis: GamepadAxis) f32;
  extern fn SetGamepadMappings(mappings: [*:0]const u8) i32;
};

pub const Mouse = struct {
  pub const getX = GetMouseX;
  pub const getY = GetMouseY;
  pub const getPosition = GetMousePosition;
  pub const getDelta = GetMouseDelta;
  pub const setPosition = SetMousePosition;
  pub const setOffset = SetMouseOffset;
  pub const setScale = SetMouseScale;
  pub const getWheelMove = GetMouseWheelMove;
  pub const getWheelMoveV = GetMouseWheelMoveV;

  extern fn GetMouseX() i32;
  extern fn GetMouseY() i32;
  extern fn GetMousePosition() Vector2;
  extern fn GetMouseDelta() Vector2;
  extern fn SetMousePosition(x: i32, y: i32) void;
  extern fn SetMouseOffset(offsetX: i32, offsetY: i32) void;
  extern fn SetMouseScale(scaleX: f32, scaleY: f32) void;
  extern fn GetMouseWheelMove() f32;
  extern fn GetMouseWheelMoveV() Vector2;
};

pub const Touch = struct {
  pub const getX = GetTouchX;
  pub const getY = GetTouchY;
  pub const getPosition = GetTouchPosition;
  pub const getPointId = GetTouchPointId;
  pub const getPointCount = GetTouchPointCount;

  extern fn GetTouchX() i32;
  extern fn GetTouchY() i32;
  extern fn GetTouchPosition(index: i32) Vector2;
  extern fn GetTouchPointId(index: i32) i32;
  extern fn GetTouchPointCount() i32;
};

pub const Collision = struct {
  pub const checkRecs = CheckCollisionRecs;
  pub const checkCircles = CheckCollisionCircles;
  pub const checkCircleRec = CheckCollisionCircleRec;
  pub const checkPointRec = CheckCollisionPointRec;
  pub const checkPointCircle = CheckCollisionPointCircle;
  pub const checkPointTriangle = CheckCollisionPointTriangle;
  pub const checkLines = CheckCollisionLines;
  pub const checkPointLine = CheckCollisionPointLine;
  pub const getRec = GetCollisionRec;
  pub const checkSpheres = CheckCollisionSpheres;
  pub const checkBoxes = CheckCollisionBoxes;
  pub const checkBoxSphere = CheckCollisionBoxSphere;

  extern fn CheckCollisionRecs(rec1: Rectangle, rec2: Rectangle) bool;
  extern fn CheckCollisionCircles(center1: Vector2, radius1: f32, center2: Vector2, radius2: f32) bool;
  extern fn CheckCollisionCircleRec(center: Vector2, radius: f32, rec: Rectangle) bool;
  extern fn CheckCollisionPointRec(point: Vector2, rec: Rectangle) bool;
  extern fn CheckCollisionPointCircle(point: Vector2, center: Vector2, radius: f32) bool;
  extern fn CheckCollisionPointTriangle(point: Vector2, p1: Vector2, p2: Vector2, p3: Vector2) bool;
  extern fn CheckCollisionLines(startPos1: Vector2, endPos1: Vector2, startPos2: Vector2, endPos2: Vector2, collisionPoint: ?*Vector2) bool;
  extern fn CheckCollisionPointLine(point: Vector2, p1: Vector2, p2: Vector2, threshold: i32) bool;
  extern fn GetCollisionRec(rec1: Rectangle, rec2: Rectangle) Rectangle;
  extern fn CheckCollisionSpheres(center1: Vector3, radius1: f32, center2: Vector3, radius2: f32) bool;
  extern fn CheckCollisionBoxes(box1: BoundingBox, box2: BoundingBox) bool;
  extern fn CheckCollisionBoxSphere(box: BoundingBox, center: Vector3, radius: f32) bool;
};

pub const Text = struct {
  pub const loadCodepoints = LoadCodepoints;
  pub const unloadCodepoints = UnloadCodepoints;
  pub const getCodepointCount = GetCodepointCount;
  pub const getCodepoint = GetCodepoint;
  pub const codepointToUtf8 = CodepointToUTF8;

  extern fn LoadCodepoints(text: [*:0]const u8, count: *i32) [*c]i32;
  extern fn UnloadCodepoints(codepoints: [*]i32) void;
  extern fn GetCodepointCount(text: [*:0]const u8) i32;
  extern fn GetCodepoint(text: [*:0]const u8, bytesProcessed: *i32) i32;
  extern fn CodepointToUTF8(codepoint: i32, byteSize: *i32) [*]const u8;
};

pub const AudioDevice = struct {
  pub const init = InitAudioDevice;
  pub const close = CloseAudioDevice;
  pub const isReady = IsAudioDeviceReady;
  pub const setMasterVolume = SetMasterVolume;

  extern fn InitAudioDevice() void;
  extern fn CloseAudioDevice() void;
  extern fn IsAudioDeviceReady() bool;
  extern fn SetMasterVolume(volume: f32) void;
};

pub const wait = WaitTime;
pub const getFrameTime = GetFrameTime;
pub const getTime = GetTime;
pub const setConfigFlags = SetConfigFlags;

extern fn WaitTime(f64) void;
extern fn GetFrameTime() f32;
extern fn GetTime() f64;
extern fn SetConfigFlags(u32) void;
extern fn OpenURL([*:0]const u8) void;
