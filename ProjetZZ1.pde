int image_size = 50;
int image_pixel_count = image_size * image_size;

TrainingExemple testing_set[];
int testing_set_count = 500;

int training_per_session = 100000;

Network neuralnet;
int hidden_layer_count = 30;

boolean train = false;
boolean test = false;

int display_pixel_size;

boolean b_TEST = false;
boolean test_hidden_count = false;

boolean test_to_99_percent = false;

boolean loadSavedNetwork = false;

int i = 10;

String file_content[] = new String[1];

void setup(){
  
  
  size(1600,900);
  display_pixel_size = floor(((height / image_size)));
  
  //Initialize the neural network;
  neuralnet = new Network(image_pixel_count ,hidden_layer_count ,SHAPE_COUNT);
  
  //Generate the testing exemple pool (optional)
  testing_set = new TrainingExemple[testing_set_count];
  for(int i = 0; i < testing_set_count; i++){
     int r = int(random(100));
     if (r < 25){
        testing_set[i] = new TrainingExemple(image_size, RECTANGLE);
     }
     else if(r < 50){
       testing_set[i] = new TrainingExemple(image_size, CIRCLE);
     }
     else if(r < 75){
       testing_set[i] = new TrainingExemple(image_size, TRIANGLE);
     }
     else{
        testing_set[i] = new TrainingExemple(image_size, RANDOM);
     }
  }
  
  if (loadSavedNetwork){
    neuralnet.loadNetwork("network_weights.txt");
    println("Loaded saved network !");
    println(neuralnet.m_output_layer[3].m_weights[9]);
  }
  
}

void draw(){
  
      if (test){
          int row = (int) floor(random(0,testing_set_count));
          int guess = neuralnet.guess(testing_set[row].m_inputs);
          
          display_guess(testing_set[row], guess);
          test = false;
          b_TEST = false;
      }
      else if(train){
          TrainingExemple ex = new TrainingExemple(image_size, RECTANGLE);
          
          for (int i = 0; i < training_per_session; i++) {
            // select a random training input and train
            ex.generate();
            
            neuralnet.guess(ex.m_inputs);
            neuralnet.train(ex.m_outputs);
            
          }
      
        background(0,255,0);
        textSize(20);
        fill(0);
        text("Finished training", 730, 440);
        
        train = false;
    }
    
    if (test_hidden_count){
      
      test_network();
      test_hidden_count = false;
    }
    
    if (test_to_99_percent){
      println("Starting training");
      train_to_x_percent(neuralnet, image_size, 0.99);
      test_to_99_percent = false;
      background(0,255,0);
      textSize(20);
      fill(0);
      text("Finished training", 730, 440);
    }
  
}


void mousePressed() 
{
  if (mouseButton == LEFT) {
    test = true;
    background(255,255,255);
    b_TEST = true;
  }
  else {
    train = true;
    background(255,0,0);
  }
}

void keyPressed(){
   if (key == 's'){
     neuralnet.saveNetwork("network_weights.txt");
     println("Network saved !");
   }
}


void display_guess(TrainingExemple exemple, int guess){
    pushMatrix();
    stroke(0);
    strokeWeight(2);
    for (int i = 0; i < image_size; i++){
       for(int j = 0; j < image_size; j++){
           if (exemple.m_inputs[i*image_size + j] == 1)
             fill(0);
           else 
             fill(255);
             
           rect(j*display_pixel_size, i*display_pixel_size, display_pixel_size, display_pixel_size);  
       }
    }
    
    String reponseString;
    
    switch (guess){
      case RANDOM:
        reponseString = "Random";
        break;
      case RECTANGLE:
        reponseString = "Rectangle";
        break;
      case CIRCLE:
        reponseString = "Circle";
        break;
      case TRIANGLE:
        reponseString = "Triangle";
        break;
      default:
        reponseString = "Error";
    }
    
    fill(0);
    textSize(20);
    text(reponseString, 1200, 440);
    popMatrix();
}