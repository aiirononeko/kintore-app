import type { Config } from 'tailwindcss'

export default {
  content: [
    './app/**/*.{js,ts,jsx,tsx}', // アプリケーション内のファイルを指定
  ],
  theme: {
    extend: {},
  },
  plugins: [],
  darkMode: 'media', // Changed from 'class' to 'media'
} satisfies Config
