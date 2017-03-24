#if os(Linux)
import SwiftGlibc
#else
import Darwin
#endif

import PerfectCURL

public class Benchmark {
  private var now = timeval()
  private var then = timeval()
  public init () { let _ = gettimeofday(&now, nil) }

  public var lapse: Int { get {
    let _ = gettimeofday(&then, nil)
    let u = Int64(then.tv_usec - now.tv_usec)
    let s = Int64(then.tv_sec - now.tv_sec)
    let d = s * Int64(1000000) + u
    now = then
    return Int(d)
    }//end get
  }//end lapse
}//end class

func testA() -> Int {
  let curl = CURL(url:"http://google.ca")
  let b = Benchmark()
  var x = 0
  let _ = curl.perform { _, _, code in
    x = b.lapse
    curl.close()
  }//end
  while(x == 0) { usleep(1) }
  return x
}

var x = 10
var y = 10
if CommandLine.arguments.count < 3 {
  print("\(CommandLine.arguments[0]) [sync test times = 10] [async test time = 10]")
}else{
  x = Int(CommandLine.arguments[1]) ?? 10
  y = Int(CommandLine.arguments[2]) ?? 10
}//end if
func testB() -> Int {
  let curl = CURL(url:"http://google.ca")
  let b = Benchmark()
  let _ = curl.performFully()
  return b.lapse
}

print("synchronous testing (\(x) times):")
for _ in 1 ... x {
  print(testB())
}

print("asynchronous testing (\(y) times):")
for _ in 1 ... y {
  print(testA())
}
