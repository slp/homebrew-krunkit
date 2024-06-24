class Krunkit < Formula
  desc "A CLI tool to start Linux KVM or macOS Hypervisor framework virtual machines using the libkrun platform."
  homepage "https://github.com/containers/krunkit"
  url "https://github.com/containers/krunkit/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "1395ee381ecf41a5d017e3dd5cd345814efeaa8e9e185c701332ed900db825dc"
  license "Apache-2.0"

  bottle do
    root_url "https://raw.githubusercontent.com/slp/homebrew-krunkit/master/bottles"
    sha256 cellar: :any, arm64_sonoma: "56abde23a66f50a517f010cfc2b0082ab17f4efc220b75ad160e59eeb0ced394"
  end

  depends_on "rust" => :build
  # We depend on libkrun, which only supports Hypervisor.framework on arm64
  depends_on arch: :arm64
  depends_on "libkrun-efi"

  def install
    system "make"
    bin.install "target/release/krunkit"
    ln_s bin/"krunkit", bin/"vfkit"
  end

  test do
    system "krunkit", "--version"
  end
end
