# ADR-0001: Azure region and Saudi data residency
Status: Accepted | Date: 2026-09-27 | Deciders: Ibrahim, Marwan and Abdullah

## Context
We need to decide where to build and operate Tasreeh because applicants submit personal information and permit documents, C-01 requires real data to remain inside Saudi Arabia, and the team must still complete development and validation before an approved in-Kingdom Azure region is confirmed to support every required service. Related: NFR-01, NFR-04, C-01.

## Options

| Option | Good for us | Bad for us |
| --- | --- | --- |
| A: Deploy development and production to UAE North and use real applicant data | UAE North is an established nearby Azure region with availability zones and broad service support; the team can begin immediately | Real applicant data would leave Saudi Arabia and violate C-01, so this option cannot be approved |
| B: Stop all work until an in-Kingdom Azure region and every required service are available | Avoids building outside the final region and gives the clearest residency boundary | Delays architecture validation, automation, security testing, and team learning even though those activities can use synthetic data |
| C: Build and test in UAE North using synthetic data only; permit real-data production only after the municipality approves an Azure region inside Saudi Arabia and confirms the complete service matrix | Allows development and validation now without placing real data outside the Kingdom; Terraform keeps the region configurable; establishes a clear go-live gate | Requires a later regional validation and cutover exercise; the schedule depends on external region and service availability; the temporary environment cannot be used for real applications |

## Decision
We chose Option C. The team will use UAE North for development and production-like validation with synthetic data only. Real applicant, permit, and document data will be accepted only after the municipality approves an Azure region inside Saudi Arabia and verifies that App Service, Azure SQL Database, Storage, Functions, Key Vault, private endpoints, monitoring, and the required external integrations are supported. We rejected Option A because it violates C-01. We rejected Option B because it prevents safe work that does not require real data.

## Consequences
This makes architecture validation, Terraform validation, security testing, and team training possible now. This makes real-data go-live dependent on a formal residency and service-availability gate. We must keep the Azure region configurable, maintain synthetic test datasets, prevent production credentials and real applicant records from entering the UAE North environment, and update the SAD, physical diagram, pricing estimate, service-availability matrix, and `prod.tfvars` together when the in-Kingdom region is approved. Until that gate passes, the environment named `prod` is production-like validation only and is not authorized for real municipal applications.
