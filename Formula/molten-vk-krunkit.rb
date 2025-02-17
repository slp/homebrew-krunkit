class MoltenVkKrunkit < Formula
  desc "Implementation of the Vulkan graphics and compute API on top of Metal"
  homepage "https://github.com/KhronosGroup/MoltenVK"
  license "Apache-2.0"
  conflicts_with "molten-vk"

  bottle do
    root_url "https://raw.githubusercontent.com/slp/homebrew-krunkit/master/bottles"
    sha256 cellar: :any, arm64_sequoia: "168f009930c636661de6766a91f42fcc8a5a4ced5e1e6ea6f1ad1be0c76fc92d"
  end

  stable do
    url "https://github.com/slp/MoltenVK/archive/refs/tags/1.2.12.tar.gz"
    sha256 "01bfb76bcccb5891efd75882c3f34bde3cb9d2edc01aa361f7463aaec7245afa"

    # MoltenVK depends on very specific revisions of its dependencies.
    # For each resource the path to the file describing the expected
    # revision is listed.
    resource "SPIRV-Cross" do
      # ExternalRevisions/SPIRV-Cross_repo_revision
      url "https://github.com/slp/SPIRV-Cross.git",
          revision: "34700d3f2384261760eb81b7c70754d58a3b39a4"
    end

    resource "Vulkan-Headers" do
      # ExternalRevisions/Vulkan-Headers_repo_revision
      url "https://github.com/KhronosGroup/Vulkan-Headers.git",
          revision: "29f979ee5aa58b7b005f805ea8df7a855c39ff37"
    end

    resource "Vulkan-Tools" do
      # ExternalRevisions/Vulkan-Tools_repo_revision
      url "https://github.com/KhronosGroup/Vulkan-Tools.git",
          revision: "2020cec4111c87d85b167d583180b839f0c736c5"
    end

    resource "cereal" do
      # ExternalRevisions/cereal_repo_revision
      url "https://github.com/USCiLab/cereal.git",
          revision: "51cbda5f30e56c801c07fe3d3aba5d7fb9e6cca4"
    end

    resource "glslang" do
      # ExternalRevisions/glslang_repo_revision
      url "https://github.com/KhronosGroup/glslang.git",
          revision: "e8dd0b6903b34f1879520b444634c75ea2deedf5"
    end

    resource "SPIRV-Tools" do
      # known_good.json in the glslang repository at revision of resource above
      url "https://github.com/KhronosGroup/SPIRV-Tools.git",
          revision: "6dcc7e350a0b9871a825414d42329e44b0eb8109"
    end

    resource "SPIRV-Headers" do
      # known_good.json in the glslang repository at revision of resource above
      url "https://github.com/KhronosGroup/SPIRV-Headers.git",
          revision: "2a9b6f951c7d6b04b6c21fe1bf3f475b68b84801"
    end
  end

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  head do
    url "https://github.com/slp/MoltenVK.git", branch: "main"

    resource "cereal" do
      url "https://github.com/USCiLab/cereal.git", branch: "master"
    end

    resource "Vulkan-Headers" do
      url "https://github.com/KhronosGroup/Vulkan-Headers.git", branch: "main"
    end

    resource "SPIRV-Cross" do
      url "https://github.com/slp/SPIRV-Cross.git", branch: "main"
    end

    resource "glslang" do
      url "https://github.com/KhronosGroup/glslang.git", branch: "main"
    end

    resource "SPIRV-Tools" do
      url "https://github.com/KhronosGroup/SPIRV-Tools.git", branch: "main"
    end

    resource "SPIRV-Headers" do
      url "https://github.com/KhronosGroup/SPIRV-Headers.git", branch: "main"
    end

    resource "Vulkan-Tools" do
      url "https://github.com/KhronosGroup/Vulkan-Tools.git", branch: "main"
    end
  end

  depends_on "cmake" => :build
  depends_on xcode: ["11.7", :build]
  # Requires IOSurface/IOSurfaceRef.h.
  depends_on macos: :sierra
  depends_on :macos # Linux does not have a Metal implementation. Not implied by the line above.

  uses_from_macos "python" => :build, since: :catalina

  def install
    resources.each do |res|
      res.stage(buildpath/"External"/res.name)
    end
    #mv "External/SPIRV-Tools", "External/glslang/External/spirv-tools"
    mv "External/SPIRV-Headers", "External/SPIRV-Tools/external/spirv-headers"

    # Build glslang
    cd "External/glslang" do
      system "./build_info.py", ".",
              "-i", "build_info.h.tmpl",
              "-o", "build/include/glslang/build_info.h"
    end

    # Build spirv-tools
    mkdir "External/SPIRV-Tools/build" do
      # Required due to files being generated during build.
      system "cmake", "..", *std_cmake_args
      system "make"
    end

    #mv "External/glslang/External/spirv-tools", "External/SPIRV-Tools"

    # Build ExternalDependencies
    xcodebuild "ARCHS=#{Hardware::CPU.arch}", "ONLY_ACTIVE_ARCH=YES",
               "-project", "ExternalDependencies.xcodeproj",
               "-scheme", "ExternalDependencies-macOS",
               "-derivedDataPath", "External/build",
               "SYMROOT=External/build", "OBJROOT=External/build",
               "build"

    if DevelopmentTools.clang_build_version >= 1500 && MacOS.version < :sonoma
      # Required to build xcframeworks with Xcode 15
      # https://github.com/KhronosGroup/MoltenVK/issues/2028
      xcodebuild "-create-xcframework", "-output", "./External/build/Release/SPIRVCross.xcframework",
                "-library", "./External/build/Release/libSPIRVCross.a"
      xcodebuild "-create-xcframework", "-output", "./External/build/Release/SPIRVTools.xcframework",
                "-library", "./External/build/Release/libSPIRVTools.a"
      xcodebuild "-create-xcframework", "-output", "./External/build/Release/glslang.xcframework",
                "-library", "./External/build/Release/libglslang.a"
    end

    # Build MoltenVK Package
    xcodebuild "ARCHS=#{Hardware::CPU.arch}", "ONLY_ACTIVE_ARCH=YES",
               "-project", "MoltenVKPackaging.xcodeproj",
               "-scheme", "MoltenVK Package (macOS only)",
               "-derivedDataPath", "#{buildpath}/build",
               "SYMROOT=#{buildpath}/build", "OBJROOT=build",
               "GCC_PREPROCESSOR_DEFINITIONS=${inherited} MVK_CONFIG_LOG_LEVEL=MVK_CONFIG_LOG_LEVEL_NONE",
               "build"

    (libexec/"lib").install Dir["External/build/Release/" \
                                "lib{SPIRVCross,SPIRVTools,glslang}.a"]
    glslang_dir = Pathname.new("External/glslang")
    Pathname.glob("External/glslang/{glslang,SPIRV}/**/*.{h,hpp}") do |header|
      header.chmod 0644
      (libexec/"include"/header.parent.relative_path_from(glslang_dir)).install header
    end
    (libexec/"include").install "External/SPIRV-Cross/include/spirv_cross"
    (libexec/"include").install "External/SPIRV-Tools/include/spirv-tools"
    (libexec/"include").install "External/Vulkan-Headers/include/vulkan" => "vulkan"
    (libexec/"include").install "External/Vulkan-Headers/include/vk_video" => "vk_video"

    frameworks.install "Package/Release/MoltenVK/static/MoltenVK.xcframework"
    lib.install "Package/Release/MoltenVK/dylib/macOS/libMoltenVK.dylib"
    lib.install "build/Release/libMoltenVK.a"
    include.install "MoltenVK/MoltenVK/API" => "MoltenVK"

    bin.install "Package/Release/MoltenVKShaderConverter/Tools/MoltenVKShaderConverter"
    frameworks.install "Package/Release/MoltenVKShaderConverter/" \
                       "MoltenVKShaderConverter.xcframework"
    include.install Dir["Package/Release/MoltenVKShaderConverter/include/" \
                        "MoltenVKShaderConverter"]

    inreplace "MoltenVK/icd/MoltenVK_icd.json",
              "./libMoltenVK.dylib",
              (lib/"libMoltenVK.dylib").relative_path_from(share/"vulkan/icd.d")
    (share/"vulkan").install "MoltenVK/icd" => "icd.d"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <vulkan/vulkan.h>
      int main(void) {
        const char *extensionNames[] = { "VK_KHR_surface" };
        VkInstanceCreateInfo instanceCreateInfo = {
          VK_STRUCTURE_TYPE_INSTANCE_CREATE_INFO, NULL,
          0, NULL,
          0, NULL,
          1, extensionNames,
        };
        VkInstance inst;
        vkCreateInstance(&instanceCreateInfo, NULL, &inst);
        return 0;
      }
    EOS
    system ENV.cc, "-o", "test", "test.cpp", "-I#{include}", "-I#{libexec/"include"}", "-L#{lib}", "-lMoltenVK"
    system "./test"
  end
end
