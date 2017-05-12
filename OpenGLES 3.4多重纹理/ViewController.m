//
//  ViewController.m
//  OpenGLES 3.4多重纹理
//  多重颜色混合显示
//  Created by ShiWen on 2017/5/12.
//  Copyright © 2017年 ShiWen. All rights reserved.
//

#import "ViewController.h"
#import "AGLKVertexAttribArrayBuffer.h"
#import "AGLKContext.h"

typedef struct {
    GLKVector3 postionCorrds;
    GLKVector2 vertextureCorrds;
    
}Scens;
static  Scens verts[] = {
    {{-0.5f,-0.5f,0.0f},{0.0f,0.0f}},//左下角为直角的三角形
    {{-0.5f,0.5f,0.0f},{0.0f,1.0f}},
    {{0.5f,-0.5f,0.0f},{1.0f,0.0f}},
    
    {{0.5f,-0.5f,0.0f},{1.0f,0.0f}},//左上角为直角的三角形
    {{0.5f,0.5f,0.0f},{1.0f,1.0f}},
    {{-0.5f,0.5f,0.0f},{0.0f,1.0f}},
    
};
@interface ViewController ()
@property(nonatomic,strong) AGLKVertexAttribArrayBuffer *mVertexbuffer;
@property (nonatomic,strong) GLKBaseEffect *mBaseEffect;
@property(nonatomic,strong) GLKTextureInfo *textureInfo0;
@property (nonatomic,strong) GLKTextureInfo *textureInfo1;
@property (nonatomic,strong) GLKTextureInfo *textureInfo2;

@property (nonatomic,assign) float xValue;
@property (nonatomic,assign) float yValue;
@property (nonatomic,assign) float zValue;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self setupConfig];
}
-(void)setupConfig{
    self.preferredFramesPerSecond = 60;
    GLKView *view = (GLKView *)self.view;
    NSAssert([view isKindOfClass:[GLKView class]], @"Storeboard没有设置");
    view.context = [[AGLKContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    [AGLKContext setCurrentContext:view.context];
    [((AGLKContext *)view.context) setClearColor:GLKVector4Make(0.0f, 0.0f, 0.0f, 1.0f)];

    self.mVertexbuffer = [[AGLKVertexAttribArrayBuffer alloc] initWithAttribStride:sizeof(Scens) numberOfVertices:sizeof(verts)/sizeof(Scens) bytes:verts usage:GL_STATIC_DRAW];
    
    self.mBaseEffect = [[GLKBaseEffect alloc] init];
    self.mBaseEffect.useConstantColor = GL_TRUE;
    self.mBaseEffect.constantColor = GLKVector4Make(1.0f, 1.0f, 1.0f, 1.0f);
    
    CGImageRef imageref0 = [[UIImage imageNamed:@"leaves.gif"] CGImage];
    NSDictionary *options = [[NSDictionary alloc] initWithObjectsAndKeys:@(1),GLKTextureLoaderOriginBottomLeft, nil];
    self.textureInfo0 = [GLKTextureLoader textureWithCGImage:imageref0 options:options error:nil];
    
    CGImageRef imageref1 = [[UIImage imageNamed:@"beetle.png"] CGImage];
    self.textureInfo1 = [GLKTextureLoader textureWithCGImage:imageref1 options:options error:nil];
    CGImageRef imageref2 = [[UIImage imageNamed:@"testVer.png"] CGImage];
    self.textureInfo2 = [GLKTextureLoader textureWithCGImage:imageref2 options:options error:nil];
    // Enable fragment blending with Frame Buffer contents
    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    
}
-(void)glkView:(GLKView *)view drawInRect:(CGRect)rect{
    [((AGLKContext *)view.context) clear:GL_COLOR_BUFFER_BIT];
    //准备绘制
    [self.mVertexbuffer prepareToDrawWithAttrib:GLKVertexAttribPosition numberOfCoordinates:3 attribOffset:offsetof(Scens, postionCorrds) shouldEnable:YES];
    [self.mVertexbuffer prepareToDrawWithAttrib:GLKVertexAttribTexCoord0 numberOfCoordinates:2 attribOffset:offsetof(Scens, vertextureCorrds) shouldEnable:YES];
    self.mBaseEffect.texture2d0.target = self.textureInfo0.target;
    self.mBaseEffect.texture2d0.name = self.textureInfo0.name;
    //将要开始绘制
    [self.mBaseEffect prepareToDraw];
    //绘制
    [self.mVertexbuffer drawArrayWithMode:GL_TRIANGLES startVertexIndex:0 numberOfVertices:sizeof(verts) / sizeof(Scens)];

    
    self.mBaseEffect.texture2d0.target = self.textureInfo1.target;
    self.mBaseEffect.texture2d0.name = self.textureInfo1.name;
    [self.mBaseEffect prepareToDraw];
    [self.mVertexbuffer drawArrayWithMode:GL_TRIANGLES startVertexIndex:0 numberOfVertices:sizeof(verts) / sizeof(Scens)];
    
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
