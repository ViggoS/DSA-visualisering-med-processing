Visualizer v;
Sorter currentSorter;   // interface för olika sorterare
String[] algorithms = {"Bubble Sort", "Insertion Sort", "Quick Sort", "Heap Sort", "Selection Sort"};
String[] listType = {"random", "inverterad", "inkomplett sorterad"};
int selectedAlg= -1;      // (-1 = no algorithm chosen)
int selectedList;
int framerate = 30;
int n = 30;
boolean selectAlg = true;

// using library controlP5 for dropdown menu
import controlP5.*;
ControlP5 cp5; 
DropdownList alg_drop, sort_drop;


void setup() {
  selectedList = 0;  // random list
  size(800, 600);
  // println(selectAlg);

  cp5 = new ControlP5(this);

   // add start button
  cp5.addButton("Start")
     .setValue(0)
     .setPosition(0,0)
     .setSize(width/10, 35)
     ;
     
  // add a dropdownlist at position (100,100)
  alg_drop = cp5.addDropdownList("Algoritm")
                .setPosition(width/10, 0)
                .setSize(2*width/10,200);
                
                
  sort_drop = cp5.addDropdownList("Typ av lista")
                .setPosition(3*width/10, 0)
                .setSize(2*width/10,200);                
                
  customize(alg_drop);
  customize(sort_drop);

  // add items to the drop down lists
  for (int i=0; i<5; i++) {
    alg_drop.addItem(algorithms[i], i);
  }
  for (int i=0; i<3; i++) {
    sort_drop.addItem(listType[i], i);
  }
  
   cp5.addSlider("Antal_element")
     .setPosition(5*width/10, 0)
     .setSize(3*width/10, 35)
     .setRange(5,200)
     .setValue(30)
     ;
     
  cp5.addSlider("framerate_slider")
     .setPosition(8*width/10, 0)
     .setSize(2*width/10, 35)
     .setRange(10,120)
     .setValue(30)
     .setNumberOfTickMarks(22)
     ;
     
 
     
  cp5.getController("framerate_slider").getValueLabel().align(ControlP5.LEFT, ControlP5.BOTTOM).setPaddingX(0);
  cp5.getController("framerate_slider").getCaptionLabel().align(ControlP5.RIGHT, ControlP5.BOTTOM).setPaddingX(0);
  
  cp5.getController("Antal_element").getValueLabel().align(ControlP5.LEFT, ControlP5.BOTTOM).setPaddingX(0);
  cp5.getController("Antal_element").getCaptionLabel().align(ControlP5.RIGHT, ControlP5.BOTTOM).setPaddingX(0);
  
  
}


void draw() {
  background(30);

  // Rita meny
  //drawMenu();
  
  
  // Om ingen algoritm vald ännu
  if (selectedAlg== -1 || currentSorter == null) {
    fill(200);
    textSize(20);
    textAlign(CENTER, CENTER);
    text("Välj en algoritm från menyn ovan", width/2, height/2);
    text("Välj typ av lista och justera framerate", width/2, height/2 + 30);
    text("Starta visualiseringen med 'Start'-knappen eller tryck Enter", width/2, height/2 + 60);
     
    
    if (selectAlg == true){
      fill(255, 50, 50);
      text("Välj en algoritm från menyn ovan", width/2, height/2);
      }  
    return;
    
    
  }
  
  

  // Rita array + kör vald algoritm
  v.display();

  if (!currentSorter.isFinished()) {
    currentSorter.step();
  } else {
    fill(0, 200, 0);
    textSize(20);
    textAlign(LEFT, TOP);
    text(algorithms[selectedAlg] + " klar!", 20, 40);
  }
}

/* ----------------- Meny ----------------- */
void Start() {
  println("Start button pressed");
  if (selectedAlg != -1){
  resetSorter();
  } 
  else {selectAlg = !selectAlg;}  // switch 
  
}

void keyPressed() {

  if (keyCode == ENTER) {
    Start();
  }
}

// controlEvent monitors clicks on the gui
void controlEvent(ControlEvent theEvent) {
  if (theEvent.isGroup()) {
    println(theEvent.getGroup() + " => " + theEvent.getGroup().getValue());
  }
  if (theEvent.getController() == alg_drop){
    if(theEvent.getController().getValue() == 0.0) {
      println("Bubble Sort");
      selectedAlg = 0;}
    else if(theEvent.getController().getValue() == 1.0) {
      println("Insertion Sort");
      selectedAlg = 1;}
    else if(theEvent.getController().getValue() == 2.0) {
      println("Quick Sort");
      selectedAlg = 2;}
    else if(theEvent.getController().getValue() == 3.0) {
      println("Heap Sort");
      selectedAlg = 3;}
    else if(theEvent.getController().getValue() == 4.0) {
      println("Selection Sort");
      selectedAlg = 4;}
  }
  else if (theEvent.getController() == sort_drop){
    if(theEvent.getController().getValue() == 0.0) {
      println("Random");
      selectedList = 0;}
    else if(theEvent.getController().getValue() == 1.0) {
      println("Iverterad");
      selectedList = 1;}
    else if(theEvent.getController().getValue() == 2.0) {
      println("Inkomplett iverterad");
      selectedList = 2;}
  }
}

void customize(DropdownList ddl) {
 
  ddl.setBackgroundColor(color(190));
  ddl.setItemHeight(20);
  ddl.setBarHeight(35);
 
  ddl.setColorBackground(color(60));
  ddl.setColorActive(color(255, 255, 255));
}

void framerate_slider(int sliderValue) {
  framerate = sliderValue;
  println("a slider event. setting framerate to "+ framerate);
}
void Antal_element(int sliderValue) {
  n = sliderValue;
  println("a slider event. setting n to "+ framerate);
}

/* ----------------- Reset sorter ----------------- */
void resetSorter() {
  int[] arr = new int[n];
  frameRate(framerate);
  println("Restart med framerate ", framerate);



  if (selectedList == 0) {    // Random list
    for (int i = 0; i < n; i++) {
      arr[i] = int(random(50, height - 60));
    }
  } else if (selectedList == 1) {  // reversed list
    for (int i=0; i<n; i++) arr[i] = (n*(height/n)-i*(height/n))*9/10; 
  } else if (selectedList == 2) {  // almost sorted
    for (int i=0; i<n; i++) arr[i] = (i*height/n)*9/10;
    for (int k=0; k<n/10; k++) {  // 10% random
        int a = (int)random(n);
        int b = (int)random(n);
        int tmp = arr[a]; arr[a] = arr[b]; arr[b] = tmp;
    }
  }

  v = new Visualizer(arr, 0, width);

  if (selectedAlg == 0) {
    currentSorter = new BubbleSort(arr, v);
  } else if (selectedAlg == 1) {
    currentSorter = new InsertionSort(arr, v);
  } else if (selectedAlg == 2) {
    currentSorter = new QuickSort(arr, v);
  } else if (selectedAlg == 3) {
    currentSorter = new HeapSort(arr, v);
  } else if (selectedAlg == 4) {
    currentSorter = new SelectionSort(arr, v);
  } else {selectAlg = !selectAlg;}
}

interface Sorter {
  void step();
  boolean isFinished();
}
