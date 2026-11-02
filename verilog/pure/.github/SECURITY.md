# Security Policy

## Reporting a Vulnerability

**Do not report security vulnerabilities through public GitHub issues.**

To report a security issue:
1. Go to the [Security tab](../../security) of this repository
2. Click **"Report a vulnerability"**

### Response Timeline

- **Acknowledgement**: within 48 hours
- **Fix**: within 30 days for critical issues

## Security Measures in This Template

- **Trivy** CI scan (HIGH/CRITICAL, blocks merge)
- **Dependabot** for automated dependency updates
- **detect-secrets** pre-commit hook
- **Valgrind** memcheck pre-commit hook
- **cppcheck** static analysis in CI
