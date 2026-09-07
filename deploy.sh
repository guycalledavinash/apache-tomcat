#!/usr/bin/env bash
# Build and deploy the sample WAR to an existing Tomcat installation.

set -euo pipefail

readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly PROJECT_DIR="$SCRIPT_DIR/sample-app"
readonly WAR_FILE="$PROJECT_DIR/target/sample-app.war"

usage() {
    cat <<'EOF'
Usage: ./deploy.sh [TOMCAT_WEBAPPS_DIR]

Builds sample-app as a WAR and copies it to Tomcat's webapps directory.

Set the deployment directory using one of these options (in precedence order):
  1. The TOMCAT_WEBAPPS_DIR argument
  2. The TOMCAT_WEBAPPS_DIR environment variable
  3. $TOMCAT_HOME/webapps

Optional environment variables:
  TOMCAT_HOST  Host name printed in the application URL (default: localhost)
  TOMCAT_PORT  HTTP port printed in the application URL (default: 8080)
EOF
}

fail() {
    printf 'Error: %s\n' "$*" >&2
    exit 1
}

if [[ "${1:-}" == "--help" || "${1:-}" == "-h" ]]; then
    usage
    exit 0
fi

if [[ "$#" -gt 1 ]]; then
    usage >&2
    fail 'Expected zero or one argument.'
fi

command -v java >/dev/null 2>&1 || fail 'Java is required. Install a JDK and add java to PATH.'
command -v mvn >/dev/null 2>&1 || fail 'Maven is required. Install Maven and add mvn to PATH.'

webapps_dir="${1:-${TOMCAT_WEBAPPS_DIR:-}}"
if [[ -z "$webapps_dir" && -n "${TOMCAT_HOME:-}" ]]; then
    webapps_dir="$TOMCAT_HOME/webapps"
fi

if [[ -z "$webapps_dir" ]]; then
    usage >&2
    fail 'Set TOMCAT_HOME or TOMCAT_WEBAPPS_DIR, or provide TOMCAT_WEBAPPS_DIR as an argument.'
fi

[[ -d "$webapps_dir" ]] || fail "Tomcat webapps directory does not exist: $webapps_dir"
[[ -w "$webapps_dir" ]] || fail "Tomcat webapps directory is not writable: $webapps_dir"

printf 'Building sample application...\n'
mvn -f "$PROJECT_DIR/pom.xml" clean package

[[ -f "$WAR_FILE" ]] || fail "Expected WAR was not generated: $WAR_FILE"

destination="$webapps_dir/sample-app.war"
printf 'Deploying %s to %s...\n' "$WAR_FILE" "$destination"
cp "$WAR_FILE" "$destination"

tomcat_host="${TOMCAT_HOST:-localhost}"
tomcat_port="${TOMCAT_PORT:-8080}"
printf 'Deployment complete. Open http://%s:%s/sample-app/\n' "$tomcat_host" "$tomcat_port"
