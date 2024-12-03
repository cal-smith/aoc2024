#include <iostream>
#include <sstream>
#include <vector>
#include <algorithm>
#include <ranges>
#include <tuple>
#include <fstream>
using namespace std;

auto sample_input = R"(
7 6 4 2 1
1 2 7 8 9
9 7 6 2 1
1 3 2 4 5
8 6 4 4 1
1 3 6 7 9
)";

vector<string> split(string& s, const string& delimiter) {
  vector<string> tokens;
  size_t pos = 0;
  string token;
  while ((pos = s.find(delimiter)) != string::npos) {
    token = s.substr(0, pos);
    tokens.push_back(token);
    s.erase(0, pos + delimiter.length());
  }
  tokens.push_back(s);

  return tokens;
}

vector<vector<int>> parse(istream* input_stream) {
  vector<vector<int>> list;
  for (string line; getline(*input_stream, line);) {
    if (line != "") {
      vector<int> inner_list;
      auto parts = split(line, " ");
      for (auto part : parts) {
        inner_list.push_back(stoi(part));
      }
      list.push_back(inner_list);
    }
  }
  return list;
}

enum Direction {
  UP,
  DOWN
};

bool is_safe_report(vector<int> report) {
  auto prevLevel = -1;
  auto direction = report[0] - report[1] > 0 ? Direction::UP : Direction::DOWN;
  for (auto level : report) {
    if (prevLevel != -1) {
      auto change = abs(prevLevel - level);
      if (change < 1 or change > 3) {
        return false;
      }

      // figure out the current direction
      auto currentDirection = prevLevel - level > 0 ? Direction::UP : Direction::DOWN;

      // they all have to be insreasing or decreasing
      if (currentDirection != direction) {
        return false;
      }
    }
    prevLevel = level;
  }

  return true;
}

int count_safe_reports(vector<vector<int>>& reports) {
  auto safe_reports = 0;
  for (auto report : reports) {
    if (is_safe_report(report)) {
      safe_reports++;
    }
  }
  return safe_reports;
}

int count_dampened_reports(vector<vector<int>>& reports) {
  auto safe_reports = 0;
  for (auto report : reports) {
    if (is_safe_report(report)) {
      safe_reports++;
    } else {
      for (auto i = 0; i < report.size(); i++) {
        vector<int> copy = report;
        copy.erase(copy.begin() + i);
        if (is_safe_report(copy)) {
          safe_reports++;
          break;
        }
      }
    }
  }
  return safe_reports;
}

int main() {
  istringstream ss;
  ss.str(sample_input);
  auto sample_reports = parse(&ss);

  printf("part 1 (sample): %i\n", count_safe_reports(sample_reports));
  printf("part 1 (sample): %i\n", count_dampened_reports(sample_reports));

  ifstream inputfs;
  inputfs.open("input.txt");
  auto reports = parse(&inputfs);
  printf("part 1: %i\n", count_safe_reports(reports));
  printf("part 1: %i\n", count_dampened_reports(reports));

}