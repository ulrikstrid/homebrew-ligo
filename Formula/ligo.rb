class Ligo < Formula
  desc "Friendly Smart Contract Language for Tezos"
  homepage "https://ligolang.org/"

  url "https://gitlab.com/ligolang/ligo/-/archive/0.19.0/ligo-0.19.0.tar.gz"
  # Version is autoscanned from url, we don't specify it explicitly because `brew audit` will complain
  # To calculate sha256: 'curl -L --fail <url> | sha256sum'
  sha256 "eeaf549217d3706bc3bc9f9069384ac77e262ed989303da1cdfc66c9dc9ce390"

  bottle do
    root_url "https://github.com/ligolang/homebrew-ligo/releases/download/v#{Ligo.version}"
    sha256 cellar: :any, catalina: "2c90c986f0b5fe56cad8813e0c5d9b1416ba50e5f2fcf771e33234430caceaa0"
    sha256 cellar: :any, mojave:   "b203f1ae8b37462d60936ba720cdb20109c780d1f4667aed5f32bd15fc32fea2"
  end

  build_dependencies = %w[opam rust hidapi pkg-config]
  build_dependencies.each do |dependency|
    depends_on dependency => :build
  end

  dependencies = %w[gmp libev libffi]
  dependencies.each do |dependency|
    depends_on dependency
  end

  def install
    system "opam",
     "init",
     "--bare",
     "--auto-setup",
     "--disable-sandboxing"

    ENV["LIGO_VERSION"] = Ligo.version
    system "scripts/setup_switch.sh"
    # we want to be sure that all steps run in the same shell with evaled opam config
    system ["eval $(opam config env)", "scripts/install_vendors_deps.sh", "scripts/build_ligo_local.sh"].join(" && ")

    cp "_build/install/default/bin/ligo", "ligo"
    bin.mkpath
    bin.install "ligo"
  end

  test do
    system "#{bin}/ligo", "--help=plain"
  end
end
