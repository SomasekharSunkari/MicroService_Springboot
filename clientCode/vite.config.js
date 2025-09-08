// vite.config.js
import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

export default defineConfig({
  plugins: [react()],
  server: {
    host: true,          // access from LAN/devices if needed
    port: 5173,
    strictPort: true,    // avoid port hopping
    // Use polling if file watchers are unreliable (VMs, WSL, network drives)
    watch: {
      usePolling: true,
      interval: 100
    },
    hmr: {
      overlay: true
    }
  }
})