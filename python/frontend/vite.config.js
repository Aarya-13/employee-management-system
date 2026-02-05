import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

export default defineConfig({
  plugins: [react()],
  server: {
    port: 3000,
    proxy: {
      '/api': {
        target: 'http://localhost:8000',
        changeOrigin: true,
        logLevel: 'debug',
        onProxyReq: (proxyReq, req, res) => {
          console.log('🔄 Proxy Request:', req.method, req.url, '-> http://localhost:8000' + req.url)
        },
        onProxyRes: (proxyRes, req, res) => {
          console.log('✅ Proxy Response:', req.method, req.url, proxyRes.statusCode)
        }
      }
    }
  }
})
