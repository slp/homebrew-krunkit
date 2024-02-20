class Krunkit < Formula
  desc "A CLI tool to start Linux KVM or macOS Hypervisor framework virtual machines using the libkrun platform."
  homepage "https://github.com/tylerfanelli/krunkit"
  url "https://github.com/slp/krunkit/archive/refs/tags/0.1.0-krunkit.tar.gz"
  sha256 "d3a4f31fd2075ab06bc49585bb18df03986478de1695547a3569e078d34c4742"
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
