set windows-shell := ["nu.exe", "-c"]
set shell := ["nu", "-c"]

root := absolute_path('')
gitignore := absolute_path('.gitignore')
prettierignore := absolute_path('.prettierignore')
markdown-link-check-rc := absolute_path('.markdown-link-check.json')

default:
    @just --choose

dev bin *args:
    cd '{{ root }}'; \
      cargo run --bin {{ bin }} -- {{ args }}

sync:
    cd '{{ root }}'; yes yes | cargo2nix

    nixpkgs-fmt '{{ root }}'

    prettier --write \
      --ignore-path '{{ gitignore }}' \
      --cache --cache-strategy metadata \
      '{{ root }}'

format:
    cd '{{ root }}'; just --fmt --unstable

    nixpkgs-fmt '{{ root }}'

    try { markdownlint --ignore-path '{{ gitignore }}' '{{ root }}' }

    prettier --write \
      --ignore-path '{{ gitignore }}' \
      --ignore-path '{{ prettierignore }}' \
      --cache --cache-strategy metadata \
      '{{ root }}'

    cd '{{ root }}'; cargo fmt --all

    cd '{{ root }}'; cargo clippy --fix --allow-dirty --allow-staged

lint:
    prettier --check \
      --ignore-path '{{ gitignore }}' \
      --ignore-path '{{ prettierignore }}' \
      --cache --cache-strategy metadata \
      '{{ root }}'

    cspell lint '{{ root }}' \
      --no-progress

    markdownlint --ignore-path '{{ gitignore }}' '{{ root }}'
    markdown-link-check \
      --config '{{ markdown-link-check-rc }}' \
      --quiet ...(fd '.*\.md' | lines)

    cd '{{ root }}'; cargo clippy -- -D warnings

test package *args:
    cd '{{ root }}'; cargo test --package {{ package }} {{ args }}
