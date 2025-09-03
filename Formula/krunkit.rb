class Krunkit < Formula
  desc "A CLI tool to start Linux KVM or macOS Hypervisor framework virtual machines using the libkrun platform."
  homepage "https://github.com/containers/krunkit"
  url "https://github.com/containers/krunkit/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "f0f27a09152cf714edeaa3269b0eecd5018e3e3b65a3187fddd2867284d304bc"
  license "Apache-2.0"

  bottle do
    root_url "https://raw.githubusercontent.com/slp/homebrew-krunkit/master/bottles"
    sha256 cellar: :any, arm64_sequoia: "18b109a13fe6b552ff6135f616ac104982fc0941d114efd70800849bb4e79a6e"
  end

  depends_on "rust" => :build
  # We depend on libkrun, which only supports Hypervisor.framework on arm64
  depends_on arch: :arm64
  depends_on "libkrun-efi"

  def install
    homebrew_lib = ENV["HOMEBREW_PREFIX"] + "/lib"
    system "make"
    system "install_name_tool", "-add_rpath", homebrew_lib, "target/release/krunkit"
    system "codesign", "--entitlements", "krunkit.entitlements", "--force", "-s", "-", "target/release/krunkit"
    bin.install "target/release/krunkit"
  end

  test do
    system "krunkit", "--version"
  end
end
