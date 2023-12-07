import Algorithms

struct Day02: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  // Splits input data into its component parts and convert from string.
  var lines: [String] {
    data.split(separator: "\n").map {
      String($0)
    }
  }

  // Replace this with your solution for the first part of the day's challenge.
  func part1() -> Any {
    // Calculate the sum of the first set of input data
    let games = lines.map {
      CubeGame(gameLine: $0)
    }

    return games.filter {
      $0.isGamePossible()
    }.reduce(0) {
      $0 + $1.id
    }
  }

  // Replace this with your solution for the second part of the day's challenge.
  func part2() -> Any {
    let games = lines.map {
      CubeGame(gameLine: $0)
    }

    return games.reduce(0) {
      $0 + $1.setPower()
    }
  }
}

struct CubeGame {
  let id: UInt
  let rounds: [CubeGameRound]

  init(gameLine: String) {
    let gameParts = gameLine.split(separator: ":")
    let gameString = gameParts[0].split(separator: " ")
    id = UInt(String(gameString[1]))!
    let cubes = gameParts[1].split(separator: "; ")

    rounds = cubes.map {
      CubeGameRound(round: String($0))
    }
  }

  func isGamePossible() -> Bool {
    return rounds.reduce(true) {
      $0 && $1.isPossible()
    }
  }

  func setPower() -> Int {
    var minRed = 0
    var minBlue = 0
    var minGreen = 0

    for round in rounds {
      minRed = round.red > minRed ? round.red : minRed
      minGreen = round.green > minGreen ? round.green : minGreen
      minBlue = round.blue > minBlue ? round.blue : minBlue
    }

    return minRed * minBlue * minGreen
  }
}

struct CubeGameRound {
  let red: Int
  let green: Int
  let blue: Int

  private static func uIntFrom(cubes: [String.SubSequence], color: String) -> Int {
    return Int(
      cubes.filter { $0.contains(color) }
        .first?
        .split(separator: " ").first ?? "0"
    ) ?? 0
  }

  func isPossible() -> Bool {
    red <= 12 && green <= 13 && blue <= 14
  }

  init(round: String) {
    let cubes = round.split(separator: ", ")
    red = CubeGameRound.uIntFrom(cubes: cubes, color: "red")
    green = CubeGameRound.uIntFrom(cubes: cubes, color: "green")
    blue = CubeGameRound.uIntFrom(cubes: cubes, color: "blue")
  }
}
