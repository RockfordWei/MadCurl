#if os(Linux)
import SwiftGlibc
#else
import Darwin
#endif

import PerfectCURL

func test(_ remain: Int) {
  if remain < 1 {
    exit(0)
  }
  let curl = CURL(url:"http://google.ca")
  let _ = curl.perform { _ in
    curl.close()
    print(remain)
    test(remain - 1)
  }//end
}

print("asynchronous testing (\(10) times):")
test(10)
let _ = getchar()
