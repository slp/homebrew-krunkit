class LibkrunEfi < Formula
  desc "Dynamic library providing KVM-based process isolation capabilities"
  homepage "https://github.com/containers/libkrun"
  url "https://github.com/containers/libkrun/archive/refs/tags/v1.8.1.tar.gz"
  sha256 "836127b03d88a954431eba3b7a76da8794c7e738568e16954eab3baf6dd55ca9"
  license "Apache-2.0"

  bottle do
    root_url "https://raw.githubusercontent.com/slp/homebrew-krunkit/master/bottles"
    sha256 cellar: :any, arm64_sonoma: "e7686cceddcb4a21543fd6c97fc8762407a1de0e68470785362b9cf35a4f7ca8"
  end

  depends_on "rust" => :build
  # Upstream only supports Hypervisor.framework on arm64
  depends_on arch: :arm64
  depends_on "dtc"
  depends_on "slp/homebrew-krunkit/virglrenderer"

  def install
    system "make", "EFI=1"
    system "make", "EFI=1", "PREFIX=#{prefix}", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <libkrun.h>
      int main()
      {
         int c = krun_create_ctx();
         return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lkrun", "-o", "test"
    system "./test"
  end
end
