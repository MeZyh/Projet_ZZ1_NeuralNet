static final int TRAINING_PER_LOOP = 10000;
static final int TRAINING_COUNT_FOR_AVERAGE = 10;
static final int MAX_ITERATIONS = 10000000;

static final int MIN_HIDDEN_COUNT = 5;
static final int MAX_HIDDEN_COUNT = 50;
static final int HIDDEN_COUNT_STEP = 1;

static final int MIN_IMG_SIZE = 50;
static final int MAX_IMG_SIZE = 200;
static final int IMG_SIZE_STEP = 10;



static final float TARGET_PERCENTAGE = 0.85;



void test_network(){
    
    String file_name;
    String file_content[] = new String[1];
    String result_string;
    long training_time;
    int avg_training;
    long start, end;
    
    for(int i = MIN_IMG_SIZE; i < MAX_IMG_SIZE; i+=IMG_SIZE_STEP){
      file_name = "results/result"+i+".txt";
      file_content[0] = "";
      
      println("Testing images of size "+i);
      
      for(int j = MIN_HIDDEN_COUNT; j < MAX_HIDDEN_COUNT; j+=HIDDEN_COUNT_STEP){
        println("Testing for "+j+" hidden neurons");
        start = millis();
        avg_training = average_training_iterations(i, SHAPE_COUNT, j, TARGET_PERCENTAGE);
        end = millis();
        
        training_time = (end - start) / TRAINING_COUNT_FOR_AVERAGE;
        
        result_string = j + " " + avg_training + " " + training_time + "\n";
        
        if (file_content[0].isEmpty()){
          file_content[0] = result_string;  
        }
        else{
          file_content[0] += result_string;    
        }
        
        saveStrings(file_name, file_content);
      }
      
    }
    
}

int average_training_iterations(int img_size, int shape_count, int hidden_layer_size, float target_percentage){
    Network neuralnet;
    int sum_iterations = 0;
  
    for(int j = 0; j < TRAINING_COUNT_FOR_AVERAGE; j++){
      println("Testing number "+j);
      neuralnet = new Network(img_size*img_size, hidden_layer_size, shape_count);
      sum_iterations += train_to_x_percent(neuralnet, img_size, target_percentage);   
    }
    
    return sum_iterations / TRAINING_COUNT_FOR_AVERAGE;
}

int train_to_x_percent(Network neuralnet, int img_size, float target_percentage){
    int iterations = 0;
    float correct_percent = rate_network(neuralnet, img_size);
  
    while(correct_percent < target_percentage && iterations < MAX_ITERATIONS){
              
      train_x_times(neuralnet, img_size, TRAINING_PER_LOOP);
     
      iterations += TRAINING_PER_LOOP;
      correct_percent = rate_network(neuralnet, img_size);   
      println("Current success percentage : " + correct_percent);
    }
    
    return iterations;
}

void train_x_times(Network neuralnet, int img_size, int x){
    TrainingExemple ex = new TrainingExemple(img_size, DEFAULT);
    for (int i = 0; i < training_per_session; i++) {
      ex.generate();
      
      neuralnet.guess(ex.m_inputs);
      neuralnet.train(ex.m_outputs);
    }
}

float rate_network(Network neuralnet, int img_size){
    TrainingExemple ex = new TrainingExemple(img_size, DEFAULT);
    int sample_size = 1000;
    int correct_count = 0;
    int guess;
    
    for(int i = 0; i < sample_size; i++){
       ex.generate();
       guess = neuralnet.guess(ex.m_inputs);
       
       if(guess == ex.m_output)
         correct_count++;
    }
    
    return ((float) correct_count) / sample_size;
}