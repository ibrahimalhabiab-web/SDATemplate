# ADR-0003: Data store for permit applications
Status: Accepted | Date: 2026-09-27 | Deciders: Ibrahim, Marwan and Abdullah

## Context
We need to decide where Tasreeh stores applicants, permit applications, workflow status, reviewer decisions, and audit references because those records have strong relationships and a permit submission must update several records consistently. Uploaded binary documents require a different storage pattern. Related: FR-02, FR-05, FR-06, NFR-04, C-01.

## Options

| Option | Good for us | Bad for us |
| --- | --- | --- |
| A: Azure Cosmos DB for all permit data and uploaded documents | Flexible document model, high horizontal scale, and globally distributed options | Permit, applicant, reviewer, decision, and audit information is relational; cross-entity transactions and reporting are more complex; storing large uploaded files in the database is inefficient; global distribution can conflict with residency controls |
| B: Azure SQL Database for structured permit and workflow data, plus Azure Blob Storage for uploaded documents | Relational constraints and transactions support consistent workflow updates; SQL reporting is familiar; point-in-time restore, private endpoints, managed identity, and auditing support the design; Blob Storage is purpose-built for documents | Requires schema and migration management; SQL and Blob lifecycle and recovery settings must be coordinated; horizontal scaling is less flexible than Cosmos DB at extreme scale |

## Decision
We chose Option B. Azure SQL Database will store applicants, applications, status history, reviewer decisions, document metadata, and audit references. Azure Blob Storage will store uploaded binary documents, and SQL will retain the document identifier, version, hash, scan status, and ownership relationship. We rejected Option A because Tasreeh's workflow is relational and transactional, the expected scale does not require Cosmos DB's global distribution, and uploaded binaries are better suited to Blob Storage.

## Consequences
This makes workflow consistency, reporting, access control, and point-in-time restore straightforward. This makes the team responsible for database schema migrations and for coordinating recovery between SQL metadata and Blob versions. We must now use private endpoints, managed identities, encryption, Blob versioning and soft delete, SQL point-in-time restore, tested backup procedures, and a data-access layer that never exposes a document unless its clean scan status is recorded.
