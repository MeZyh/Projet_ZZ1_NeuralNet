float LEARNING_RATE = 0.01;

class Neuron
{
  Neuron [] m_inputs;
  float [] m_weights;
  float m_bias;
  float m_output;
  float m_error;
  // the input layer of neurons have no inputs:
  Neuron()
  {
    m_bias = 0.0;
    m_error = 0.0;
    // initial random output
    m_output = sigmoid(random(-5.0,5.0));
  }
  // all other layers (hidden and output) have 
  // neural inputs
  Neuron(Neuron [] inputs)
  {
    m_inputs = new Neuron [inputs.length];
    m_weights = new float [inputs.length];
    for (int i = 0; i < inputs.length; i++) {
      m_inputs[i] = inputs[i];
      m_weights[i] = random(-1.0,1.0);
    }
    m_bias = random(-1.0,1.0);
    m_error = 0.0;
    // initial random output
    m_output = sigmoid(random(-5.0,5.0));
  }
  // respond looks at the layer below, and prepares a response:
  float guess()
  {
    float input = 0.0;
    for (int i = 0; i < m_inputs.length; i++) {
      input += m_inputs[i].m_output * m_weights[i];
    }
    m_output = sigmoid(input + m_bias);
    // reset our error value ready for training
    m_error = 0.0;
    return m_output;
  }
  // find error is used on the output neurons
  void finderror(float desired)
  {
    m_error = desired - m_output;
  }
  // train adjusts the weights by comparing actual output to correct output
  void train()
  {
    float delta = (1.0 - m_output) * (1.0 + m_output) * m_error * LEARNING_RATE;
    for (int i = 0; i < m_inputs.length; i++) {
      // tell the next layer down what it's doing wrong
      m_inputs[i].m_error += m_weights[i] * m_error;
      // correct our weights
      m_weights[i] += m_inputs[i].m_output * delta;
    }
  }
}