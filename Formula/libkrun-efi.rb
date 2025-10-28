class LibkrunEfi < Formula
  desc "Dynamic library providing KVM-based process isolation capabilities"
  homepage "https://github.com/containers/libkrun"
  url "https://github.com/containers/libkrun/archive/refs/tags/v1.16.0.tar.gz"
  sha256 "04b6f01f44e263d168757ebcd9bc037d7c5836c1987a547c6b2fa5837abe1ab1"
  license "Apache-2.0"

  bottle do
    root_url "https://raw.githubusercontent.com/slp/homebrew-krunkit/master/bottles"
    sha256 cellar: :any, arm64_sequoia: "3f4f48595bed22bf942a28fc946ae6583c5665bf5e9d14768cf992bf8f8b9df4"
  end

  depends_on "rust" => :build
  # Upstream only supports Hypervisor.framework on arm64
  depends_on arch: :arm64
  depends_on "dtc"
  depends_on "slp/homebrew-krunkit/virglrenderer"

  def install
    system "touch", "init/init"
    system "make", "EFI=1", "GPU=1", "BLK=1", "NET=1"
    system "make", "EFI=1", "GPU=1", "BLK=1", "NET=1", "PREFIX=#{prefix}", "install"
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
