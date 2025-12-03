
module dynamic_array{Type};

struct DynamicArray {
  Allocator allocator;
  usz capacity;
  usz size;
  Type *entries;
}

fn DynamicArray *DynamicArray.init(&self, Allocator allocator) {
  *self = {.allocator = allocator};
  return self;
}

macro Type DynamicArray.get(&self, usz idx) @operator([]) {
  return self.entries[idx];
}

fn void DynamicArray.set(&self, usz idx, Type element) {
  self.entries[idx] = element;
}

fn void DynamicArray.push_all(&self, Type[] value) {
  foreach (v : value)
    self.push(v);
}

fn void DynamicArray.push(&self, Type value) {
  if (self.size >= self.capacity) {
    if (self.capacity == 0) {
      self.capacity = 16;
    } else if (self.capacity <= 64) {
      self.capacity = self.capacity * 2;
    } else {
      self.capacity = self.capacity + self.capacity / 2;
    }

    if (self.entries == null) {
      self.entries =
          allocator::malloc(self.allocator, Type.sizeof *self.capacity);
    } else {
      self.entries = allocator::realloc(self.allocator, self.entries,
                                        Type.sizeof *self.capacity);
    }
  }

  self.entries[self.size] = value;
  self.size++;
}

fn void DynamicArray.free(&self) {
  allocator::free(self.allocator, self.entries);
  self.entries = null;
  self.size = 0;
  self.capacity = 0;
}

fn void DynamicArray.clear(&self) { self.size = 0; }

fn usz DynamicArray.len(&self) @inline => self.size;

macro Type *DynamicArray.get_ref(DynamicArray *x, usz idx) @operator(&[]) {
  return &x.entries[idx];
}

macro usz DynamicArray.count(DynamicArray *x) @operator(len) { return x.size; }
