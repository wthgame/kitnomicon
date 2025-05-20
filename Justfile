default:
    bun run dev

download-kit:
    lune run download-kit

docgen:
    lune run write-kit-modules
    lune run docgen-kit-objects
    lune run docgen-kit-std
