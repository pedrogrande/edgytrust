# AGENTS.md

This file provides guidance to WARP (warp.dev) when working with code in this repository.

## Project Overview

EdgyTrust is an Astro 5 web application with React islands, Tailwind CSS v4, and shadcn/ui components.

## Development Commands

```bash
pnpm dev          # Start dev server (localhost:4321)
pnpm build        # Production build to dist/
pnpm preview      # Preview production build
```

## Adding shadcn/ui Components

```bash
pnpm dlx shadcn@latest add <component>    # Add from default registry
pnpm dlx shadcn@latest add <registry>/<component>  # Add from custom registry
```

Available custom registries (see components.json):
- `@8starlabs-ui` - 8starlabs UI components
- `@aceternity` - Aceternity UI components

## Architecture

### Tech Stack
- **Astro 5** - Static site framework with islands architecture
- **React 19** - Interactive components (islands)
- **Tailwind CSS v4** - Using new Vite plugin (`@tailwindcss/vite`), not PostCSS
- **shadcn/ui** - Component library (new-york style, stone base color)
- **Radix UI** - Accessible primitives underlying shadcn components

### Path Aliases
- `@/*` → `./src/*` (configured in tsconfig.json)

### Directory Structure
- `src/pages/` - Astro pages (file-based routing)
- `src/layouts/` - Astro layout components
- `src/components/` - Application components
- `src/components/ui/` - shadcn/ui primitives
- `src/lib/utils.ts` - `cn()` utility for class merging
- `src/styles/global.css` - Tailwind imports and CSS variables

### Component Patterns

**React components** (.tsx) are used for interactive islands. They must be explicitly hydrated in Astro files using `client:*` directives when interactivity is needed.

**Astro components** (.astro) are used for static content and layouts.

All UI components use the `cn()` utility from `@/lib/utils` for conditional class merging.

### Styling
- Tailwind v4 uses CSS-first configuration in `src/styles/global.css`
- Design tokens are defined as CSS variables (oklch color space)
- Dark mode uses `.dark` class variant
- Component styles use `class-variance-authority` for variants
