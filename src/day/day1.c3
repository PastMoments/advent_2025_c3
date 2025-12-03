module day1;
import util;
import std::io;
import dynamic_array;
import std::math;

faultdef GENERAL_ERROR;

fn void? part1(String input_path) => @pool() {
  DynamicArray{String} input = util::parse_input(input_path) !;
  defer input.free();

  usz count = 0;
  int dial = 50;

  foreach (line : input) {
    String trimmed_line = line.trim();
    char dir = trimmed_line[0];
    int turn_amount = trimmed_line[1..].to_integer(int)!;
    if (dir == 'L') {
      turn_amount *= -1;
    } else if (dir == 'R') {
    } else {
      return GENERAL_ERROR ? ;
    }

    dial = (dial + turn_amount) % 100;
    if (dial == 0) {
      count++;
    }
  }

  io::printfn("Output: %d", count);
}

fn void? part2(String input_path) => @pool() {
  DynamicArray{String} input = util::parse_input(input_path) !;
  defer input.free();

  usz count = 0;
  int dial = 50;

  foreach (line : input) {
    String trimmed_line = line.trim();
    char dir = trimmed_line[0];
    int turn_amount = trimmed_line[1..].to_integer(int)!;
    if (dir == 'L') {
      turn_amount *= -1;
    } else if (dir == 'R') {
    } else {
      return GENERAL_ERROR ? ;
    }

    int new_dial = dial + turn_amount;

    count += math::abs(new_dial / 100);
    if (math::sign(new_dial) * math::sign(dial) < 0 || new_dial == 0) {
      count++;
    }
    dial = (dial + turn_amount) % 100;
  }

  io::printfn("Output: %d", count);
}
