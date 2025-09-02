class BubbleSort implements Sorter {
  int[] arr;
  int i = 0, j = 0; // i indikerar ett "varv" i algoritmen, j indikerar index för det aktuella elementet
  boolean finished = false;
  Visualizer v;

  BubbleSort(int[] arr, Visualizer v) {   // constructor
    this.arr = arr;
    this.v = v;
  }

  void step() {
    if (finished) return;

    if (i < arr.length) {  // antalet varv med jämförelser = n - 1
      if (j < arr.length - i - 1) {   // vi vill att ett varv har n - i - 1 jämförelser --> gör att vi inte jämför redan sorterade element
        v.highlight(j, j+1);
        if (arr[j] > arr[j+1]) {
          int temp = arr[j];  // mins värdet på position j
          arr[j] = arr[j+1];  // element j får värdet på elementet efter
          arr[j+1] = temp;  // element j+1 får det ihågkommna värdet hos element j --> elementen har bytt plats
        }
        j++;  // öka j med 1
      } else { // starta om på nästa varv
        j = 0;
        i++;  // öka i med 1
      }
    } else {
      finished = true;
    }
  }

  boolean isFinished() {
    return finished;
  }
}

class InsertionSort implements Sorter {
  int[] arr;
  int i = 1;          // börjar med andra elementet --> första ses som sorterat redan
  int j = 0;          // kommer hålla koll på förflyttning
  int key;
  boolean inserting = false; // håller reda på om vi är mitt i en förflyttning
  boolean finished = false;
  Visualizer v;

  InsertionSort(int[] arr, Visualizer v) {
    this.arr = arr;
    this.v = v;
  }

  void step() {
    if (finished) return;

    if (!inserting) {
      if (i < arr.length) {
        key = arr[i];      // key är värdet på det aktuella elementet
        j = i - 1;
        inserting = true;  // starta insättning
      } else {
        finished = true;   // klart
      }
    } else {
      v.highlight(j, j+1);

      if (j >= 0 && arr[j] > key) {
        arr[j+1] = arr[j];
        j--;
      } else {
        arr[j+1] = key;
        i++;
        inserting = false; // klart för denna "insättning"
      }
    }
  }

  boolean isFinished() {
    return finished;
  }
}

class QuickSort implements Sorter {

  int[] arr;
  Visualizer v;
  boolean finished = false;

  // Stack för segment som ska sorteras (low, high)
  ArrayList<int[]> segments = new ArrayList<int[]>();

  // Variabler för partitionering
  int low, high;
  int pivot;
  int i, j;
  boolean partitioning = false;

  QuickSort(int[] arr, Visualizer v) {
    this.arr = arr;
    this.v = v;
    segments.add(new int[]{0, arr.length - 1}); // startsegment --> hela arr
  }

  void swap(int a, int b) {
    int temp = arr[a];
    arr[a] = arr[b];
    arr[b] = temp;
  }
  public void step() {
    if (finished) return;

    // Om inget segment partitioneras, hämta nytt från stacken
    if (!partitioning) {
      if (segments.isEmpty()) {
        finished = true;
        return;
      }
      int[] segment = segments.remove(segments.size() - 1); // pop
      low = segment[0];
      high = segment[1];
      pivot = arr[high];  // sätt pivot till sista elementet i segmentet
      i = low - 1;       // i sätts till positionen innan första elementet i segmentet
      j = low;
      partitioning = true;
    }

    // Partitionera ett steg
    if (partitioning) {
      if (j < high) {
        if (arr[j] < pivot) {  // ifall element j är mindre än pivot ökar i och det sker en swap
          i++;
          swap(i, j);
        }
        v.highlight(j, high); // markera aktuellt element och pivot
        j++;  // oavsett vad ökar j med 1 fram till pivot
      } else {
        // Partition klar, flytta pivot till rätt plats(i+1)
        swap(i + 1, high);
        int pi = i + 1;

        // Lägg kvarvarande segment på stacken
        if (pi - 1 > low) segments.add(new int[]{low, pi - 1});
        if (pi + 1 < high) segments.add(new int[]{pi + 1, high});

        partitioning = false;
      }
    }
  }

  public boolean isFinished() {
    return finished;
  }
}


class HeapSort implements Sorter {
  int[] arr;
  int n;
  int buildIndex;  // index på root element

  // booleans håller reda på var i algoritmen vi befinner oss
  boolean buildingHeap = true;  // vi börjar med buildingHeap
  boolean sorting = false;
  boolean heapifying = false;


  int heapifyIndex;  // index på det aktuella elementet i jämförelsen
  Visualizer v;
  boolean finished = false;

  // hjälpvariabler för heapifyStep
  int state = 0;   // 0=left jämförelse, 1=right jämförelse, 2=swap check
  int largest;     // nuvarande största elementets index
  int left, right;

  HeapSort(int[] arr, Visualizer v) {
    this.arr = arr;
    this.v = v;
    n = arr.length;
    buildIndex = n/2 - 1; // börja från sista icke-blad
  }

  void step() {
    if (finished) return;


    if (buildingHeap) {
      if (!heapifying) {
        heapifyIndex = buildIndex;
        largest = buildIndex;
        left = 2*heapifyIndex + 1;
        right = 2*heapifyIndex + 2;
        // påbörja jämförelse för att uppnå Max Heap
        state = 0;
        heapifying = true;
        println("Building heap");
      }
      heapifyStep(n);
      if (!heapifying) { // klart med denna nod
        buildIndex--;  // vi går nedifrån och upp för att bygga heap
        if (buildIndex < 0) { // Vi har bygggt hela vår heap och kan gå vidare till att sortera
          buildingHeap = false;
          sorting = true;
          println("Done building heap");
        }
      }
    } else if (sorting) {
      // Byt root med sista elementet
      swap(0, n-1);
      n--;

      if (n <= 1) {
        println("Finished");
        finished = true;
      }

      // påbörja heapify på roten
      heapifyIndex = 0;
      largest = 0;
      left = 1;
      right = 2;
      state = 0;
      heapifying = true;

      sorting = false;
    } else if (heapifying) {
      heapifyStep(n);
      println("Heapifying");
      if (!heapifying) {
        // När heapify för roten är klar --> gå tillbaka till sorting
        sorting = true;
      }
    }
  }

  void heapifyStep(int size) {
    if (state == 0) {
      // jämför vänster barn
      if (left < size && arr[left] > arr[largest]) {
        largest = left;
      }
      v.highlight(heapifyIndex, left); // highlight jämförelsen
      state = 1;
      println("Comapring parent to left child");
    } else if (state == 1) {
      // jämför höger barn
      if (right < size && arr[right] > arr[largest]) {
        largest = right;
      }
      v.highlight(heapifyIndex, right);
      state = 2;
      println("Comapring parent to right child");
    } else if (state == 2) {
      // ev. swap
      if (largest != heapifyIndex) {
        swap(heapifyIndex, largest);
        // vi swappar så att det största elementet hamnar
        // längst upp och heapifyIndex kommer "längre ner" i trädet,
        // på så sätt vandrar vi nedåt i trädet
        heapifyIndex = largest;

        left = 2*heapifyIndex + 1;
        right = 2*heapifyIndex + 2;
        state = 0; // fortsätt heapify längre ner i nästa step
        println("Swap was excecuted");
      } else {
        heapifying = false; // klart för denna nod
      }
    }
  }

  void swap(int i, int j) {
    int temp = arr[i];
    arr[i] = arr[j];
    arr[j] = temp;
  }

  boolean isFinished() {
    return finished;
  }
}


class SelectionSort implements Sorter {

  int[] arr;
  Visualizer v;

  int current;
  int n;
  int search_idx;
  int min_idx;

  boolean searching = true;

  boolean finished = false;

  SelectionSort(int[] arr, Visualizer v) { // constructor
    this.arr = arr;
    this.v = v;
    current = 0;
    n = arr.length;
    search_idx = 0;
    min_idx = current;
  }

  void step() {

    if (finished) {
      return;
    }

    if (searching) {

      if (search_idx < n) {
        if (arr[search_idx] < arr[min_idx]) {  // om vi söter på ett elemet som är mindre än det på min_idx
          min_idx = search_idx;              // så blir dess index nya min_idx --> vi hittar minsta elementet
        }
        v.highlight(search_idx, min_idx);  // highlight jämförelse
        search_idx++;
      } else {  // Vi har sökt hela arrayen --> min_idx pekar på minsta elementet

        searching = false;
      }
    } else {

      swap(current, min_idx);
      current++;

      // kolla om färdiga, annars sätt searching till true
      if (current >= n-1) {
        finished = true;
      } else {
        // börja scanna nästa segment
        search_idx = current + 1;
        min_idx = current;
        searching = true;
      }
    }
  }

  void swap(int i, int j) {
    int temp = arr[i];
    arr[i] = arr[j];
    arr[j] = temp;
  }

  boolean isFinished() {
    return finished;
  }
}
