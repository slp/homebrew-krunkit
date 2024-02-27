class Krunkit < Formula
  desc "A CLI tool to start Linux KVM or macOS Hypervisor framework virtual machines using the libkrun platform."
  homepage "https://github.com/containers/krunkit"
  url "https://github.com/containers/krunkit/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "cb997ee4f46f7b59c2b0afbd9ee4cf9442eac30aa78037a465a6c02cec2cca35"
  license "Apache-2.0"

  bottle do
    root_url "https://raw.githubusercontent.com/slp/homebrew-krunkit/master/bottles"
    sha256 cellar: :any, arm64_sonoma: "5792146e5f06d3441d471118e9942028798541a308347c0f51c396dae162759f"
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
