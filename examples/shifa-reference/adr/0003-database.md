# ADR-0003: Database for bookings
Status: Accepted | Date: (class date) | Deciders: Shifa project team

## Context
We need to decide which database stores appointments, patients and clinics,
because bookings must never double-book a slot, which requires transactions
across related rows.

## Options

| Option | Good for us | Bad for us |
| --- | --- | --- |
| A: Azure Cosmos DB | Very high scale and low latency globally | Bookings data is relational (patients, appointments, clinics, doctors); multi-row transactions are awkward; team has no NoSQL experience |
| B: Azure SQL Database | Native relational transactions prevent double-booking; team trained on it; supports private endpoints and managed identity | Less horizontally scalable than Cosmos DB at extreme scale, which Shifa does not need |

## Decision
We chose B — Azure SQL Database — because the core requirement (never
double-book a slot) needs relational transactions, and Shifa's scale (500
concurrent users, 12 clinics) does not need Cosmos DB's horizontal scale.
We rejected A because modelling transactional bookings on a NoSQL store adds
complexity for no benefit at this scale.

## Consequences
This makes correctness (no double-bookings) straightforward using standard
SQL transactions. This means Shifa is tied to Azure SQL's scaling model,
which is a General Purpose tier with zone redundancy — sufficient for the
NFRs in this SAD, but it should be revisited if Shifa's user base grows by
an order of magnitude.
