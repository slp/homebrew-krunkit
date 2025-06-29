class Krunkit < Formula
  desc "A CLI tool to start Linux KVM or macOS Hypervisor framework virtual machines using the libkrun platform."
  homepage "https://github.com/containers/krunkit"
  url "https://github.com/containers/krunkit/archive/refs/tags/v0.2.2.tar.gz"
  sha256 "750f70cb6ae97b2bc34b3d167ff3db51bd2e2ce6feb2d443dc555c9c7f3432f4"
  license "Apache-2.0"

  bottle do
    root_url "https://raw.githubusercontent.com/slp/homebrew-krunkit/master/bottles"
    sha256 cellar: :any, arm64_sequoia: "0ea68a5ebaece0d245d852e1a5f23b089d044c2063b4ca265382c0eb3ef0e401"
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
