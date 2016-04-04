//
//  CarViewController.m
//  cardemo
//
//  Created by guanhui on 4/4/16.
//  Copyright (c) 2016 guanhui. All rights reserved.
//

#import "CarViewController.h"

@interface CarViewController ()

@property (nonatomic) CarModel currentCar;
@property (weak, nonatomic) IBOutlet SCNView *sceneView;

@end

@implementation CarViewController


- (void)viewDidLoad{
    [super viewDidLoad];
    
    // set  GLA as default car model
     self.currentCar = GLA;
    
    
    [self buildScene:self.currentCar andScnView:self.sceneView];
    self.sceneView.allowsCameraControl = YES;
    self.sceneView.showsStatistics = YES;
}

#pragma mark - build 3D scene

-(void) buildScene:(CarModel) model andScnView:(SCNView *) scnView{
    self.currentCar = model;
    
    SCNScene *scene = nil;
    if(model == GLA){
        scene =  [self buildGLAScene];
    }else if(model == AMG){
        scene = [self buildAMGScene];
    }else {
        scene =[self buildAMGConceptScene];
    }
    scnView.scene = scene;
}

- (SCNScene*) buildGLAScene{
    
    SCNScene *scene = [SCNScene sceneNamed:@"art.scnassets/GLA.dae"];
    
    // add lights
    SCNNode *lightNode = [SCNNode node];
    lightNode.light = [SCNLight light];
    lightNode.light.type = SCNLightTypeOmni;
    lightNode.position = SCNVector3Make(0, 20, 20);
    [scene.rootNode addChildNode:lightNode];
    
    SCNNode *ambientLightNode = [SCNNode node];
    ambientLightNode.light = [SCNLight light];
    ambientLightNode.light.type = SCNLightTypeAmbient;
    ambientLightNode.light.color = [UIColor darkGrayColor];
    [scene.rootNode addChildNode:ambientLightNode];
    

    self.sceneView.backgroundColor = [UIColor whiteColor];
    return scene;
}

- (SCNScene*) buildAMGScene{
    
    SCNScene *scene = [SCNScene sceneNamed:@"art.scnassets/AMG.dae"];
    
    // add lights
    SCNNode *lightNode = [SCNNode node];
    lightNode.light = [SCNLight light];
    lightNode.light.type = SCNLightTypeOmni;
    lightNode.position = SCNVector3Make(0, 10, 10);
    [scene.rootNode addChildNode:lightNode];
    
    SCNNode *ambientLightNode = [SCNNode node];
    ambientLightNode.light = [SCNLight light];
    ambientLightNode.light.type = SCNLightTypeAmbient;
    ambientLightNode.light.color = [UIColor darkGrayColor];
    [scene.rootNode addChildNode:ambientLightNode];
    
    // white backgroud
    self.sceneView.backgroundColor = [UIColor blackColor];
    
    return scene;
}

- (SCNScene*) buildAMGConceptScene{

    SCNScene *scene = [SCNScene sceneNamed:@"art.scnassets/AMGConcept.dae"];
    
    // add lights
    SCNNode *lightNode = [SCNNode node];
    lightNode.light = [SCNLight light];
    lightNode.light.type = SCNLightTypeSpot;
    lightNode.position = SCNVector3Make(40, 30, 10);
    [scene.rootNode addChildNode:lightNode];
    
    SCNNode *ambientLightNode = [SCNNode node];
    ambientLightNode.light = [SCNLight light];
    ambientLightNode.light.type = SCNLightTypeAmbient;
    ambientLightNode.light.color = [UIColor darkGrayColor];
    [scene.rootNode addChildNode:ambientLightNode];
    
    self.sceneView.backgroundColor = [UIColor lightGrayColor];
    return scene;
}


#pragma mark - actions

- (void) updateCarModel:(CarModel) carModel{
    self.currentCar = carModel;
    [self buildScene:self.currentCar andScnView:self.sceneView];
}

- (IBAction)showGLA:(id)sender {
    [self updateCarModel:GLA];
}

- (IBAction)showAMG:(id)sender {
    [self updateCarModel:AMG];
}

- (IBAction)showAMGConcept:(id)sender {
    [self updateCarModel:AMGConcept];
}

// update main material diffuse color to bule
- (IBAction)setBlueColor:(id)sender {
    NSArray *nodeNames = [self getNodeNamesToChangeColor];
    for (int i = 0; i < [nodeNames count]; i++)
    {
        NSString *nodeName = [nodeNames objectAtIndex:i];
        [self.sceneView.scene.rootNode childNodeWithName:nodeName recursively:YES].geometry.firstMaterial.diffuse.contents = [UIColor blueColor];
    }
}

// update main material diffuse color to origin color
- (IBAction)setOriginColor:(id)sender {
    NSArray *nodeNames = [self getNodeNamesToChangeColor];
    UIColor *origin = nil;
    
    if(self.currentCar == GLA){
        origin = [UIColor colorWithRed:(65/255.0) green:(51/255.0) blue:(35/255.0) alpha:1];
    }else if(self.currentCar == AMG){
        origin = [UIColor colorWithRed:(254/255.0) green:(201/255.0) blue:(49/255.0) alpha:1];
    }else {
        origin = [UIColor colorWithRed:(247/255.0) green:(122/255.0) blue:(37/255.0) alpha:1];
    }
    
    for (int i = 0; i < [nodeNames count]; i++)
    {
        NSString *nodeName = [nodeNames objectAtIndex:i];
        [self.sceneView.scene.rootNode childNodeWithName:nodeName recursively:YES].geometry.firstMaterial.diffuse.contents = origin;
    }
}

- (NSArray *)getNodeNamesToChangeColor{
    NSArray *nodeNames = nil;
    if(self.currentCar == GLA){
        nodeNames = [NSArray arrayWithObjects:@"ID4159",@"ID2006",@"ID4180",@"ID2006",@"ID4186",@"ID4162",@"ID668",nil];
    }else if(self.currentCar == AMG){
        nodeNames = [NSArray arrayWithObjects:@"ID1880",nil];
    }else {
        nodeNames = [NSArray arrayWithObjects:@"ID509",@"ID2006",@"ID597",nil];
    }
    return nodeNames;
}

// rotate
- (IBAction)rotate:(id)sender {
    SCNNode *car = [self.sceneView.scene.rootNode childNodeWithName:@"SketchUp" recursively:YES];
    [car runAction:[SCNAction repeatActionForever:[SCNAction rotateByX:0 y:1 z:0 duration:1]]];
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
