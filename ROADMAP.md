# CAOCAP Azzam: Development Roadmap & Backlog

This document serves as the master checklist for our feature recommendations and overall project progress. It ensures we keep track of our brilliant ideas and systematically build out the "intent-driven IDE" vision.

## Core Philosophy: Command-First Interaction
- **The Omnibox is the OS:** The primary UX for CAOCAP Azzam is the AI-agent Omnibox. 
- **Universal Command Coverage:** Every action in the application—from exiting the playground and saving changes to closing/reopening the browser or even quitting the app—must be executable via text commands.
- **Intent-Driven UX:** While the UI is interactive, it exists to serve the intents captured and orchestrated by the Omnibox.

## Phase 1: The Foundations & Core Nodes
- [x] **Infinite Canvas Setup:** The root 100k x 100k scrolling workspace.
- [x] **Omnibox (Command Palette):** The intent-driven input system and floating AI button.
- [x] **Floating Browser UI (WebKit):** A high-fidelity, draggable, resizable floating window with advanced navigation and glassmorphic design.
- [ ] **Node Orchestration System:** A dynamic state manager to spawn, track, and interact with multiple node types on the canvas.
- [ ] **Code Editor Node:** A high-fidelity, syntax-highlighting editor node for viewing and modifying project files.
- [ ] **Terminal Node:** An embedded shell execution environment node for running build and git commands.

## Phase 2: The Agentic Brain
- [ ] **Agent Service Mock:** Scaffolding the service that takes text from the Omnibox and translates it into UI actions.
- [ ] **Remote LLM API Hookup:** Connect the Agent Service to external APIs (OpenAI/Gemini/Anthropic) to process dynamic commands.
- [ ] **Context Awareness:** Give the Agent the ability to "see" the canvas layout, read the Browser DOM, and understand the active Code Editor content.

## Phase 3: Advanced IDE Capabilities
- [ ] **Project Navigator / File System:** Ability to manage local directories and files.
- [ ] **Node-to-Node Data Flow:** E.g., The Code Editor Node automatically refreshes the Browser Node on save.
- [ ] **Plugin & Extension System:** Allowing the community to build custom tools and capabilities.

## Phase 4: The Intelligent Workspace
- [ ] **Local Knowledge Base:** Indexing project files and canvas history for RAG-powered agent context.
- [ ] **Voice-to-Intent:** Whisper integration for hands-free coding and commanding via the Omnibox.
- [ ] **Canvas "Time Travel":** A version control system for the workspace (like Git for your UI), allowing snapshots and session playback.
- [ ] **Premium UI/UX Polish:** Continuous refinement of glassmorphism, micro-animations, and haptics to ensure a world-class, premium feel.
