class Virglrenderer < Formula
  desc "VirGL virtual OpenGL renderer"
  homepage "https://gitlab.freedesktop.org/virgl/virglrenderer"
  url "https://gitlab.freedesktop.org/slp/virglrenderer/-/archive/0.10.4-krunkit/virglrenderer-0.10.4-krunkit.tar.gz"
  sha256 "f0460d4f68b1711f1d1585f754232b8bb3ece3611b116b3c692215efb5c2acd2"
  license "MIT"

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "libepoxy-angle"
  depends_on "molten-vk"

  patch :p1 do
    url "https://gist.githubusercontent.com/slp/2cab2cc053fa507981513c33f4afafd7/raw/2e7d7669e5e179dfaa51295a45f65c11d97af0b0/0001-Link-directly-against-MoltenVK.patch"
    sha256 "642ee17821d6137bde57cc1ea7e7b785265e8f87b566256dd8ae15fa1d942d5a"
  end

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
