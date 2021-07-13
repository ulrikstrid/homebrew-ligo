class Ligo < Formula
  desc "A friendly Smart Contract Language for Tezos"
  homepage "https://ligolang.org/"

  version "0.19.0"
  url "https://gitlab.com/ligolang/ligo.git", :tag => Ligo.version, :shallow => true

  bottle do
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

    # we want to be sure that all steps run in the same shell with evaled opam config
    ENV["LIGO_VERSION"] = Ligo.version
    system "scripts/setup_switch.sh"
    system ["eval $(opam config env)", "scripts/install_vendors_deps.sh", "scripts/build_ligo_local.sh"].join(" && ")

    bin.mkpath
    bin.install "_build/install/default/bin/ligo"
  end
  test do
    system "#{bin}/ligo", "--help"
  end
end
