class Visualizer {
  int[] arr;
  int highlightedA = -1;
  int highlightedB = -1;
  int x0, x1;

  Visualizer(int[] arr, int x0, int x1) {
    this.arr = arr;
    this.x0 = x0;
    this.x1 = x1;
  }

  int[] getArray() {
    return arr;
  }

  void highlight(int a, int b) {
    highlightedA = a;
    highlightedB = b;
  }

  void display() {
    float w = (x1 - x0) / float(arr.length);
    for (int i = 0; i < arr.length; i++) {
      if (i == highlightedA || i == highlightedB) {
        fill(255, 100, 100);
      } else {
        fill(200);
      }
      rect(x0 + i*w, height, w, -arr[i]);
    }
  }
}
