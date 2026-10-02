{
  lib,
  rustPlatform,
  fetchFromGitHub,
  shared-mime-info,
  libiconv,
  installShellFiles,
  nix-update-script,
  stdenv,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "handlr-regex";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "Anomalocaridid";
    repo = "handlr-regex";
    rev = "v${finalAttrs.version}";
    hash = "sha256-7psjlu0qyoZYTVwq2JYJJkB76ejlmMtmstDw+liMcj8=";
  };

  cargoHash = "sha256-a91WaIFBS9Rh4T/dwpLQJMoE604Tj0mVN38RKmNcZU0=";

  nativeBuildInputs = [
    installShellFiles
    shared-mime-info
  ];

  buildInputs = [ libiconv ];

  preCheck = ''
    export HOME=$TEMPDIR
  '';

  # shared-mime-info 2.5 aliased application/x-shellscript to text/x-shellscript
  # Skip tests that have the old type hardcoded.
  checkFlags = [
    "--skip=common::mime_types::tests::from_path"
    "--skip=common::path::tests::mime_table_terminal"
    "--skip=common::path::tests::test_mime_table_json"
    "--skip=common::path::tests::test_mime_table_piped"
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd handlr \
      --zsh <(COMPLETE=zsh $out/bin/handlr) \
      --bash <(COMPLETE=bash $out/bin/handlr) \
      --fish <(COMPLETE=fish $out/bin/handlr)

    installManPage target/release-tmp/build/handlr-regex-*/out/manual/man1/*
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    # last successful hydra build on darwin was in 2024
    broken = stdenv.hostPlatform.isDarwin;
    description = "Fork of handlr with support for regex";
    homepage = "https://github.com/Anomalocaridid/handlr-regex";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ anomalocaris ];
    mainProgram = "handlr";
  };
})
