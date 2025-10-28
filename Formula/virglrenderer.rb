class Virglrenderer < Formula
  desc "VirGL virtual OpenGL renderer"
  homepage "https://gitlab.freedesktop.org/virgl/virglrenderer"
  url "https://gitlab.freedesktop.org/slp/virglrenderer/-/archive/0.10.4e-krunkit/virglrenderer-0.10.4e-krunkit.tar.gz"
  sha256 "73e81b65290f3630a130ad658ef870a813d0788f747618d88db55515cc7267b5"
  license "MIT"

  bottle do
    root_url "https://raw.githubusercontent.com/slp/homebrew-krunkit/master/bottles"
    sha256 cellar: :any, arm64_sequoia: "e124a40a85eeb639eaff47a1964095bb5a8e107a9b3810d2e495971e62f9a689"
  end

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
