# ADR-0002: Processing and scanning uploaded permit documents
Status: Accepted | Date: 2026-09-27 | Deciders: Ibrahim, Marwan and Abdullah

## Context
We need to decide how Tasreeh validates and malware-scans uploaded permit documents because applicants may upload files up to 20 MB, reviewers must not open an unscanned file, and NFR-03 requires the portal to acknowledge an upload within 5 seconds while completing scanning within 2 minutes. Related: FR-03, NFR-03, NFR-06.

## Options

| Option | Good for us | Bad for us |
| --- | --- | --- |
| A: Scan and process each file synchronously inside the upload request | Simple sequence; applicant receives the final scan result before the request ends | Large or slow scans can exceed the 5-second acknowledgement target, create timeouts, couple portal availability to the scanner, and scale poorly during upload peaks |
| B: Store each upload in a quarantined location, publish an event, and scan and process it asynchronously with a Function before moving it to an approved state | Fast upload acknowledgement; independent scaling and retries; isolates scanner failures from the portal; provides a clear quarantine boundary | Adds event, status, retry, and monitoring logic; applicants and reviewers must understand pending, clean, rejected, and failed states |

## Decision
We chose Option B. Tasreeh will place every new upload in a non-public quarantined Blob Storage location with a `Pending scan` status. A storage event will trigger an asynchronous processing function and the approved malware-scanning service. Only a clean result changes the document to `Available for review`. Malware detections change the document to `Rejected`, retain only the evidence allowed by the security policy, and alert the security team. We rejected Option A because it risks missing NFR-03 and makes the interactive portal dependent on scanning duration.

## Consequences
This makes upload acknowledgement fast, permits independent scaling, and provides retry and quarantine controls. This makes the workflow more complex because the application must display processing status and prevent access while a document is pending. We must now define idempotent event handling, retry limits, a dead-letter path, scan timeouts, file-type and size validation, alerting for any malware result, and an operations procedure for documents that remain pending beyond 2 minutes.
