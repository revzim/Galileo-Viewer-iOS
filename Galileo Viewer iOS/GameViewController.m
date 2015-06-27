//
//  GameViewController.m
//  rzGalileo
//
//  Created by Robert Zimmelman on 5/16/15.
//  Public Domain 2015 Robert Zimmelman under GPL
//

#import "GameViewController.h"

float mySphereRadius = 1.5 ;
float myMaxX = 0.0;
float myMaxY = 0.0;
float myMaxZ = 0.0;

float myMaxVal = 0.0;
int myDataSet = 6;

int myLineSkip =  0;

int myCrdLineCount = 0;

// DATA HEADER LENGTH IS 19 CHARACTERS, SEE BELOW
//(8F10.4)   15 10 17
int myGalileoDataHeaderLength = 19;


@implementation GameViewController
{
}




- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString *myFormatString = @"(8F10.4)";
    NSString *myDimString = @"";
    NSString *myConString = @"";
    int myDimensions = 0;
    int myConceptCount = 0;
    int myCrdsPerLine = 8; // see assignment of myFormatString above (fortran format)
    int myCrdsLength = 10; //see assignment of myFormatString above (fortran format)
    int myCrdsDecimalPlaces = 4; // see assignment of myFormatString above (fortran format)
    
    //    BOOL  myRemoteData = YES;
    
    // ******************************************************************************
    //
    //
    
    //
    //
    //
    // ******************************************************************************
    // rz local data
    //
    //        NSString *myFolderPath = [[[NSBundle mainBundle] resourcePath]
    //                                  stringByAppendingPathComponent:@""];
    //        NSMutableString *myEditPath = [NSMutableString stringWithFormat:@"%@/wk%iallresponsesROT.crd.txt",  myFolderPath, myDataSet];
    //    NSURL *url = [NSURL fileURLWithPath:myEditPath];
    
    //
    //
    // rz end local data
    // ******************************************************************************
    //
    
    // rz remote data
    //
    //    http://robzimmelman.tripod.com/Galileo/
    //
    
    //     http://www.acsu.buffalo.edu/~woelfel/DATA/data.crd.txt
    
    
    //            NSMutableString *myEditPath = [NSMutableString stringWithFormat:@"http://robzimmelman.tripod.com/Galileo/barnett.crd.txt"];
    
    
    
    //        NSMutableString *myEditPath = [NSMutableString stringWithFormat:@"http://robzimmelman.tripod.com/Galileo/wk%iallresponsesROT.crd.txt", myDataSet];
    NSMutableString *myEditPath = [NSMutableString stringWithFormat:@"http://www.acsu.buffalo.edu/~woelfel/DATA/data.crd.txt"];
    NSURL *myURL = [NSURL URLWithString:myEditPath];
    
    
    NSError *myError;
    
    NSString *stringFromFile = [NSString stringWithContentsOfURL:myURL encoding:NSUTF8StringEncoding error:NULL];
    
    //
    //  rz end remote data
    // ******************************************************************************
    //
    //
    
    
    //        NSNumber *myNextNum = 0;
    
    NSLog(@"myEditPath = %@",myEditPath);
    
    
    if (stringFromFile == nil) {
        // an error occurred
        NSLog(@"Error reading file at %@\n%@",
              myURL, [myError localizedFailureReason]);
    }
    else {
        myFormatString = [stringFromFile substringWithRange: NSMakeRange(0, 8)];
        myCrdsPerLine =  [myFormatString substringWithRange:NSMakeRange(1, 1)].intValue;
        myCrdsLength = [myFormatString substringWithRange:NSMakeRange(3,2 )].intValue;
        myCrdsDecimalPlaces = [myFormatString substringWithRange:NSMakeRange(6, 1)].intValue;
        
        NSLog(@"MyCrds Length = %d, MyCrdsPerLine = %d, myCrdsDecimalPlaces = %d", myCrdsLength,myCrdsPerLine, myCrdsDecimalPlaces);
        
        // DATA HEADER LENGTH IS 19 CHARACTERS, SEE BELOW
        //(8F10.4)   15 10 17
        
        
        //(8F10.4) 105 76125
        //(8F10.4)   15 10 17
        //(6F12.4) 105 64105
        // rz new galileo format?
        // needed for the larger datasets.
        myDimString = [stringFromFile substringWithRange: NSMakeRange(17, 3)];
        myConString = [stringFromFile substringWithRange: NSMakeRange(11, 3)];
        //
        // rz works for first datasets supplied and the dataset from Carolyn
        //        myDimString = [stringFromFile substringWithRange: NSMakeRange(17, 2)];
        //        myConString = [stringFromFile substringWithRange: NSMakeRange(11, 2)];
        myDimensions = [myDimString intValue];
        myConceptCount = [myConString intValue];
        NSArray *myFileLines = [stringFromFile componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
        //        NSLog(@"myFileLines = %@",myFileLines);
        //
        NSMutableArray *myWorkLines = [NSMutableArray arrayWithArray:myFileLines];
        NSInteger myLineCount = [myFileLines count];
        
        for (int i = 0 ; i < myLineCount; i++) {
            if ([myFileLines [i] length] == 0 ) {
                [myWorkLines removeObject:myFileLines[i]];
            }
        }
        NSUInteger myWorkLineCount = [myWorkLines count] ;
        NSLog(@"myWorkLineCount = %lu",(unsigned long)myWorkLineCount);
        
        //            for (int i = 0 ; i < myWorkLineCount; i++) {
        //                NSLog(@"Line %i: %@", i , myWorkLines[i]);
        //            }
        
        
        
        
        //            for (int i = 0 ; i < myConceptCount; i++) {
        //                NSLog(@"Concept %i = %@", i + 1 , myCrdLabels[i] );
        //            }
        
        NSLog(@"Dims: %i",myDimensions);
        NSLog(@"Cons: %i",myConceptCount);
        long myTitleLength = 0;
        myTitleLength = [[myFileLines objectAtIndex:0] length ] - myGalileoDataHeaderLength;
        NSLog(@"Title length = %ld",myTitleLength);
        NSMutableString *myEditedTitleString = [NSMutableString stringWithString:@""];
        
        
        if (myTitleLength > 0) {
            NSString *myTitleString = [[myFileLines objectAtIndex:0] substringFromIndex:myGalileoDataHeaderLength];
            myEditedTitleString = [NSMutableString stringWithString:myTitleString];
            NSLog(@"BEFORE REPLACE, Title Is: %@",myEditedTitleString);
            [myEditedTitleString replaceOccurrencesOfString:@"    " withString:@"" options:NSLiteralSearch range:NSMakeRange(1, myTitleString.length - 1)];
        }
        else{
            myEditedTitleString = [NSMutableString stringWithString:@""];
        }
        NSLog(@"NOW AFTER REPLACE, Title Is: %@",myEditedTitleString);
        
        NSLog(@"myWorkLineLine Count= %lu",(unsigned long)myWorkLineCount);
        
        NSArray *myCrdLines = [ myWorkLines objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange: NSMakeRange( 1, myWorkLineCount  - myConceptCount - 1)]   ];
        double myTempX = 0;
        double myTempY = 0;
        double myTempZ = 0;
        int j = 0;
        double myCrdsArray[200][3];
        double myNormalizedCrdsArray[200][3];
        
        // rz we have to skip past the dimensions we're not interested in
        //
        double myTempLineSkip = (double)  myDimensions /  (double) myCrdsPerLine;
        myLineSkip =  ceil(myTempLineSkip);
        NSLog(@"myTempLineSkip = %f",myTempLineSkip);
        
        NSLog(@"myLineSkip = %d",myLineSkip);
        
        myCrdLineCount = myConceptCount * myLineSkip;
        NSLog(@"myCrdLineCount = %d",myCrdLineCount);
        
        for (int i = 0; i < myConceptCount; i++) {
            NSLog(@"In Loop.  i = %d",i);
            j = i * myLineSkip;
            NSLog(@"myCrdLines[j]= %@", myCrdLines[j] );
            NSArray *myTempArray = [NSArray arrayWithObjects:myCrdLines[j], nil];
            NSString *myTempString = [[ myTempArray valueForKey:@"description"] componentsJoinedByString:@""];
            myTempX = [[myTempString substringWithRange:NSMakeRange(0, myCrdsLength)] floatValue] ;
            myTempY = [[myTempString substringWithRange:NSMakeRange(myCrdsLength + 1, myCrdsLength)] floatValue] ;
            myTempZ = [[myTempString substringWithRange:NSMakeRange((myCrdsLength * 2 ) + 1, myCrdsLength)] floatValue] ;
            
            
            
            
            
            NSLog(@"X= %f, Y= %f, Z= %f" , myTempX , myTempY , myTempZ);
            myCrdsArray[i][0] =  myTempX;
            myCrdsArray[i][1] =  myTempY;
            myCrdsArray[i][2] =  myTempZ;
            
            //
            // rz for very dense datset with all values between 0 and 2
            //
            //            myCrdsArray[i][0] =  myTempX * 25 ;
            //            myCrdsArray[i][1] =  myTempY * 25 ;
            //            myCrdsArray[i][2] =  myTempZ * 25 ;
            
            // rz find out largest X, Y and Z values
            if (myTempX > myMaxX) {
                myMaxX = myTempX;
            }
            if (myTempY > myMaxY) {
                myMaxY = myTempY;
            }
            if (myTempZ > myMaxZ) {
                myMaxZ = myTempZ;
            }
            // rz find out maxVal
            
            if (myTempX > myMaxVal) {
                myMaxVal = myTempX;
            }
            if (myTempY > myMaxVal) {
                myMaxVal = myTempY;
            }
            if (myTempX > myMaxVal) {
                myMaxVal = myTempZ;
            }
            
        }
        
        
        // rz now normalize the values to a max of 100
        //
        //
        
        double myNormalizeMult = 100 / myMaxVal;
        
        for (int i = 0; i < myConceptCount; i++) {
            myNormalizedCrdsArray[i][0] = myCrdsArray[i][0] * myNormalizeMult;
            myNormalizedCrdsArray[i][1] = myCrdsArray[i][1] * myNormalizeMult;
            myNormalizedCrdsArray[i][2] = myCrdsArray[i][2] * myNormalizeMult;
        }
        
        //   rz here is the SceneKit Stuff
        //
        //
        //
        
        NSLog(@"About to Create Scene");
        
        // create a new scene
        SCNScene *scene = [SCNScene sceneNamed:@"art.scnassets/GalileoScene.dae"];
        
        // rz put some fog just in the middle of the scene so we can see it in real time
        //
        scene.fogColor = [UIColor whiteColor];
        scene.fogStartDistance = 50.0;
        scene.fogEndDistance = 5000.0;
        scene.fogDensityExponent = 0.5;
        
        
        
        // create and add a camera to the scene
        SCNNode *cameraNode = [SCNNode node];
        cameraNode.camera = [SCNCamera camera];
        [scene.rootNode addChildNode:cameraNode];
        
        // place the camera
        // rz place the camera at a position to reflect the max as 100
        //
        //
        //
        cameraNode.position = SCNVector3Make(0, 75, 125);
        //
        //
        // rz here is where the camera should be
        //
        //        cameraNode.position = SCNVector3Make(0, myMaxY * 2, myMaxZ * 4);
        // here is where the camera is for the demo set
        //        cameraNode.position = SCNVector3Make(0, myMaxY /4  , myMaxZ);
        //
        //
        //
        //
        // rz put camera here for very dense scene
        //
        //        cameraNode.position = SCNVector3Make(0, myMaxY * 20 , myMaxZ * 30);
        cameraNode.camera.yFov = 120.0;
        cameraNode.camera.zFar = 5000.0;
        
        [cameraNode setName:@"camera"];
        
        
        
        // create and add a light above the floor
        
        SCNLight *myTopLight = [SCNLight light];
        [myTopLight setType:SCNLightTypeOmni];
        [myTopLight setColor:[UIColor whiteColor]];
        
        SCNNode *topLightNode = [SCNNode node];
        [topLightNode setPosition: SCNVector3Make(0, 300, 200)];
        [topLightNode setLight:myTopLight];
        [scene.rootNode addChildNode:topLightNode];
        
        
        // create and add a second light above the floor
        SCNNode *topLightNode2 = [SCNNode node];
        [topLightNode2 setPosition: SCNVector3Make(0, 300, -300)];
        [topLightNode2 setLight:myTopLight];
        [scene.rootNode addChildNode:topLightNode2];
        
        
        
        // create and add a light below the floor
        SCNNode *bottomLightNode = [SCNNode node];
        bottomLightNode.light = [SCNLight light];
        bottomLightNode.light.type = SCNLightTypeOmni;
        //        bottomLightNode.light.attenuationEndDistance = 1000.0;
        bottomLightNode.position = SCNVector3Make(0, -200, -100);
        bottomLightNode.light.color = [UIColor lightGrayColor];
        [scene.rootNode addChildNode:bottomLightNode];
        
        //        NSLog(@"myWorkLines = %@",myWorkLines);
        
        
        //        NSArray *myCrdLabels = [ myWorkLines objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange: NSMakeRange( myWorkLineCount - myConceptCount , myConceptCount)] ];
        NSArray *myCrdLabels = [ myWorkLines objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange: NSMakeRange( myCrdLineCount + 1, myConceptCount)] ];
        
        NSLog(@"myCrdLabels = %@",myCrdLabels);
        
        
        
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
        NSLog(@"MyTitleLength = %ld",myTitleLength);
        if (myTitleLength > 0) {
            
            // rz display the title somewhere
            SCNText *myTitleGeometry = [SCNText textWithString:myEditedTitleString extrusionDepth:1.0];
            SCNNode *myTitleNode = [SCNNode nodeWithGeometry:myTitleGeometry];
            [myTitleNode setScale:SCNVector3Make(2, 2, 2)];
            [myTitleGeometry.firstMaterial setTransparency:0.5];
            
            [myTitleGeometry.firstMaterial setShininess:1.0];
            
            [myTitleGeometry.firstMaterial.specular setContents:[UIColor blueColor]];
            [myTitleGeometry.firstMaterial.ambient setContents:[UIColor blueColor]];
            [myTitleGeometry setSubdivisionLevel:2];
            //
            //
            //  rz place title according to normalized maxval of 100
            //
            [myTitleNode setPosition:SCNVector3Make(  100 * -2.0 , 100 * 1.2 , 100 * -1.2 )];
            //            [myTitleNode setPosition:SCNVector3Make(  myMaxX * -2.0 , myMaxY * 1.2 , myMaxZ * -1.2 )];
            [scene.rootNode addChildNode:myTitleNode];
            
        }
        
        
        // rz make the spheres and cylinders and text for the concepts
        for (int i = 0; i < myConceptCount; i++) {
            NSLog(@"CRDs for %@ = %f  %f   %f ",myCrdLabels[i] ,myNormalizedCrdsArray[i][0], myNormalizedCrdsArray[i][1], myNormalizedCrdsArray[i][2]   );
            SCNNode *mySphereNode = [SCNNode node];
            SCNSphere *mySphere = [SCNSphere sphereWithRadius:mySphereRadius];
            mySphere.firstMaterial.diffuse.contents = [UIColor redColor];
            mySphere.firstMaterial.specular.contents = [UIColor whiteColor];
            mySphere.firstMaterial.shininess = 1.0;
            //            [mySphereNode setCastsShadow:YES];
            [mySphereNode setGeometry:mySphere];
            [mySphereNode setPosition:SCNVector3Make(myNormalizedCrdsArray[i][0], myNormalizedCrdsArray[i][1], myNormalizedCrdsArray[i][2])];
            [scene.rootNode addChildNode:mySphereNode];
            
            
            SCNNode *myTextNode = [SCNNode node];
            SCNText *myText = [SCNText textWithString:myCrdLabels[i] extrusionDepth:2.0];
            myText.firstMaterial.shininess = 0.75;
            [myText setChamferRadius:0.25];
            [myText setSubdivisionLevel:1];
            //            SCNLookAtConstraint *myConstraint = [SCNLookAtConstraint lookAtConstraintWithTarget:cameraNode];
            //            NSArray *myConstraintArray = [NSArray arrayWithObjects:myConstraint, nil];
            //            myTextNode.constraints = myConstraintArray;
            //NSLog(@"MyText = %@",myText);
            [myTextNode setPosition:SCNVector3Make(myNormalizedCrdsArray[i][0], myNormalizedCrdsArray[i][1], myNormalizedCrdsArray[i][2])];
            [myTextNode setGeometry:myText];
            [myTextNode setScale:SCNVector3Make(0.5, 0.5, 0.5)];
            [scene.rootNode addChildNode:myTextNode];
            
            
            SCNNode *myCylinderNode = [SCNNode node];
            SCNCylinder *myCylinder = [SCNCylinder cylinderWithRadius:0.25 height:  fabs(myNormalizedCrdsArray[i][1]) ];
            [myCylinderNode setGeometry:myCylinder];
            myCylinder.firstMaterial.specular.contents = [UIColor darkGrayColor];
            myCylinder.firstMaterial.ambient.contents = [UIColor darkGrayColor];
            [myCylinderNode setPosition:SCNVector3Make(myNormalizedCrdsArray[i][0], myNormalizedCrdsArray[i][1]/2, myNormalizedCrdsArray[i][2])];
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
        myFloor.firstMaterial.transparency = 0.35;
        scene.rootNode.geometry = myFloor;
        //        myFloor.firstMaterial.diffuse.contents = @"Pattern_Grid_16x16.png";
        myFloor.firstMaterial.diffuse.contents = @"unnamed.png";
        //        myFloor.firstMaterial.diffuse.contents = @"8x8_binary_grid_small.png";
        
        myFloor.firstMaterial.locksAmbientWithDiffuse = YES;
        
        
        
        
        
        // add a tap gesture recognizer
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        NSMutableArray *gestureRecognizers = [NSMutableArray array];
        [gestureRecognizers addObject:tapGesture];
        [gestureRecognizers addObjectsFromArray:scnView.gestureRecognizers];
        scnView.gestureRecognizers = gestureRecognizers;
        
    }
    
}





- (void) handleTap:(UIGestureRecognizer*)gestureRecognize
{
    // retrieve the SCNView
    SCNView *scnView = (SCNView *)self.view;
    if (myDataSet < 9 ) {
        myDataSet++;
    }
    else{
        myDataSet = 1;
    }
    
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
    // Release any cached data, images, etc that aren't in use.
}


-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
}



@end



