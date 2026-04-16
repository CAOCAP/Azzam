<img width="100" height="100" alt="logo" src="https://github.com/user-attachments/assets/eaf5e37f-da13-49aa-8e5f-d982116b15c4" /> <img width="100" height="100" alt="Azzam-dev" src="https://github.com/user-attachments/assets/f156f7ce-263b-4032-b999-cf59ad3184e6" />


# CAOCAP Azzam: Next-Gen Agentic Web IDE 
> **An ambitious open-source initiative redefining web interaction and development.**

**A browser, code editor, terminal, AI-Agent, and more combined into one super app that enables you to explore the web, modify any website you go to, and build your own website with an Agentic AI co-Captain.**

## The Intent-Driven Interface
CAOCAP/Azzam abandons the complex, cluttered menus of traditional IDEs. When you open the app, you are greeted with a single, simple text field. You don't manage windows—you state your intention. Whether you type *"Go to GitHub"* or *"Build me a landing page,"* the interface dynamically morphs into exactly what you need at that moment.

## The Three Pillars
* 🌐 **Explore:** A fully functional web browser built right in. Navigate the web seamlessly without ever leaving your workspace.
* 🏗️ **Build:** A completely integrated code editor and terminal. Modify any external website on the fly or build your own from the ground up with the help of your Agentic Co-Captain.
* 🤝 **Collaborate:** Connect and create alongside your AI agent and the open-source community to continuously shape and define the web ecosystem.

## Platform & Technology
* **Ecosystem Native:** Designed as a primary native macOS application, with extending experiences crafted for iPadOS and iOS mobility.
* **Apple Stack:** Built utilizing Swift and SwiftUI to ensure a seamless, high-performance, and unified interface across Apple devices.
* **Browser Engine:** Powered by Apple's native WebKit (`WKWebView`) for lightning-fast, resource-efficient web exploration.
* **Agentic Brain:** The Co-Captain's intelligence is fueled by cutting-edge remote LLMs (such as Gemini, ChatGPT, and Claude), integrated via APIs to ensure the most powerful and up-to-date reasoning capabilities.

## ⚠️ Development Status: Day 1
This project is in its absolute infancy. We are currently building the foundational proof-of-concept.
> If you are reading this, you are discovering the project at its inception. We welcome early visionaries, engineers, and contributors to join us at the ground level and help shape the future of this platform.

## Contribution Guidelines & Git Workflow
To maintain a high-quality codebase and clean history, we adhere to the following Git workflow:

### Branching Strategy
* **`main`**: The primary, stable branch. Always deployable.
* **`develop`**: The integration branch for new features before they hit `main`.
* **`feature/<name>`**: For new features (branch off `develop`, merge into `develop`).
* **`fix/<name>`**: For bug fixes.
* **`refactor/<name>`**: For code structure changes without behavioral changes.

### Conventional Commits
We strictly use [Conventional Commits](https://www.conventionalcommits.org/). When committing, use the configured template to structure your message:
* `feat:` (New feature)
* `fix:` (Bug fix)
* `refactor:` (Code refactor)
* `docs:` (Documentation changes)
* `chore:` (Build process, tooling, maintenance)

*Example*: `feat(ui): add animated empty states to projects list`
