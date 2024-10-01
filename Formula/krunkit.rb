class Krunkit < Formula
  desc "A CLI tool to start Linux KVM or macOS Hypervisor framework virtual machines using the libkrun platform."
  homepage "https://github.com/containers/krunkit"
  url "https://github.com/containers/krunkit/archive/refs/tags/v0.1.3.tar.gz"
  sha256 "bc8214e00913c560b98a4b4d3d7da8052eeb78dc9e13a955e3018bee3e77d5fe"
  license "Apache-2.0"

  bottle do
    root_url "https://raw.githubusercontent.com/slp/homebrew-krunkit/master/bottles"
    sha256 cellar: :any, arm64_sonoma: "f0e766395b0a1b2884bcd91383291095872723257823909af5b2d3c4c308ea22"
  end

  depends_on "rust" => :build
  # We depend on libkrun, which only supports Hypervisor.framework on arm64
  depends_on arch: :arm64
  depends_on "libkrun-efi"

  def install
    system "make"
    bin.install "target/release/krunkit"
  end

  test do
    system "krunkit", "--version"
  end
end
