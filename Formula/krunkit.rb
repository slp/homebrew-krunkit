class Krunkit < Formula
  desc "A CLI tool to start Linux KVM or macOS Hypervisor framework virtual machines using the libkrun platform."
  homepage "https://github.com/containers/krunkit"
  url "https://github.com/containers/krunkit/archive/refs/tags/v0.1.4.tar.gz"
  sha256 "30998931a859b4853adb1d3e66ec5072a92edb9d3e46ad69c41a647584c619a0"
  license "Apache-2.0"

  bottle do
    root_url "https://raw.githubusercontent.com/slp/homebrew-krunkit/master/bottles"
    sha256 cellar: :any, arm64_sequoia: "dec8f9ed1518b1202ec617d420fb4c5ae7623e4d08bbcb4b86d8d2a4fb690a85"
    sha256 cellar: :any, arm64_sonoma: "eb28aa1245947d57884f557ed9dc13e218b5ba2b86ba2020abd0c5262622a0ec"
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
