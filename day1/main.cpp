#include <iostream>
#include <sstream>
#include <vector>
#include <algorithm>
#include <ranges>
#include <tuple>
#include <fstream>
using namespace std;

auto sample_input = R"(
3   4
4   3
2   5
1   3
3   9
3   3
)";

vector<string> split(string &s, const string &delimiter) {
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

void parse(istream *input_stream, vector<int> *list1, vector<int> *list2) {
  for (string line; getline(*input_stream, line);) {
    if (line != "") {
      auto parts = split(line, "   ");
      list1->push_back(stoi(parts[0]));
      list2->push_back(stoi(parts[1]));
    }
  }
  sort(list1->begin(), list1->end());
  sort(list2->begin(), list2->end());
}

int sum_lists(vector<int> list1, vector<int> list2) {
  auto sum = 0;
  for (auto pair : views::zip(list1, list2)) {
    sum += abs(pair.first - pair.second);
  }
  return sum;
}

int compare_lists(vector<int> list1, vector<int> list2) {
  auto sum = 0;
  for (auto i : list1) {
    sum += i * count(list2.begin(), list2.end(), i);
  }
  return sum;
}

int main() {
  istringstream ss;
  ss.str(sample_input);
  vector<int> sample_list1;
  vector<int> sample_list2; 
  parse(&ss, &sample_list1, &sample_list2);
  printf("part 1 (sample): %i\n", sum_lists(sample_list1, sample_list2));
  printf("part 2 (sample): %i\n", compare_lists(sample_list1, sample_list2));

  ifstream inputfs;
  inputfs.open("input.txt");
  vector<int> list1;
  vector<int> list2; 
  parse(&inputfs, &list1, &list2);
  printf("part 1: %i\n", sum_lists(list1, list2));
  printf("part 2: %i\n", compare_lists(list1, list2));

  return 0;
}
