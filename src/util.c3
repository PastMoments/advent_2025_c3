module util;

import std::io::file;
import dynamic_array;


fn DynamicArray{String}? parse_input(String path) {
  File input_file = file::open(path, "r") !;
  defer input_file.close() !!;

  usz len = input_file.seek(0, Seek.END) !;
  input_file.seek(0, Seek.SET) !;

  String data = (String)tmalloc(len) [:len];
  usz read = input_file.read(data) !;
  if (read != len) {
    return io::GENERAL_ERROR ? ;
  }

  usz num_lines = 1;
  foreach (character : data) {
    if (character == '\n') {
      num_lines++;
    }
  }

  DynamicArray{String} arr;
  arr.init(tmem);
  bool create_new_line = true;
  foreach (usz idx, character : data) {
    switch (character) {
    case '\r':
      continue;
    case '\n':
      create_new_line = true;
      continue;
    default:
      if (create_new_line) {
        arr.push(data [idx:0]);
        create_new_line = false;
      }

      arr.set(arr.len() - 1, data[idx - arr[arr.len() - 1].len..idx]);
    }
  }
  assert(arr.len() <= num_lines);

  return arr;
}

