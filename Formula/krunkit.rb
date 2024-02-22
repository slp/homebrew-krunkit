class Krunkit < Formula
  desc "A CLI tool to start Linux KVM or macOS Hypervisor framework virtual machines using the libkrun platform."
  homepage "https://github.com/tylerfanelli/krunkit"
  url "https://github.com/slp/krunkit/archive/refs/tags/0.1.1-krunkit.tar.gz"
  sha256 "58ba968ef4800c22d44ca65afcfc1ac583e13bf317f3f6257bf9e98d501acdc9"
  license "Apache-2.0"

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
