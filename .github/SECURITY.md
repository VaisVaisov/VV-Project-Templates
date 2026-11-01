# Security Policy

## Supported Versions

This repository contains project templates. Security fixes are applied to the latest version of each template.

| Template | Supported |
|----------|-----------|
| Latest   | Yes       |

## Reporting a Vulnerability

**Please do not report security vulnerabilities through public GitHub issues.**

To report a security issue:

1. Go to the [Security tab](../../security) of this repository
2. Click **"Report a vulnerability"**
3. Fill in the details

Alternatively, contact the maintainers directly via the contact information in the repository profile.

### What to Include

- Description of the vulnerability
- Steps to reproduce
- Potential impact
- Suggested fix (if any)

### Response Timeline

- **Acknowledgement**: within 48 hours
- **Assessment**: within 7 days
- **Fix/Patch**: within 30 days for critical issues

## Security Scanning

All templates include:
- **Trivy** filesystem scan in CI (HIGH/CRITICAL severity, blocks merge)
- **Dependabot** automated dependency updates
- Pre-commit hooks for secret detection (via `detect-secrets`)

## Disclosure Policy

We follow responsible disclosure. Once a fix is released, the issue will be publicly disclosed with credit to the reporter (unless they prefer to remain anonymous).
