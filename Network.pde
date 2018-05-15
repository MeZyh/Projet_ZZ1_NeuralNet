// Simple neural nets: network
// (c) Alasdair Turner 2009

// Free software: you can redistribute this program and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.

// This class is for the neural network,
// which is hard coded with three layers:
// input, hidden and output

class Network
{
  // this network is hard coded to only have one hidden layer
  Neuron[] m_input_layer; 
  Neuron[] m_hidden_layer;
  Neuron[] m_output_layer;
  // create a network specifying numbers of inputs, hidden layer neurons
  // and number of outputs, e.g. Network(4,4,3)
  Network(int inputs, int hidden, int outputs)
  {
    m_input_layer = new Neuron [inputs];
    m_hidden_layer = new Neuron [hidden];
    m_output_layer = new Neuron [outputs];
    // set up the network topology
    for (int i = 0; i < m_input_layer.length; i++) {
      m_input_layer[i] = new Neuron();
    }
    // route the input layer to the hidden layer
    for (int j = 0; j < m_hidden_layer.length; j++) {
      m_hidden_layer[j] = new Neuron(m_input_layer);
    }
    
    for (int k = 0; k < m_output_layer.length; k++) {
      m_output_layer[k] = new Neuron(m_hidden_layer);
    } 
  }
  int guess(float [] inputs)
  {
    float [] responses = new float [m_output_layer.length];
    // feed forward
    // simply set the input layer to display the inputs
    for (int i = 0; i < m_input_layer.length; i++) {
      m_input_layer[i].m_output = inputs[i];
    }
    // now feed forward through the hidden layer
    for (int j = 0; j < m_hidden_layer.length; j++) {
      m_hidden_layer[j].guess();
    }
    
    // and finally feed forward to the output layer
    for (int k = 0; k < m_output_layer.length; k++) {
      responses[k] = m_output_layer[k].guess();
    }
    
    // now check the best response:
    int guess = -1;
    float best = max(responses);
    for (int a = 0; a < responses.length; a++) {
      if (responses[a] == best) {
        guess = a;
      }
    }
    
    return guess;
  }
  void train(float [] outputs)
  {
    // adjust the output layer
    for (int k = 0; k < m_output_layer.length; k++) {
      m_output_layer[k].finderror(outputs[k]);
      m_output_layer[k].train();
    }
    
    // propagate back to the hidden layer
    for (int j = 0; j < m_hidden_layer.length; j++) {
      m_hidden_layer[j].train();
    }
    // the input layer doesn't learn:
    // it is simply the inputs
  }
  
  void saveNetwork(String path){
     String[] result = new String[1];
     result[0] = "";
     
     for(int i = 0; i < m_hidden_layer.length;  i++){
       for(int j = 0; j < m_hidden_layer[i].m_weights.length; j++){
         result[0] += m_hidden_layer[i].m_weights[j] + " "; 
       }
     }
     
     for(int i = 0; i < m_output_layer.length;  i++){
       for(int j = 0; j < m_output_layer[i].m_weights.length; j++){
         result[0] += m_output_layer[i].m_weights[j] + " "; 
       }
     }
     
     saveStrings(path, result);
  }
  
  void loadNetwork(String path){
    int count_pos = 0;
    BufferedReader reader = createReader(path);
    try{
      String line = reader.readLine();
      String[] weights = line.split(" ");
      
      for(int i = 0; i < m_hidden_layer.length;  i++){
       for(int j = 0; j < m_hidden_layer[i].m_weights.length; j++){
         m_hidden_layer[i].m_weights[j] = parseFloat(weights[count_pos]); 
         count_pos++;
       }
     }
     
     for(int i = 0; i < m_output_layer.length;  i++){
       for(int j = 0; j < m_output_layer[i].m_weights.length; j++){
         m_output_layer[i].m_weights[j] = parseFloat(weights[count_pos]); 
         count_pos++;
       }
     }
      
    }catch(IOException e){
      e.printStackTrace(); 
    }
  }
}