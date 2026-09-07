# Reproducible Apache Tomcat deployment example

This repository demonstrates the smallest practical Tomcat deployment loop:
Maven builds a Java web application as a WAR, and `deploy.sh` copies that WAR
into Tomcat's `webapps` directory. It deliberately does **not** use the Tomcat
Manager GUI or store any credentials.

## What is included?

- `sample-app/` — a minimal Java Servlet application packaged as
  `sample-app.war`.
- `deploy.sh` — validates prerequisites, builds the WAR, validates the output,
  and deploys it to Tomcat.
- `configure-users` — a legacy reference containing roles only; it has no users
  or passwords and is not needed for this deployment method.

## Prerequisites

Install the following before deploying:

- A JDK compatible with Java 11 or newer (`java --version`).
- Apache Maven 3.6 or newer (`mvn --version`).
- A running Apache Tomcat 9 installation. The sample uses the Servlet 4
  (`javax.servlet`) API supplied by Tomcat 9.

Start Tomcat using the scripts provided by your Tomcat installation, for
example:

```bash
"$TOMCAT_HOME/bin/startup.sh"
```

The account running `deploy.sh` must be able to write to Tomcat's `webapps`
directory. No Manager application configuration is required.

## Deploy from a fresh clone

```bash
git clone <repository-url>
cd apache-tomcat
export TOMCAT_HOME=/path/to/apache-tomcat
./deploy.sh
```

`deploy.sh` uses `$TOMCAT_HOME/webapps` when `TOMCAT_HOME` is set. You can
instead pass the directory explicitly:

```bash
./deploy.sh /path/to/apache-tomcat/webapps
```

Or set `TOMCAT_WEBAPPS_DIR`:

```bash
TOMCAT_WEBAPPS_DIR=/path/to/apache-tomcat/webapps ./deploy.sh
```

The script builds `sample-app/target/sample-app.war`, copies it to
`webapps/sample-app.war`, and prints the expected URL. By default that URL is:

```
http://localhost:8080/sample-app/
```

Set `TOMCAT_HOST` or `TOMCAT_PORT` if your server is reachable elsewhere or is
configured on a different port:

```bash
TOMCAT_HOST=tomcat.example.test TOMCAT_PORT=8081 ./deploy.sh
```

Tomcat watches `webapps` and expands the WAR automatically. Refresh the URL
after deployment to see the success page. The page links to `/status`, a small
Servlet endpoint that confirms the Java application is running.

## Build without deploying

To inspect the generated artifact without copying it to Tomcat:

```bash
mvn -f sample-app/pom.xml clean package
```

## Troubleshooting

- **`java` or `mvn` not found:** Install a JDK and Maven, then ensure both are
  on `PATH`.
- **Webapps directory does not exist:** Check `TOMCAT_HOME`,
  `TOMCAT_WEBAPPS_DIR`, or the path argument.
- **Permission denied:** Run the script as the Tomcat owner or grant the
  deployment account write access to `webapps`.
- **Page is not available yet:** Confirm Tomcat is running and inspect its logs
  (usually `$TOMCAT_HOME/logs`) for deployment errors.
