# Homework 12: Full-Stack Decoupling (A17)

  * **Module:** 3
  * **Assignment:** 12 (A17)
  * **Topic:** Frontend Integration, Docker Multi-Service Orchestration, and API Consumption
  * **Points:** 10
  * **Due Date:** [Final Due Date]
  * **Type:** "Team Best"

## The "Why": Full-Stack Integration

You have successfully built an API service and a dedicated AI service. Now, you complete the API-First architecture by integrating a specialized **Frontend Client**. This demonstrates that your backend is truly decoupled and can be consumed by any technology (web, mobile, IoT).

## The "Team Best" Workflow

1.  **Start:** Assume the `Repo Admin` receives the `frontend-starter-kit.zip` from the instructor and unpacks it into a new folder named `frontend/` in the project root.
2.  **Branch:** The `Repo Admin` creates a branch `hw12-full-stack`.
3.  **Individual PRs:** Each student tackles the tasks, focusing on either the `docker-compose.yml` update or the JavaScript logic.
4.  **Merge & Log:** Select the best implementation for each part.

-----

## Core Task 1: Orchestrating the Frontend Service 🐳

The frontend application requires a Node.js environment. You must add a third service, `frontend`, to your `docker-compose.yml`.

1.  **Add `frontend` Service:**
      * Use a **Node.js image** (e.g., `node:18-alpine`).
      * Set the `build` context to your new `frontend/` directory.
      * Map the necessary port (`3000:3000`).
      * Set a crucial **Environment Variable** (`REACT_APP_API_URL`) that tells the frontend where the backend lives. Remember: the host is the Docker service name, not `localhost`.

<!-- end list -->

```yaml
version: '3.8'

services:
  # ... web service ...
  # ... db service ...
  # ... ai-service ...

  frontend:
    build:
      context: ./frontend
      dockerfile: Dockerfile
    ports:
      - "3000:3000"
    environment:
      # CRITICAL: Tell the frontend the backend's hostname inside the Docker network!
      - REACT_APP_API_URL=http://web:5000/api/jokes
    depends_on:
      - web # Wait for the web service (our API) to start.
```

2.  **Create Frontend `Dockerfile`:** Add a simple `Dockerfile` inside the `frontend/` folder to build the React application.

## Core Task 2: Consuming the API 📞

The starter kit contains a main component (`JokeList.js`) that currently displays mock data. You need to replace the mock data with a real API call.

1.  **Retrieve API URL:** Update the React component to read the API URL from the environment (using `process.env.REACT_APP_API_URL`).
2.  **Implement `fetch`:** Use the JavaScript `fetch` API inside a `useEffect` hook to call your Flask API endpoint (`/api/jokes`).
3.  **Handle State:** Store the JSON data received from the API into the component's state (`setJokes`).

### Core Task 3: Display and Iteration 🖼️

1.  **Update Rendering:** Modify the component's return block to dynamically map (iterate) over the `jokes` array stored in the component's state.
2.  **Display Fields:** Display the joke `body`, the `author_username`, and the **persisted `ai_rating`** you saved in A16.

### ⭐ Extra Credit (+2 Points): Filtering

Implement a small **search bar** or a **filter button** (e.g., "Show only jokes rated G-Rated") directly in the frontend component.

  * This requires manipulating the state in the frontend (`.filter()`) to hide jokes without making a new API call, demonstrating the power of a rich client application.

-----

## `CONTRIBUTIONS.md` Log Entry

```markdown
#### HW 12 (A17): Full-Stack Decoupling
* **Date:** 2025-XX-XX
* **Chosen PR:** [Link]
* **Justification:** [Why was this implementation chosen?]
* **Reflection:** Explain why the API URL inside the React code needed to be `http://web:5000...` instead of `http://localhost:5000...` when running with Docker Compose.
```

-----

## Rubric (For TA Use)

| Criteria | Points |
| :--- | :--- |
| **Task 1: Orchestration (docker-compose)** | / 4 |
| `frontend` service is correctly added to `docker-compose.yml`. Uses a Node image, maps port 3000, and includes the `REACT_APP_API_URL` environment variable pointing to the correct service name (`web`). |
| **Task 2: API Consumption (JavaScript)** | / 3 |
| Frontend code correctly reads the API URL from `process.env`. Implements a successful `fetch` request and handles the JSON response. |
| **Task 3: Display and Integration** | / 1 |
| Data is successfully rendered, iterating over the JSON array. Joke `body` and `ai_rating` are visible. |
| **Process & Log** | / 2 |
| Team process followed; `CONTRIBUTIONS.md` is complete, and the reflection question is answered accurately (Docker's internal DNS). |
| **EC: Frontend Filtering (+2 pts)** | / +2 |
| A filter function is implemented in the JavaScript that manipulates the local state (e.g., filtering by `ai_rating`) without calling the backend API. |
| **Total** | **/** 10 |
