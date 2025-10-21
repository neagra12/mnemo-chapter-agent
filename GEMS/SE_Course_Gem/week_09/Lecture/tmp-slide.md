Elevating the **HTTP Verb discussion** to its own slide is an **excellent strategic move** for your lecture. It transforms the concept from a quick speaker note into a high-impact lesson on **security and protocol design**, directly reinforcing the value of the web framework.

Here is the proposed slide content and corresponding notes, which would likely fit best immediately after your "HTTP is Stateless, Your App is Not" slide.

***

## Proposed Slide: Identity & The Security of HTTP Verbs

### **1. The Core Question: How Do We Log In?**

* We must send sensitive data (username/password) to establish the initial session.
* **Which verb is correct, and why?** (`GET` or `POST`)

### **2. The Danger of `GET`** ⚠️

| Verb | Data Location | Security Risk (Side-Channel Leakage) |
| :--- | :--- | :--- |
| **`GET`** | **In the URL** (`/login?user=X&pass=Y`) | **High Risk:** Credentials are saved in: **Browser History**, **Server Logs**, and **Proxy Caches**. |
| **`POST`** | **In the Request Body** | **Low Risk:** Data is *not* saved in the URL's typical storage locations. |

### **3. The Two-Step Solution**

1.  **Establish Identity (Login):** Use **`POST`**. This is a **write** operation that begins the session and protects the credentials from logging/caching.
2.  **Offer Identity (Ongoing Session):** Use **`GET`** (for reading) or **`POST`** (for writing). The actual identity (the **Session ID**) is safely carried in an **HTTP Header (Cookie)** on every request, allowing the application to maintain state.

***

## Speaker Notes for the New Slide

"This slide connects two core ideas: the need for state, and the security implications of HTTP verbs."

"The most critical security decision is how we handle the **initial login**. We need to send sensitive identity data—username and password. Technically, you *can* do this with a **`GET`** request, by putting the credentials right there in the URL. But this is a massive security failure."

"Why? Because the URL is saved everywhere. Every proxy server, every browser's history, and every web server's access log saves the full URL string. If you use `GET`, you are permanently writing the user's password to all those logs. We call this **Side-Channel Leakage**." 

"Therefore, we use **`POST`**. `POST` sends data in the request **body**, which is *not* saved in those typical logging/caching layers. This is the **correct engineering decision** that prioritizes security."

"Crucially, once you're logged in, the identity is no longer carried by the password or the verb, but by the **Session ID** hidden in the **Cookie Header**. This mechanism allows you to use `GET` for reading data while the **framework** ensures your identity is securely validated on every single call."