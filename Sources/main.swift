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

func test() -> Int {
  let curl = CURL(url:"http://google.ca")
  let b = Benchmark()
  var x = 0
  let _ = curl.perform { _, _, code in
    x = b.lapse
    curl.close()
  }//end
  while(x == 0) { sleep(1) }
  return x
}

print("asynchronous testing (\(100) times):")
for _ in 1 ... 100 {
  print(test())
}
