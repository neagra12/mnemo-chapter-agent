```Mermaid
client[Browser] --> Internet


```
[Client (Browser)] <---- (The Internet) ----> [Server (Your Flask App)]

# Sample Mermaid Diagram

Below is a simple flowchart that shows a CI‑runner check:

```mermaid
flowchart TD
    A[Start] --> B{Runner installed?}
    B -- Yes --> C[Run test suite]
    B -- No  --> D[Install runner]
    C --> E[Report success]
    D --> B
    style A fill:#f9f,stroke:#333,stroke-width:2px
    style B fill:#ff9,stroke:#333,stroke-width:2px
    style C fill:#9f9,stroke:#333,stroke-width:2px
    style D fill:#f99,stroke:#333,stroke-width:2px
    style E fill:#9cf,stroke:#333,stroke-width:2px