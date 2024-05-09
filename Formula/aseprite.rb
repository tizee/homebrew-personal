class Aseprite < Formula
  env :std
  desc "A Pixel Art program - My fork of Aseprite"
  homepage "https://github.com/tizee/aseprite"
  license "EULA"
  head "https://github.com/tizee/aseprite.git", branch: "main"

  depends_on :macos => :ventura

  depends_on "cmake" => :build
  depends_on "ninja" => :build

  # skia-m102 for Aseprite
  # https://github.com/aseprite/skia/releases/tag/m102-861e4743af
  resource "skia-m102" do
    url "https://github.com/aseprite/skia/releases/download/m102-861e4743af/Skia-macOS-Release-arm64.zip"
    sha256 "3eac3a0a5792a38e1b21a429b359316cfbe402d7"
  end

  def install
    clear_env
    (var/"log/aseprite").mkpath

    aseprite_skia_path = buildpath/"skia"
    resource("skia-m102").unpack aseprite_skia_path

    args = %W[
      -DCMAKE_BUILD_TYPE=RelWithDebInfo
      -DCMAKE_OSX_ARCHITECTURES=arm64
      -DCMAKE_OSX_DEPLOYMENT_TARGET=#{MacOS::Xcode.version}
      -DCMAKE_OSX_SYSROOT=#{MacOS.sdk_path}
      -DLAF_BACKEND=skia
      -DSKIA_DIR=#{aseprite_skia_path}
      -DSKIA_LIBRARY_DIR=#{aseprite_skia_path}/out/Release-arm64
      -DSKIA_LIBRARY=#{aseprite_skia_path}/out/Release-arm64/libskia.a
      -DPNG_ARM_NEON:STRING=on
    ]

    aseprite_path = buildpath/"build"
    mkdir aseprite_path/"build" do
      system "cmake", "-G", "Ninja", "..", *(std_cmake_args + args)
      system "cmake", "--build", "."
      system "codesign", "--force", "-s", "-", "bin/aseprite"
    end

    # bundle Aseprite.app
    system "mv", buildpath/"build/bin/aseprite", buildpath/"assets/Aseprite.app/Contents/MacOS"
    system "mv", buildpath/"build/bin/data", buildpath/"assets/Aseprite.app/Contents/Resources"
    opt_prefix.install "assets/Aseprite.app"
    (opt_prefix/"Aseprite.app").install_symlink "/Applications/Aseprite.app"

    bin.install "#{opt_prefix}/Aseprite.app/Contents/MacOS/aseprite"
  end

  test do
    assert_match "Aseprite", shell_output("#{bin}/aseprite --version")
  end
end
