static final int SHAPE_COUNT = 4;

static final int DEFAULT = -1;
static final int RANDOM = 0;
static final int RECTANGLE = 1;
static final int CIRCLE = 2;
static final int TRIANGLE = 3;

final int rect_noise = 7;
final int circ_noise = 7;
final int tri_noise = 7;


class TrainingExemple{
  
   int m_output;
   float m_inputs[];
   float m_outputs[];
   
   int m_img_size;
  
   TrainingExemple(int img_size, int shape){
   m_img_size = img_size;
     
     switch(shape){
        case DEFAULT:
          this.generate();
          break;
        case RANDOM:
          this.generateRandom();
          break;
        case RECTANGLE:
          this.generateRectangle(rect_noise);
          break;
        case CIRCLE:
          this.generateCircle(circ_noise);
          break;
        case TRIANGLE:
          this.generateTriangle(tri_noise);
          break;  
     }
   };
   
   
   
   public void generate(){
     int r = int(random(3));
     if (r == 0){
        this.generateRectangle(rect_noise);
     }
     else if(r == 1){
       this.generateCircle(circ_noise);
     }
     else if(r == 2){
       this.generateTriangle(tri_noise);
     }
     else if(r == 3){
       this.generateRandom();
     }
   }
   
   
   
   
   public void generateRandom(){
      m_output = RANDOM;
      
      m_outputs = new float[SHAPE_COUNT];
      for(int i = 0; i < SHAPE_COUNT; i++){
         m_outputs[i] = i == RANDOM ? 1 : 0; 
      }
      
      m_inputs = new float[m_img_size*m_img_size];
      
      int r;
      for(int i = 0; i < m_img_size; i++){
        for(int j = 0; j < m_img_size; j++){
            r = (int(random(99))) + 1;
            if (r < 20){
               m_inputs[i*m_img_size + j] = 1; 
            }
            else{
               m_inputs[i*m_img_size + j] = 0; 
            }
          
        }
      }
   }
   
   
   
   
   
   public void generateRectangle(int noise_percent){
      m_output = RECTANGLE;
      
      m_outputs = new float[SHAPE_COUNT];
      for(int i = 0; i < SHAPE_COUNT; i++){
         m_outputs[i] = i == RECTANGLE ? 1 : 0; 
      }
      
      m_inputs = new float[m_img_size*m_img_size];
      
      int size = int(random(m_img_size-2)) + 2;
      int xoffset = int(random(m_img_size-size));
      int yoffset = int(random(m_img_size-size));
      
      PGraphics buffer_img = createGraphics(m_img_size, m_img_size);
      buffer_img.beginDraw();
      buffer_img.background(255);
      buffer_img.noFill();
      buffer_img.stroke(0);
      buffer_img.strokeWeight(1);
      buffer_img.rect(xoffset,yoffset,size,size);
      buffer_img.endDraw();
      
      addNoise(buffer_img, m_img_size, m_img_size, noise_percent);
      
      int white = color(255,255,255); 
      for(int i =0; i < m_img_size*m_img_size; i++){
        m_inputs[i] = buffer_img.pixels[i] == white ? 0 : 1;
      }
      
   }
   
   
   
   
   
   
   public void generateCircle(int noise_percent){
       m_output = CIRCLE;
       
       m_outputs = new float[SHAPE_COUNT];
       for(int i = 0; i < SHAPE_COUNT; i++){
         m_outputs[i] = i == CIRCLE ? 1 : 0; 
       }
       
       m_inputs = new float[m_img_size*m_img_size];
       
       int diameter = int(random(m_img_size-3)) + 3;
       int xoffset = int(random(m_img_size-diameter));
       int yoffset = int(random(m_img_size-diameter));
        
        PGraphics buffer_img = createGraphics(m_img_size, m_img_size);
        buffer_img.beginDraw();
        buffer_img.background(255);
        buffer_img.noFill();
        buffer_img.stroke(0);
        buffer_img.strokeWeight(1);
        buffer_img.ellipseMode(CORNER);
        buffer_img.ellipse(xoffset, yoffset, diameter, diameter);
        buffer_img.endDraw();
        
        addNoise(buffer_img, m_img_size, m_img_size, noise_percent);
        
        int white = color(255,255,255);
        for(int i =0; i < m_img_size*m_img_size; i++){
            m_inputs[i] = buffer_img.pixels[i] == white ? 0 : 1;
        }
   }
   
   
   
   
   public void generateTriangle(int noise_percent){
       m_output = TRIANGLE;
       
       m_outputs = new float[SHAPE_COUNT];
       for(int i = 0; i < SHAPE_COUNT; i++){
         m_outputs[i] = i == TRIANGLE ? 1 : 0; 
       }
       
        m_inputs = new float[m_img_size*m_img_size];
        
        int x1 = int(random(m_img_size));
        int y1 = int(random(m_img_size));
        int x2 = int(random(m_img_size));
        int y2 = int(random(m_img_size));
        int x3 = int(random(m_img_size));
        int y3 = int(random(m_img_size));
     
        PGraphics buffer_img = createGraphics(m_img_size, m_img_size);
        buffer_img.beginDraw();
        buffer_img.background(255);
        buffer_img.noFill();
        buffer_img.stroke(0);
        buffer_img.strokeWeight(1);
        buffer_img.triangle(x1, y1, x2, y2, x3, y3);
        buffer_img.endDraw();
        
        addNoise(buffer_img, m_img_size, m_img_size, noise_percent);
        
        int white = color(255,255,255);  
        for(int i =0; i < m_img_size*m_img_size; i++){
            m_inputs[i] = buffer_img.pixels[i] == white ? 0 : 1;
        }
     
   }
   
}


void addNoise(PGraphics image, int image_width, int image_height, int noise_percent)
{
  int black = color(0,0,0);
  
  for(int i =0; i < image_width*image_height; i++){
    int r = int(random(100));
    if (r <= noise_percent && noise_percent != 0)
      image.pixels[i] = black;
  }
}