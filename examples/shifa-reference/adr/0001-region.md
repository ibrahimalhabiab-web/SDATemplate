# ADR-0001: Azure region for production
Status: Accepted | Date: (class date) | Deciders: Shifa project team

## Context
We need to decide which Azure region to deploy to, because C-01 requires
patient data to stay in Saudi Arabia, but Saudi Arabia East is not yet open
to customers (expected November 2026). Related: NFR-01, C-01.

## Options

| Option | Good for us | Bad for us |
| --- | --- | --- |
| A: Deploy now to UAE North with real patient data | Fast, no waiting | Breaks C-01 immediately |
| B: Wait for Saudi Arabia East before building anything | Fully compliant from day one | Delays the whole project by months |
| C: Build and test in UAE North with synthetic data now; go live with real data in Saudi Arabia East once it opens | Lets the team build and test now, stays compliant for real data | Requires re-checking that Saudi Arabia East supports every service we use, and a cutover plan |

## Decision
We chose C — build in UAE North with synthetic data now, go live with real
patient data in Saudi Arabia East — because it lets the team keep working
without breaching C-01, and the cutover is a region change in Terraform, not
a redesign. We rejected A because it violates the PDPL-driven constraint.
We rejected B because it stalls the project for months with no offsetting
benefit.

## Consequences
This makes progress possible now. This makes go-live dependent on a
Microsoft timeline outside our control, and requires the team to confirm
each Azure service on our physical diagram is available in Saudi Arabia
East before cutover. We must now track that region's availability monthly
(see risk R-01) and keep the region as a Terraform variable, not hard-coded.
