class Ligo < Formula
  desc "Friendly Smart Contract Language for Tezos"
  homepage "https://ligolang.org/"

  url "https://gitlab.com/ligolang/ligo/-/archive/0.22.0/ligo-0.22.0.tar.gz"
  # Version is autoscanned from url, we don't specify it explicitly because `brew audit` will complain
  # To calculate sha256: 'curl -L --fail <url> | sha256sum'
  sha256 "2434f88f9af7f1daee0306e355592461947d906ddba4592c016c56c18aef9ee2"

  bottle do
    root_url "https://github.com/ligolang/homebrew-ligo/releases/download/v#{Ligo.version}"
    sha256 cellar: :any, catalina: "8fc433b3fe16a5cf05462265904b0e4166c980ba39065cebef158e6337109758"
    sha256 cellar: :any, mojave:   "b7085d01626619444e9785ab971927ac84f93d2aded82c8cdcf0b831e2d5dd52"
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
