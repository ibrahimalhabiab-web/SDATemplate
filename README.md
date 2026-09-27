# Tasreeh Municipal Permit Portal — Team Starter Repo

This is your team's starting point for the Day 2 lab. It contains the SAD Lite
template, an ADR template, a Terraform skeleton, a GitHub Actions pipeline that
checks your work automatically, and a reference example (a different, completed
project) to show you the standard of finish expected.

## What to do, in order

1. **Fork or copy this repo** to your team's own GitHub repository (see "Getting
   your own copy" below).
2. Fill in `docs/SAD.md` — this is your Solution Architecture Document (SAD Lite).
   Every `___` must be replaced. See the Learner Lab Handout for the sentence
   frames, the glossary and how much to write in each section.
3. Draw your three diagrams in [draw.io](https://app.diagrams.net) (desktop app,
   web app, or the VS Code extension) and save them as `.drawio.svg` directly
   into `docs/diagrams/`, using the exact file names already referenced from
   `docs/SAD.md`:
   - `docs/diagrams/context.drawio.svg`
   - `docs/diagrams/logical.drawio.svg`
   - `docs/diagrams/physical.drawio.svg`

   `scripts/diagram_logical.py` is an optional example of drawing the *logical*
   view with code instead (Module 3's "diagrams as code" option). You do not
   have to use it — draw.io is the recommended tool for the lab — but it shows
   how the Shifa logical diagram from class was actually generated, using the
   official Azure icon set bundled with the Python `diagrams` library.
4. Write at least three ADRs in `docs/adr/`, copying `docs/adr/0000-template.md`
   for each one. Keep `0000-template.md` in place as the template; do not delete it.
5. Fill in the two `___` blanks in `infra/env/dev.tfvars` and
   `infra/env/prod.tfvars` (region and a short project prefix). The rest of
   `infra/` is a minimal, valid skeleton: a resource group, a VNet with an app
   subnet and a private-endpoint subnet, and one placeholder PaaS resource
   (a storage account) reached only through a private endpoint — the same
   pattern taught in Module 3. Adapt it to the services your design actually
   uses; it only has to pass `terraform validate`, not `terraform apply`.
6. Push your changes. The `design-checks` GitHub Actions workflow
   (`.github/workflows/design-checks.yml`) runs on every push and pull request
   and fails if:
   - any required section heading is missing from `docs/SAD.md`
   - any `___` blank remains in `docs/SAD.md`
   - fewer than three files exist in `docs/adr/`
   - any of the three diagrams is missing from `docs/diagrams/`
   - the Terraform in `infra/` does not pass `fmt -check` and `validate`
7. When the workflow is green and you are happy with your SAD, tag the commit
   `v1.0` and let your instructor know.

## Repository structure

```
tasreeh-template/
├── README.md
├── docs/
│   ├── SAD.md                    ← your Solution Architecture Document (SAD Lite)
│   ├── glossary.md                key terms in English and Arabic
│   ├── adr/
│   │   └── 0000-template.md      ← copy this for each decision
│   └── diagrams/                  put your three .drawio.svg files here
├── infra/
│   ├── main.tf                    provider + resource group
│   ├── network.tf                 VNet, subnets, private endpoint pattern
│   ├── variables.tf
│   ├── outputs.tf
│   └── env/
│       ├── dev.tfvars
│       └── prod.tfvars
├── scripts/
│   └── diagram_logical.py         optional: draw the logical view with code
├── examples/
│   └── shifa-reference/           a DIFFERENT, completed example project —
│                                   for reference only, not a starting point
└── .github/workflows/
    └── design-checks.yml
```

## Getting your own copy

Ask your instructor whether this repo has been set up as a GitHub **template
repository**. If it has: go to the repo on GitHub, click **Use this template →
Create a new repository**, name it `tasreeh-<your-team-name>`, and clone it.

If it has not been set up as a template yet, your instructor can do so in one
step: **Settings → Template repository** (checkbox), after pushing this
folder's contents to a new GitHub repo. Each team then uses the button above.

## The reference example

`examples/shifa-reference/` is a completed SAD Lite for a *different* system
(a clinic booking platform), the one walked through in class. It shows the
standard of finish expected — depth of the requirements table, how the
diagrams are labelled, how an ADR is written — but it is not the Tasreeh
brief, and copying it will not produce a working Tasreeh SAD. Use it to check
your formatting and depth, not to copy content.
