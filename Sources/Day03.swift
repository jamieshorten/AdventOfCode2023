import Algorithms
import Foundation

struct Day03: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  let plan: [[UnicodeScalar]]
  // Splits input data into its component parts and convert from string.

  init(data: String) {
    self.data = data
    plan = data.split(separator: "\n").map {
      Array($0.unicodeScalars)
    }
  }

  var height: Int { plan.count }
  var width: Int { plan.first?.count ?? 0 }

  let numberCharset = CharacterSet.decimalDigits

  var components: [Component] {
    print("Finding Components")
    var components: [Component] = []
    for row in 0..<height {
      var numberChars: [UnicodeScalar] = []
      var startIndex = -1
      for column in 0..<width {
        let char = plan[row][column]
        if numberCharset.contains(char) {
          numberChars.append(char)
          startIndex = startIndex == -1 ? column : startIndex
        } else if !numberChars.isEmpty {
          var numberString = ""
          numberString.unicodeScalars.append(contentsOf: numberChars)
          let number = Int(numberString)!
          components.append(Component(number: number, row: row, start: startIndex, end: column - 1))
          startIndex = -1
          numberChars = []
        }
        if column == width - 1 && !numberChars.isEmpty {
          var numberString = ""
          numberString.unicodeScalars.append(contentsOf: numberChars)
          let number = Int(numberString)!
          components.append(Component(number: number, row: row, start: startIndex, end: column - 1))
          startIndex = -1
          numberChars = []
        }
      }

    }
    return components
  }

  var starPositions: [(Int, Int)] {
    var positions: [(Int, Int)] = []
    for row in 0..<height {
      for column in 0..<width {
        if plan[row][column] == "*" {
          positions.append((row, column))
        }
      }
    }
    return positions
  }

  func getAdjacentRanges(position: (Int, Int)) -> (ClosedRange<Int>, ClosedRange<Int>) {
    let lowerRow = position.0 == 0 ? 0 : position.0 - 1
    let lowerColumn = position.1 == 0 ? 0 : position.1 - 1
    let upperRow = position.0 == height - 1 ? height - 1 : position.0 + 1
    let upperColumn = position.1 == height - 1 ? height - 1 : position.1 + 1

    return (lowerRow...upperRow, lowerColumn...upperColumn)
  }

  var gearRatios: [Int] {
    let components = components
    let ranges = starPositions.map(getAdjacentRanges)

    var ratios: [Int] = []
    for range in ranges {
      let comps = components.filter {
        return isComponentInRange(component: $0, range: range)
      }

      if comps.count == 2 {
        ratios.append(comps[0].number * comps[1].number)
      }
    }
    return ratios
  }

  func isComponentInRange(component: Component, range: (ClosedRange<Int>, ClosedRange<Int>)) -> Bool
  {
    if !range.0.contains(component.row) { return false }

    for column in component.start...component.end {
      if range.1.contains(column) { return true }
    }

    return false
  }

  func getAdjacencies(component: Component) -> String {
    let startRow = component.row == 0 ? 0 : component.row - 1
    let endRow = component.row == height - 1 ? height - 1 : component.row + 1
    let startColumn = component.start == 0 ? 0 : component.start - 1
    let endColumn = component.end == width - 1 ? width - 1 : component.end + 1

    var adjacencies = ""
    let rows = plan[startRow...endRow]
    for row in rows {
      let rowSubseq = Array(row[startColumn...endColumn])
      adjacencies.unicodeScalars.append(contentsOf: rowSubseq)
    }

    return adjacencies
  }

  func isValid(component: Component) -> Bool {
    let adjacencies = getAdjacencies(component: component)
    print(adjacencies)
    let numberRegex = try! Regex("[0-9]+")
    let numbersStripped = adjacencies.replacing(String(component.number), with: "")
    print(numbersStripped)
    let dotsStripped = numbersStripped.replacingOccurrences(of: ".", with: "")
    print()
    return !dotsStripped.isEmpty
  }

  // Replace this with your solution for the first part of the day's challenge.
  func part1() -> Any {
    return components.filter { isValid(component: $0) }.reduce(0) {
      $0 + $1.number
    }
  }

  // Replace this with your solution for the second part of the day's challenge.
  func part2() -> Any {
    return gearRatios.reduce(0) {
      $0 + $1
    }
  }
}

struct Component {
  let number: Int
  let row: Int
  let start: Int
  let end: Int
}
