import Algorithms
import Foundation

struct Day01: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String
    
    let numberMap = [ "one": "1",
                      "two": "2",
                      "three": "3",
                      "four": "4",
                      "five": "5",
                      "six": "6",
                      "seven": "7",
                      "eight": "8",
                      "nine": "9",
    ];
    
    
    var lines: [String] {
        data.split(separator: "\n").map{
            String($0);
        }
    }
   
    var correctedLines: [String] {
        lines.map {
            let line = $0
            var IndexMap: Dictionary<String.Index, String> = [:];
            
            for numberName in numberMap.keys {
                let nameIndices = Set(line.indices(of: numberName));
                let digitIndices = Set(line.indices(of: numberMap[numberName] ?? ""));
                let indexes = nameIndices.union(digitIndices);
                for index in indexes {
                    IndexMap.updateValue(numberMap[numberName] ?? "", forKey: index);
                }
            }
            
            let indexes = IndexMap.keys.sorted();
            let first = IndexMap[indexes.first!] ?? "";
            let last = IndexMap[indexes.last!] ?? "";
            return first + last;
        }
    }
    
    
    let numberCharset = CharacterSet.decimalDigits;
    
    func NumberLines(_ lines: [String]) -> [String] {
        lines.map {
            String($0.unicodeScalars.filter(numberCharset.contains))
        }
    }
    
    func calibrationValues(_ NumberLines: [String]) -> [Int] {
        NumberLines.map {
            let first = $0.prefix(1);
            let last = $0.suffix(1);
            
            let numberString = first.appending(last);
            return Int(numberString) ?? 0;
        }
    }

  // Replace this with your solution for the first part of the day's challenge.
  func part1() -> Any {
      calibrationValues(NumberLines(lines)).reduce(0, +);
  }

  // Replace this with your solution for the second part of the day's challenge.
  func part2() -> Any {
      calibrationValues(correctedLines).reduce(0, +);
  }
}
