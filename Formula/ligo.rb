class Ligo < Formula
  desc "Friendly Smart Contract Language for Tezos"
  homepage "https://ligolang.org/"

  url "https://gitlab.com/ligolang/ligo/-/archive/0.24.0/ligo-0.24.0.tar.gz"
  # Version is autoscanned from url, we don't specify it explicitly because `brew audit` will complain
  # To calculate sha256: 'curl -L --fail <url> | sha256sum'
  sha256 "3ed5338498ed03f32bc1f6e5acfa3122083773719c1aa05656e7d04119c4a2f3"

  bottle do
    root_url "https://github.com/ligolang/homebrew-ligo/releases/download/v#{Ligo.version}"
    # sha256 cellar: :any, catalina: "16f606765e31ad7254c1ec85cb44fe79599b83f101602f79644c47360a95a8ff"
    # sha256 cellar: :any, mojave:   "da7b865b2738e4dbf232dbcac18ebd5d6f39284b9e62fa81e0e2aa08cbb33de9"
  end

  build_dependencies = %w[opam rust hidapi pkg-config]
  build_dependencies.each do |dependency|
    depends_on dependency => :build
  end

  dependencies = %w[gmp libev libffi]
  dependencies.each do |dependency|
    depends_on dependency
  end

  # sets up env vars for opam before running a command
  private def with_opam_env(cmd)
    "eval \"$(opam config env)\" && #{cmd}"
  end

  def install
    # ligo version is taken from the environment variable in build-time
    ENV["LIGO_VERSION"] = Ligo.version
    # avoid opam prompts
    ENV["OPAMYES"] = "true"

    # init opam state in ~/.opam
    system "opam", "init", "--bare", "--auto-setup", "--disable-sandboxing"
    # create opam switch with required ocaml version
    system "opam", "switch", "create", ".", "ocaml-base-compiler.4.09.1", "--no-install"
    # build and test external dependencies
    system with_opam_env "opam install --deps-only --with-test --locked ./ligo.opam $(find vendors -name \\*.opam)"
    # build vendored dependencies
    system with_opam_env "opam install $(find vendors -name \\*.opam)"
    # build ligo
    system with_opam_env "dune build -p ligo"

    # install ligo binary
    cp "_build/install/default/bin/ligo", "ligo"
    bin.mkpath
    bin.install "ligo"
  end

  test do
    system "#{bin}/ligo", "--help=plain"
  end
end
