class Ligo < Formula
  desc "Friendly Smart Contract Language for Tezos"
  homepage "https://ligolang.org/"

  url "https://gitlab.com/ligolang/ligo/-/archive/0.21.0/ligo-0.21.0.tar.gz"
  # Version is autoscanned from url, we don't specify it explicitly because `brew audit` will complain
  # To calculate sha256: 'curl -L --fail <url> | sha256sum'
  sha256 "8a2fcf806d561ef352043fbbef1642d09ee56b452ed314dd6c66a96ffe3e158f"

  bottle do
    root_url "https://github.com/ligolang/homebrew-ligo/releases/download/v#{Ligo.version}"
    sha256 cellar: :any, catalina: "34d4f41fa4aa8d9805996416f5af6a624e5355d601364e880153a33a57d568f1"
    sha256 cellar: :any, mojave:   "5821957c7b5b25aa702e8fba1ef483e4483bb55aa3ec22a0f0c2f194934ad321"
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
