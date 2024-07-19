class Krunkit < Formula
  desc "A CLI tool to start Linux KVM or macOS Hypervisor framework virtual machines using the libkrun platform."
  homepage "https://github.com/containers/krunkit"
  url "https://github.com/containers/krunkit/archive/refs/tags/v0.1.2.tar.gz"
  sha256 "c134d46500ff9a12d31011923a4509bc9f5ee7e9b277b372e8388ce390839ad0"
  license "Apache-2.0"

  bottle do
    root_url "https://raw.githubusercontent.com/slp/homebrew-krunkit/master/bottles"
    sha256 cellar: :any, arm64_sonoma: "d77c3274827f8b2c3f125fdbf9930c082797008a0f7b41392f2d7fd552ad916d"
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
