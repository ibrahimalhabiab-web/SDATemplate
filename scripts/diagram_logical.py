"""
Optional example: draw a logical architecture diagram with code instead of
draw.io, using the official Azure icon set bundled with the Python
`diagrams` library. This is the "diagrams as code" option from Module 3 —
useful if you want your diagram to live in version control as a script
rather than a binary file, and the diagram to be able to be regenerated
if the design changes.

This is NOT the recommended tool for the lab (draw.io is), and the SAD Lite
template expects docs/diagrams/logical.drawio.svg either way — if you use
this script, export the PNG it produces and re-save it as (or embed it via)
that file, or just use it to sanity-check your draw.io version.

Setup:
    pip install diagrams
    # Graphviz must also be installed (e.g. `brew install graphviz` on
    # macOS, or `apt install graphviz` on Ubuntu/Debian)

Run:
    python scripts/diagram_logical.py
    # writes tasreeh_logical.png next to this script

Edit the services and flows below to match YOUR design — this starting
point sketches one plausible Tasreeh flow (citizen upload -> malware scan
-> reviewer queue -> notification), matching the model-answer hints in the
instructor guide. Your team's actual design may differ.
"""

from diagrams import Diagram, Cluster, Edge
from diagrams.azure.compute import FunctionApps, AppServices
from diagrams.azure.network import FrontDoors
from diagrams.azure.storage import BlobStorage
from diagrams.azure.database import SQLDatabases
from diagrams.azure.integration import ServiceBus
from diagrams.azure.security import KeyVaults
from diagrams.azure.monitor import Monitor
from diagrams.azure.identity import Users
from diagrams.generic.blank import Blank

graph_attr = {"fontsize": "16", "bgcolor": "white"}

with Diagram(
    "Tasreeh — logical architecture (example)",
    filename="tasreeh_logical",
    show=False,
    direction="LR",
    graph_attr=graph_attr,
):
    citizen = Users("Citizen / business\n(applicant)")
    reviewer = Users("Municipality\nreviewer")
    sms_email = Blank("SMS / email provider\n(external)")

    with Cluster("rg-tasreeh-<env>"):
        fd = FrontDoors("Front Door\n+ WAF")
        app = AppServices("Portal web app")
        kv = KeyVaults("Secrets")
        sql = SQLDatabases("Applications DB")
        uploads = BlobStorage("Uploads\n(quarantine → clean)")
        scan_fn = FunctionApps("Malware scan\n(on upload)")
        notify_fn = FunctionApps("Notify\n(status change)")
        bus = ServiceBus("Status change\nqueue")
        mon = Monitor("Log Analytics")

    citizen >> Edge(label="1 HTTPS") >> fd
    fd >> Edge(label="2") >> app
    reviewer >> Edge(label="3") >> app

    app >> Edge(label="4 SAS upload") >> uploads
    uploads >> Edge(label="5 trigger", style="dashed") >> scan_fn
    scan_fn >> Edge(label="6 move if clean") >> uploads

    app >> Edge(label="7") >> sql
    app >> Edge(label="8") >> kv

    app >> Edge(label="9 status changed", style="dashed") >> bus
    bus >> Edge(label="10", style="dashed") >> notify_fn
    notify_fn >> Edge(label="11", style="dashed") >> sms_email

    app >> Edge(label="12 telemetry", style="dashed") >> mon
    scan_fn >> Edge(style="dashed") >> mon
    notify_fn >> Edge(style="dashed") >> mon

print("Wrote tasreeh_logical.png")
