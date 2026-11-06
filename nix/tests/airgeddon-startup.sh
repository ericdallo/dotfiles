#!/usr/bin/env bash
# Sourced by installCheck with $0 set to the installed Airgeddon entrypoint.
set -euo pipefail

check_entrypoint=$0
check_tmpdir=$(mktemp -d)
trap 'rm -rf "$check_tmpdir"' EXIT
export HOME="$check_tmpdir"
export AIRGEDDON_DEBUG_MODE=false

# Load only definitions, never Airgeddon's traps/main or interface controls.
# Fail closed if the upstream boundary changes.
[[ $(grep -c '^#Script starts to execute stuff' "$check_entrypoint") == 1 ]]
# Upstream intentionally reads unset optional globals and is not nounset-safe.
set +u
# shellcheck disable=SC1090
source <(sed '/^#Script starts to execute stuff/,$d' "$check_entrypoint")

unset scriptfolder
set_script_paths
# These variables and functions are defined by the sourced Airgeddon script.
# shellcheck disable=SC2154
if [[ ! -r "${scriptfolder}${rc_file_name}" ]]; then
  printf 'Airgeddon cannot find its bundled configuration in %s\n' "$scriptfolder" >&2
  exit 1
fi
# shellcheck disable=SC2154
[[ -r "${scriptfolder}${language_strings_file}" ]]
# shellcheck disable=SC2154
[[ -r "${scriptfolder}${known_pins_dbfile}" ]]
# shellcheck disable=SC2154
[[ -d "${scriptfolder}${plugins_dir}" ]]
# Both the tmux restart and permanent-language lookup use this path.
# shellcheck disable=SC2154
[[ $(readlink -f "${scriptfolder}${scriptname}") == $(readlink -f "$check_entrypoint") ]]

# Ignore any machine-local /etc/airgeddonrc; verify the packaged defaults.
# Read by the sourced env_vars_initialization function.
# shellcheck disable=SC2034
osversionfile_dir="$check_tmpdir/"
env_vars_initialization
# shellcheck disable=SC2154
[[ "$rc_path" == "${scriptfolder}${rc_file_name}" ]]
# shellcheck disable=SC2154
[[ "$AIRGEDDON_AUTO_UPDATE" == false && "$AIRGEDDON_WINDOWS_HANDLING" == tmux ]]

check_language_strings
# shellcheck disable=SC2154
[[ "$language_file_found" == 1 && "$language_file_mismatch" == 0 ]]
initialize_language_strings
declare -F language_strings >/dev/null
get_current_permanent_language
# shellcheck disable=SC2154
[[ "$current_permanent_language" == "$language" ]]

printf 'Airgeddon startup resources OK: %s\n' "$check_entrypoint"
