//
//  GameViewController.m
//  rzGalileo
//
//  Created by Robert Zimmelman on 5/16/15.
//  Public Domain 2015 Robert Zimmelman under GPL
//

#import "GameViewController.h"

float mySphereRadius = 2.5 ;
float myMaxVal = 0.0;

@implementation GameViewController
{
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *myDimString = [[NSString alloc] init];
    NSString *myConString = [[NSString alloc] init];
    int myDimensions = 0;
    int myConceptCount = 0;
    
//    NSURL *url = [NSURL fileURLWithPath:@"/Users/robertzimmelman/Documents/XCode/rzFileIOTest/wk1allresponsesROT.crd.txt" ];
//    NSURL *url = [NSURL fileURLWithPath:@"/Users/robertzimmelman/Documents/XCode/Galileo Viewer iOS/Galileo Viewer iOS/wk3allresponsesROT.crd" ];
    NSURL *url = [NSURL fileURLWithPath:@"/Users/robertzimmelman/Documents/XCode/Galileo Viewer iOS/Galileo Viewer iOS/wk9allresponsesROT.crd" ];
//    NSURL *url = [NSURL fileURLWithPath:@"/Users/robertzimmelman/Documents/XCode/Galileo Viewer iOS/Galileo Viewer iOS/wk2allresponsesROT.crd.txt" ];
//    NSURL *url = [NSURL fileURLWithPath:@"/Users/robertzimmelman/Documents/XCode/Galileo Viewer iOS/Galileo Viewer iOS/wk1allresponsesROT.crd.txt" ];
    NSError *error;
    
    //        NSString *stringFromFile = [NSString stringWithContentsOfFile:@"./test.txt" encoding:NSASCIIStringEncoding error: NULL];
    
    
    NSString *stringFromFile = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:NULL];
    //        NSNumber *myNextNum = 0;
    
    if (stringFromFile == nil) {
        // an error occurred
        NSLog(@"Error reading file at %@\n%@",
              url, [error localizedFailureReason]);
    }
    else {
        myDimString = [stringFromFile substringWithRange: NSMakeRange(17, 2)];
        myConString = [stringFromFile substringWithRange: NSMakeRange(11, 2)];
        myDimensions = [myDimString intValue];
        myConceptCount = [myConString intValue];
        NSArray *myFileLines = [stringFromFile componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
        NSMutableArray *myWorkLines = [NSMutableArray arrayWithArray:myFileLines];
        NSInteger myLineCount = [myFileLines count];
        
        for (int i = 0 ; i < myLineCount; i++) {
            if ([myFileLines [i] length] == 0 ) {
                [myWorkLines removeObject:myFileLines[i]];
            }
        }
        NSUInteger myWorkLineCount = [myWorkLines count] ;
        
        //            for (int i = 0 ; i < myWorkLineCount; i++) {
        //                NSLog(@"Line %i: %@", i , myWorkLines[i]);
        //            }
        
        
        
        
        //            for (int i = 0 ; i < myConceptCount; i++) {
        //                NSLog(@"Concept %i = %@", i + 1 , myCrdLabels[i] );
        //            }

        NSLog(@"Dims: %i",myDimensions);
        NSLog(@"Cons: %i",myConceptCount);
        NSString *myTitleString = [[myFileLines objectAtIndex:0] substringFromIndex:19];
        NSLog(@"Title Is: %@",myTitleString);
        NSLog(@"Line Count= %lu",myWorkLineCount);
        
        NSArray *myCrdLines = [ myWorkLines objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange: NSMakeRange( 1, myWorkLineCount  - myConceptCount - 1)]   ];
        long myTempX = 0;
        long myTempY = 0;
        long myTempZ = 0;
        int j = 0;
        long myCrdsArray[20][3];
        for (int i = 0; i < myConceptCount; i++) {
            j = i * 3;
            //                NSLog(@"myCrdLines[j]= %@", myCrdLines[j] );
            NSArray *myTempArray = [NSArray arrayWithObjects:myCrdLines[j], nil];
            NSString *myTempString = [[ myTempArray valueForKey:@"description"] componentsJoinedByString:@""];
            //                NSLog(@"TempString= %@",myTempString);
            myTempX = [[myTempString substringWithRange:NSMakeRange(0, 10)] doubleValue] ;
            myTempY = [[myTempString substringWithRange:NSMakeRange(11, 10)] doubleValue] ;
            myTempZ = [[myTempString substringWithRange:NSMakeRange(21, 10)] doubleValue] ;
            //                NSLog(@"X= %ld, Y= %ld, Z= %ld" , myTempX , myTempY , myTempZ);
            myCrdsArray[i][0] =  myTempX;
            myCrdsArray[i][1] =  myTempY;
            myCrdsArray[i][2] =  myTempZ;
            
            if (myTempX > myMaxVal) {
                myMaxVal = myTempX;
            }
            if (myTempY > myMaxVal) {
                myMaxVal = myTempX;
            }
            if (myTempX > myMaxVal) {
                myMaxVal = myTempX;
            }
            
        }
        // create a new scene
        SCNScene *scene = [SCNScene sceneNamed:@"art.scnassets/ship.dae"];
        
        // rz put some fog just in the middle of the ship so we can see it in real time
        //
        scene.fogColor = [UIColor whiteColor];
        scene.fogStartDistance = 20.0;
        scene.fogEndDistance = 5000.0;
        scene.fogDensityExponent = 1.0;
        
        
        
        // create and add a camera to the scene
        SCNNode *cameraNode = [SCNNode node];
        cameraNode.camera = [SCNCamera camera];
        [scene.rootNode addChildNode:cameraNode];
        
        // place the camera
        cameraNode.position = SCNVector3Make(0, 50, 100);
        cameraNode.camera.yFov = 120.0;
        cameraNode.camera.zFar = 5000.0;
        
        [cameraNode setName:@"camera"];
        
        // create and add a light to the scene
//        SCNNode *lightNode = [SCNNode node];
//        lightNode.light = [SCNLight light];
//        lightNode.light.type = SCNLightTypeOmni;
//        lightNode.light.attenuationEndDistance = 10000.0;
//        lightNode.position = SCNVector3Make(0, 100, 50);
//        [scene.rootNode addChildNode:lightNode];
        
        
        NSArray *myCrdLabels = [ myWorkLines objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange: NSMakeRange( myWorkLineCount - myConceptCount , myConceptCount)] ];
        
        
        SCNView *scnView = (SCNView *)self.view;
        
        // set the scene to the view
        scnView.scene = scene;
        
        // allows the user to manipulate the camera
        scnView.allowsCameraControl = YES;
        
        // show statistics such as fps and timing information
        scnView.showsStatistics = YES;
        
        // configure the view
        scnView.backgroundColor = [UIColor blackColor];
        
        // rz default lighting
        scnView.autoenablesDefaultLighting = YES;
        
        
        // rz display the title somewhere
        SCNText *myTitleGeometry = [SCNText textWithString:myTitleString extrusionDepth:1.0];
        SCNNode *myTitleNode = [SCNNode nodeWithGeometry:myTitleGeometry];
        [myTitleNode setScale:SCNVector3Make(2, 2, 2)];
        [myTitleGeometry.firstMaterial setTransparency:0.5];
        [myTitleNode setPosition:SCNVector3Make( -myMaxVal * 4 , myMaxVal * 4 , -myMaxVal * 2 )];
        [scene.rootNode addChildNode:myTitleNode];
        
        
        
        // rz make the spheres and cylinders and text for the concepts
        for (int i = 0; i < myConceptCount; i++) {
            NSLog(@"CRDs for %@ = %ld  %ld   %ld ",myCrdLabels[i] ,myCrdsArray[i][0], myCrdsArray[i][1], myCrdsArray[i][2]   );
            SCNNode *mySphereNode = [SCNNode node];
            SCNSphere *mySphere = [SCNSphere sphereWithRadius:mySphereRadius];
            mySphere.firstMaterial.diffuse.contents = [UIColor redColor];
            mySphere.firstMaterial.specular.contents = [UIColor whiteColor];
            mySphere.firstMaterial.shininess = 100.0;
            [mySphereNode setGeometry:mySphere];
            [mySphereNode setPosition:SCNVector3Make(myCrdsArray[i][0], myCrdsArray[i][1], myCrdsArray[i][2])];
            [scene.rootNode addChildNode:mySphereNode];
            
            
            SCNNode *myTextNode = [SCNNode node];
            SCNText *myText = [SCNText textWithString:myCrdLabels[i] extrusionDepth:1.0];
            NSLog(@"MyText = %@",myText);
            [myTextNode setPosition:SCNVector3Make(myCrdsArray[i][0], myCrdsArray[i][1], myCrdsArray[i][2])];
            [myTextNode setGeometry:myText];
            [myTextNode setScale:SCNVector3Make(0.5, 0.5, 0.5)];
            [scene.rootNode addChildNode:myTextNode];
            
            
            SCNNode *myCylinderNode = [SCNNode node];
            SCNCylinder *myCylinder = [SCNCylinder cylinderWithRadius:0.25 height:  labs(myCrdsArray[i][1]) ];
            [myCylinderNode setGeometry:myCylinder];
            myCylinder.firstMaterial.specular.contents = [UIColor darkGrayColor];
            myCylinder.firstMaterial.ambient.contents = [UIColor darkGrayColor];
            [myCylinderNode setPosition:SCNVector3Make(myCrdsArray[i][0], myCrdsArray[i][1]/2, myCrdsArray[i][2])];
            [scene.rootNode addChildNode:myCylinderNode];

            
            
            
        }
        
        
        // rz set up a floor here
        SCNFloor *myFloor = [SCNFloor floor];
        myFloor.reflectionFalloffEnd = 5.0;
        myFloor.reflectionFalloffStart = 1.0;
        myFloor.reflectivity = 0.5;
//        myFloor.firstMaterial.diffuse.contents = [UIColor darkGrayColor];
//        myFloor.firstMaterial.ambient.contents = [UIColor darkGrayColor];
        myFloor.firstMaterial.doubleSided = YES;
        myFloor.firstMaterial.transparency = 0.5;
        scene.rootNode.geometry = myFloor;
        myFloor.firstMaterial.diffuse.contents = @"Pattern_Grid_16x16.png";
        myFloor.firstMaterial.locksAmbientWithDiffuse = YES;
        
        
        // add a tap gesture recognizer
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        NSMutableArray *gestureRecognizers = [NSMutableArray array];
        [gestureRecognizers addObject:tapGesture];
        [gestureRecognizers addObjectsFromArray:scnView.gestureRecognizers];
        scnView.gestureRecognizers = gestureRecognizers;
        
    }
    
}




-(void)myPinchInAction{
    //
    // rz use this swipe gesture recognizer action to move the camera
    //
    SCNView *scnView = (SCNView *)self.view;
    SCNNode *myPOVNode = [[SCNNode alloc] init];
    [myPOVNode setPosition:SCNVector3Make(0, -10, 10)];
    [scnView setPointOfView:myPOVNode];
}

-(void)myPinchOutAction{
    
    SCNView *scnView = (SCNView *)self.view;
    SCNNode *myPOVNode = [[SCNNode alloc] init];
    [myPOVNode setPosition:SCNVector3Make(0, 10, 10)];
    [scnView setPointOfView:myPOVNode];
    
}




- (void) handleTap:(UIGestureRecognizer*)gestureRecognize
{
    // retrieve the SCNView
    SCNView *scnView = (SCNView *)self.view;
    
    // check what nodes are tapped
    CGPoint p = [gestureRecognize locationInView:scnView];
    NSArray *hitResults = [scnView hitTest:p options:nil];
    
    // check that we clicked on at least one object
    if([hitResults count] > 0){
        // retrieved the first clicked object
        SCNHitTestResult *result = [hitResults objectAtIndex:0];
        
        // get its material
        SCNMaterial *material = result.node.geometry.firstMaterial;
        
        // highlight it
        [SCNTransaction begin];
        // rz make this duration fast to flash
        [SCNTransaction setAnimationDuration:0.01];
        
        // on completion - unhighlight
        [SCNTransaction setCompletionBlock:^{
            [SCNTransaction begin];
            // rz make this duration fast to flash
            [SCNTransaction setAnimationDuration:0.01];
            
            material.emission.contents = [UIColor blackColor];
            
            [SCNTransaction commit];
        }];
        
        material.emission.contents = [UIColor redColor];
        
        [SCNTransaction commit];
    }
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
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
    // Release any cached data, images, etc that aren't in use.
}

@end
