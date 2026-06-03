cask "ice" do
  version "0.11.13-dev.2"
  sha256 "c1bbaa71f61ebfe5ee928f790af60963a9f202364d63f78d2c6b3ec5105cf4a0"

  url "https://github.com/jordanbaird/Ice/releases/download/#{version}/Ice.zip",
      verified: "github.com/jordanbaird/Ice/"
  name "Ice"
  desc "Powerful menu bar manager"
  homepage "https://github.com/jordanbaird/Ice"

  # The latest stable release predates macOS Tahoe and has many UI issues on
  # current systems, so this cask intentionally tracks the newest pre-release
  # build that fixes macOS 26 Tahoe rendering. Pin the version manually.
  livecheck do
    skip "Tracks a specific pre-release build"
  end

  depends_on macos: :tahoe

  app "Ice.app"

  zap trash: [
    "~/Library/Application Support/com.jordanbaird.Ice",
    "~/Library/Caches/com.jordanbaird.Ice",
    "~/Library/HTTPStorages/com.jordanbaird.Ice",
    "~/Library/Preferences/com.jordanbaird.Ice.plist",
  ]
end
