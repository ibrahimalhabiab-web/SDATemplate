# Tasreeh Municipal Permit Portal — Solution Architecture Document (SAD Lite)
Team: Team: Ibrahim, Marwan and Abdullah | Version: 1.0 | Date: 2026-09-27

## 1. Summary
This system helps ___ to ___. It runs on ___ in the ___ region.
It costs about ___ SAR per month in production. The main risk is ___.

## 2. Scope
In scope:
- ___
- ___
- ___

Out of scope:
- ___
- ___

## 3. Requirements

| ID | Requirement | Source |
| --- | --- | --- |
| FR-01 | The system must ___ | Client interview |
| FR-02 | The system must ___ | Client interview |
| FR-03 | The system must ___ | Client interview |
| FR-04 | The system must ___ | Client interview |
| FR-05 | The system must ___ | Client interview |
| FR-06 | The system must ___ | Client interview |
| NFR-01 | ___ must ___ within ___, measured ___ | Client interview |
| NFR-02 | ___ must ___ within ___, measured ___ | Client interview |
| NFR-03 | ___ must ___ within ___, measured ___ | Client interview |
| NFR-04 | ___ must ___ within ___, measured ___ | Client interview |
| NFR-05 | ___ must ___ within ___, measured ___ | Client interview |
| NFR-06 | ___ must ___ within ___, measured ___ | Client interview |
| C-01 | ___ | Brief / regulation |
| C-02 | ___ | Brief / regulation |
| A-01 | We assume ___. To confirm with ___. | Team |
| A-02 | We assume ___. To confirm with ___. | Team |

## 4. Context diagram

![Context diagram](diagrams/context.drawio.svg)

One box for the whole system: who uses it, and which external systems it talks to. No Azure services on this diagram.

## 5. Logical architecture

![Logical diagram](diagrams/logical.drawio.svg)

| Flow | From → To | What happens | Sync / Async |
| --- | --- | --- | --- |
| 1 | ___ → ___ | ___ | ___ |
| 2 | ___ → ___ | ___ | ___ |
| 3 | ___ → ___ | ___ | ___ |

## 6. Physical architecture

![Physical diagram](diagrams/physical.drawio.svg)

Region: ___   Subscription: ___   Resource group: ___

## 7. Data

| Dataset | Classification | Store | Location | Leaves the Kingdom? |
| --- | --- | --- | --- | --- |
| ___ | ___ | ___ | ___ | ___ |
| ___ | ___ | ___ | ___ | ___ |

## 8. Security

- [ ] Managed identities used by: ___
- [ ] Private endpoints for: ___
- [ ] No public network access to: ___
- [ ] WAF protects: ___
- [ ] Secrets stored in: ___
- [ ] Uploaded files scanned by: ___

Compliance (NCA / PDPL): ___

## 9. Reliability and cost

Target: ___% = (1 − ___) × 43,200 = ___ min downtime per month

Composite SLA: ___ × ___ × ___ = ___%  = ___ min per month  Meets target? ___

RTO target: ___   RPO target: ___

| Failure | How we recover | RTO achieved | RPO achieved | Meets? |
| --- | --- | --- | --- | --- |
| Zone outage | ___ | ___ | ___ | ___ |
| Data deleted | ___ | ___ | ___ | ___ |
| Region outage | ___ | ___ | ___ | ___ |

| Environment | Monthly cost (SAR) | Main cost driver |
| --- | --- | --- |
| dev | ___ | ___ |
| prod | ___ | ___ |

Pricing Calculator link: ___

## 10. Decisions

| ADR | Decision (one line) | File |
| --- | --- | --- |
| 0001 | Use the selected Azure region according to data-residency and service-availability requirements | docs/adr/0001-region.md |
| 0002 | Process and scan uploaded documents asynchronously | docs/adr/0002-file-processing.md |
| 0003 | Use Azure SQL Database for relational permit information | docs/adr/0003-data-store.md |

## 11. Risks

| Risk | Impact (H/M/L) | Mitigation | Owner |
| --- | --- | --- | --- |
| ___ | ___ | ___ | ___ |
| ___ | ___ | ___ | ___ |
| ___ | ___ | ___ | ___ |

## Appendix A. Operations and deployment (provided — edit names only)

### Environments

| Environment | Subscription | Resource group | Purpose |
| --- | --- | --- | --- |
| dev | sub-tasreeh-dev | rg-tasreeh-dev | Team testing, small SKUs |
| prod | sub-tasreeh-prod | rg-tasreeh-prod | Real applications |

### Deployment

- Terraform in `infra/`, one `.tfvars` file per environment.
- State stored in a locked Azure Storage account.
- GitHub Actions: `fmt`, `validate` and `plan` on every pull request; `apply` on
  merge to `main`, with manual approval for prod.

### Monitoring and alerts

| Alert | Threshold | Sent to |
| --- | --- | --- |
| Portal availability | < 99.9% over 1 hour | On-call Teams channel |
| Response time (p95) | > 2 s over 15 min | On-call Teams channel |
| Failed notifications (SMS/email) | > 5% over 15 min | Operations team |
| Malware detected in upload | Any | Security team |

All components send logs and metrics to one Log Analytics workspace (90-day retention).
