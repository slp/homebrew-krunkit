class Virglrenderer < Formula
  desc "VirGL virtual OpenGL renderer"
  homepage "https://gitlab.freedesktop.org/virgl/virglrenderer"
  url "https://gitlab.freedesktop.org/slp/virglrenderer/-/archive/0.10.4-krunkit/virglrenderer-0.10.4-krunkit.tar.gz"
  sha256 "94f3cc9288bcd90b5e5960989f0c22e09abd901f1f56f8d30f18b5175ba0066e"
  license "MIT"

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "libepoxy"
  depends_on "molten-vk"

  def install
    args = %w[
      -Dvenus=true
      -Drender-server=false
    ]

    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end
end
