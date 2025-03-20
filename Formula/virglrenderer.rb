class Virglrenderer < Formula
  desc "VirGL virtual OpenGL renderer"
  homepage "https://gitlab.freedesktop.org/virgl/virglrenderer"
  url "https://gitlab.freedesktop.org/slp/virglrenderer/-/archive/0.10.4d-krunkit/virglrenderer-0.10.4d-krunkit.tar.gz"
  sha256 "73e81b65290f3630a130ad658ef870a813d0788f747618d88db55515cc7267b5"
  license "MIT"

  bottle do
    root_url "https://raw.githubusercontent.com/slp/homebrew-krunkit/master/bottles"
    sha256 cellar: :any, arm64_sequoia: "776bdeb22d285cb911d245c49ac2a5d95560494af0eeb697afaedbf1ea2620bf"
    sha256 cellar: :any, arm64_sonoma: "69c2cab39479d1d40f7b9b4813ff26378cb25be1523843277bca70f7802dcab2"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "libepoxy"
  depends_on "molten-vk-krunkit"

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
