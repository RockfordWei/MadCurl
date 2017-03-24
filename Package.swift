import PackageDescription

let package = Package(
    name: "MadCurl",
    dependencies: [.Package(url: "https://github.com/PerfectlySoft/Perfect-CURL.git", majorVersion: 2)]
)
