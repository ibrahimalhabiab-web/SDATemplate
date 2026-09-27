# ADR-0002: Compute platform for the booking web app
Status: Accepted | Date: (class date) | Deciders: Shifa project team

## Context
We need to decide how to run the booking web app and reminder job, because
the team is three people with about one year of Azure experience, and the
system has one web app and one background job.

## Options

| Option | Good for us | Bad for us |
| --- | --- | --- |
| A: Azure Kubernetes Service (AKS) | Maximum flexibility; industry-standard for large systems | Steep operational load (cluster upgrades, networking, scaling policies) for a 3-person team; overkill for one app |
| B: Azure Container Apps | Less to manage than AKS; still container-based | Team has no container experience yet; adds a packaging step for no clear benefit here |
| C: Azure App Service (with a Function App for the reminder job) | Team already trained on it in the bootcamp; minimal operational load; built-in VNet integration and managed identity | Less flexible than Kubernetes for very large or multi-language systems |

## Decision
We chose C — App Service plus a Function App — because it matches the
team's existing skills and keeps operational load low, which matters more
here than Kubernetes-level flexibility. We rejected A because the
operational cost of running AKS is not justified for one web app and one
scheduled job. We rejected B because it adds container packaging with no
benefit for this workload.

## Consequences
This makes deployment and day-to-day operation simple, and the team can
support it without new training. This makes a future move to
microservices or very high scale harder, so we must revisit this decision
if Shifa expands to many independent services.
