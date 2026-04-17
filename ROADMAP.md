# CAOCAP Azzam: Development Roadmap & Backlog

This document serves as the master checklist for our feature recommendations and overall project progress. It ensures we keep track of our brilliant ideas and systematically build out the "intent-driven IDE" vision.

## Phase 1: The Foundations & Core Nodes
- [x] **Infinite Canvas Setup:** The root 100k x 100k scrolling workspace.
- [x] **Omnibox (Command Palette):** The intent-driven input system and floating AI button.
- [ ] **Browser Node (WebKit Integration):** A draggable, resizable `WKWebView` node on the canvas to explore the web.
- [ ] **Code Editor Node:** A lightweight syntax-highlighting text editor node to view and modify code.
- [ ] **Terminal Node:** An embedded shell execution environment node to run build commands.

## Phase 2: The Agentic Brain
- [ ] **Agent Service Mock:** Scaffolding the service that takes text from the Omnibox and translates it into UI actions.
- [ ] **Remote LLM API Hookup:** Connect the Agent Service to external APIs (OpenAI/Gemini/Anthropic) to process dynamic commands.
- [ ] **Context Awareness:** Give the Agent the ability to "see" the canvas, read the DOM of the Browser Node, and read the Code Editor Node.

## Phase 3: Advanced IDE Capabilities
- [ ] **Project Navigator / File System:** Ability to manage local directories and files.
- [ ] **Node-to-Node Data Flow:** E.g., The Code Editor Node automatically refreshes the Browser Node on save.
- [ ] **Plugin & Extension System:** Allowing the community to build custom tools and capabilities.
